import SpriteKit
import GameplayKit

// MARK: - Физические категории

struct PhysicsCategory {
    static let bullBody: UInt32   = 0x1 << 0
    static let bullHead: UInt32   = 0x1 << 1
    static let projectile: UInt32 = 0x1 << 2
    static let wall: UInt32       = 0x1 << 3
}

// MARK: - Перечисления

enum Turn {
    case player
    case opponent
}

enum SuperPowerMode {
    case none
    case doubleDamage
    case shield
    case superThrow
    case healing
}

// MARK: - GameScene

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /// Минимальная сила при начале зарядки
    var forceMin: CGFloat = 20
    /// Максимальная сила
    var forceMax: CGFloat = 100
    /// Текущая сила (накапливается во время удержания)
    var forceValue: CGFloat = 20
    /// Скорость набора силы (единиц в секунду)
    var chargeRate: CGFloat = 50
    
    /// Флаг того, что происходит зарядка силы (удержание пальца)
    var isCharging = false
    
    /// Фиксированный угол броска (в градусах)
    let fixedAngle: CGFloat = 45
    
    /// Узел для отображения индикатора силы (дуга)
    var forceGauge = SKShapeNode()
    
    /// Для расчёта времени между кадрами
    var lastUpdateTime: TimeInterval = 0
    
    /// Связь со SwiftUI (например, через viewModel, если требуется)
    weak var viewModel: GameViewModel?
    var storeVM = StoreViewModelDC()
    /// Текущий режим суперспособности (не используется в данном примере – для расширения)
    var superPowerMode: SuperPowerMode = .none
    
    /// Спрайты быков
    var playerBull: SKSpriteNode!
    var opponentBull: SKSpriteNode!
    
    /// Очередность хода
    var currentTurn: Turn = .player
        
    // MARK: - Жизненный цикл сцены
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        
        setupArena()
        setupBulls()
        setupForceGauge()
        
        // Если viewModel подключён – можно задать ветер
        if viewModel != nil {
            viewModel?.windValue = CGFloat.random(in: -8...8)
        }
    }
    
    
    // MARK: - Настройка арены
    
    func setupArena() {
        let wallNode = SKSpriteNode(imageNamed: "wallDC")
        wallNode.size = CGSize(width: 50, height: 172)
        wallNode.position = CGPoint(x: size.width / 2, y: 170/2)
        wallNode.zPosition = 2
        
        wallNode.physicsBody = SKPhysicsBody(rectangleOf: wallNode.size)
        wallNode.physicsBody?.isDynamic = false
        wallNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wallNode.physicsBody?.collisionBitMask = PhysicsCategory.projectile
        
        addChild(wallNode)
    }
    
    
    // MARK: - Настройка быков
    
    func setupBulls() {
        guard let skinItem = storeVM.currentSkinItem else { return }
        // Игрок
        playerBull = SKSpriteNode(imageNamed: skinItem.image)
        // Приводим высоту изображения к 170 с сохранением пропорций
        let scalePlayer = 170 / playerBull.size.width
        playerBull.size = CGSize(width: playerBull.size.width * scalePlayer, height: 170)
        // Размещаем игрока слева
        playerBull.position = CGPoint(x: playerBull.size.width/2 + 60, y: 170/2 + 20)
        playerBull.zPosition = 3
        addChild(playerBull)
        
        // Добавляем «голову» для критических попаданий (рисуется как красный круг)
        let playerHead = SKShapeNode(circleOfRadius: playerBull.size.width * 0.2)
        playerHead.fillColor = .clear
        playerHead.strokeColor = .clear
        playerHead.position = CGPoint(x: 0, y: playerBull.size.height * 0.3)
        playerHead.name = "playerHead"
        playerHead.physicsBody = SKPhysicsBody(circleOfRadius: playerBull.size.width * 0.2)
        playerHead.physicsBody?.isDynamic = false
        playerHead.physicsBody?.categoryBitMask = PhysicsCategory.bullHead
        playerBull.addChild(playerHead)
        
        // Соперник
        guard let viewModel = viewModel else { return }
        opponentBull = SKSpriteNode(imageNamed: viewModel.opponentBullImage())
        opponentBull.size = CGSize(width: opponentBull.size.width * scalePlayer, height: 170)
        opponentBull.position = CGPoint(x: size.width - (opponentBull.size.width/2 + 60), y: 170/2 + 20)
        opponentBull.zPosition = 3
        addChild(opponentBull)
        
        let opponentHead = SKShapeNode(circleOfRadius: opponentBull.size.width * 0.2)
        opponentHead.fillColor = .clear
        opponentHead.strokeColor = .clear
        opponentHead.position = CGPoint(x: 0, y: opponentBull.size.height * 0.3)
        opponentHead.name = "opponentHead"
        opponentHead.physicsBody = SKPhysicsBody(circleOfRadius: opponentBull.size.width * 0.2)
        opponentHead.physicsBody?.isDynamic = false
        opponentHead.physicsBody?.categoryBitMask = PhysicsCategory.bullHead
        opponentBull.addChild(opponentHead)
    }
    
    
    // MARK: - Настройка индикатора силы (force gauge)
    
    func setupForceGauge() {
        // Выбираем заполняемую фигуру красного цвета
        forceGauge.fillColor = .red
        forceGauge.strokeColor = .clear
        forceGauge.zPosition = 10
        forceGauge.isHidden = true // по умолчанию скрыт
        // Разместим индикатор в верхней части экрана (можно изменить позицию по желанию)
        forceGauge.position = CGPoint(x: 100, y: size.height * 0.75)
        addChild(forceGauge)
    }
    
    /// Рисуем дугу, представляющую процент заполнения силы (от 0 до 100%)
    func updateForceGauge() {
        // Вычисляем долю силы (от 0 до 1)
        let fraction = (forceValue - forceMin) / (forceMax - forceMin)
        let clamped = max(0, min(1, fraction))
        
        // Определим дугу:
        // Начинаем от -90° (т.е. -π/2) и рисуем дугу, пропорциональную значению силы.
        let startAngle = -CGFloat.pi / 2
        // Максимально можно нарисовать дугу в 180° (π радиан) при полном заряде
        let arcAngle = CGFloat.pi * clamped
        let endAngle = startAngle + arcAngle
        
        let radius: CGFloat = 40
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        // Рисуем дугу с центром в (0,0)
        path.addArc(withCenter: .zero,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        path.close()
        
        forceGauge.path = path.cgPath
    }
    
    
    // MARK: - Сброс и обновление сцены
    func resetScene() {
        removeAllChildren()
        removeAllActions()
        
        // Сбрасываем управляющие переменные:
        superPowerMode = .none
        isCharging = false
        forceValue = forceMin
        lastUpdateTime = 0
        currentTurn = .player  // или установить тот ход, который нужен по умолчанию
        
        // Перестраиваем арену, быков, индикатор силы и (при необходимости) индикаторы хода
        setupArena()
        setupBulls()
        setupForceGauge()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Вычисляем интервал времени с момента последнего кадра
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Если идёт зарядка (удержание пальца), увеличиваем силу броска
        if isCharging {
            forceValue += CGFloat(dt) * chargeRate
            if forceValue > forceMax {
                forceValue = forceMax
            }
            updateForceGauge()
        }
        
        // Применяем ветер к снарядам (если viewModel содержит windValue)
        if let windVal = viewModel?.windValue {
            for node in children {
                if let sprite = node as? SKSpriteNode, sprite.name == "projectile" {
                    sprite.physicsBody?.applyForce(CGVector(dx: windVal, dy: 0))
                }
            }
        }
    }
    
    
    // MARK: - Запуск снаряда (фиксированный угол 45°)
    
    /// Запускает снаряд с накопленной силой и фиксированным углом
    func launchProjectile(from position: CGPoint, force: CGFloat, angle: CGFloat = 45, isPlayer: Bool = true) {
        guard let throwItem = storeVM.currentThrowItem else { return }
        let projectile = SKSpriteNode(imageNamed: throwItem.image)
        projectile.size = CGSize(width: 50, height: 50)
        projectile.name = "projectile"
        projectile.zPosition = 4
        
        // Смещаем стартовую позицию, чтобы снаряд не появлялся внутри быка
        var startPos = position
        if isPlayer {
            startPos.x += 50
            startPos.y += 50
        } else {
            startPos.x -= 50
            startPos.y += 50
        }
        projectile.position = startPos
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        projectile.physicsBody?.affectedByGravity = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.bullBody | PhysicsCategory.bullHead | PhysicsCategory.wall
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.bullBody | PhysicsCategory.bullHead | PhysicsCategory.wall
        addChild(projectile)
        
        let radians = angle * (.pi / 180)
        let dx = cos(radians) * force * (isPlayer ? 1 : -1)
        let dy = sin(radians) * force
        projectile.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
        superPowerMode = .none
        viewModel?.resetPower()
        // После броска переключаем ход
        if isPlayer {
            currentTurn = .opponent
            run(SKAction.wait(forDuration: 2.0)) { [weak self] in
                self?.aiTurn()
            }
        } else {
            currentTurn = .player
        }
    }
    
    
    // MARK: - Простой ИИ (выбирает случайную силу)
    
    func aiTurn() {
        let randomForce = CGFloat.random(in: 20...40)
        launchProjectile(from: opponentBull.position, force: randomForce, angle: 45, isPlayer: false)
    }
    
    
    // MARK: - Обработка столкновений
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Если снаряд столкнулся со стеной – удаляем его
        if (contact.bodyA.categoryBitMask == PhysicsCategory.projectile && contact.bodyB.categoryBitMask == PhysicsCategory.wall) ||
            (contact.bodyB.categoryBitMask == PhysicsCategory.projectile && contact.bodyA.categoryBitMask == PhysicsCategory.wall) {
            if contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
            return
        }
        
        var projectileNode: SKNode?
        var bullNode: SKNode?
        var isHeadHit = false
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.projectile {
            projectileNode = contact.bodyA.node
            bullNode = contact.bodyB.node
            if contact.bodyB.categoryBitMask == PhysicsCategory.bullHead {
                isHeadHit = true
            }
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.projectile {
            projectileNode = contact.bodyB.node
            bullNode = contact.bodyA.node
            if contact.bodyA.categoryBitMask == PhysicsCategory.bullHead {
                isHeadHit = true
            }
        }
        
        
        if isHeadHit {
            viewModel?.playerDamage *= 1.5
            viewModel?.opponentDamage *= 1.5 }
        
        if let hitBull = bullNode {
            if hitBull.parent == playerBull {
                viewModel?.playerHealth -= viewModel?.opponentDamage ?? 5
                if let health = viewModel?.playerHealth, health <= 0 {
                    gameOver(winner: "Opponent")
                }
            } else if hitBull.parent == opponentBull {
                viewModel?.opponentHealth -= viewModel?.playerDamage ?? 5
                if let health = viewModel?.opponentHealth, health <= 0 {
                    gameOver(winner: "Player")
                }
            }
        }
        
        projectileNode?.removeFromParent()
    }
    
    // MARK: - Завершение игры
    
    func gameOver(winner: String) {
        viewModel?.gameOver = true
        if winner == "Player" {
            viewModel?.playerWin = true
        } else {
            viewModel?.playerWin = false
        }
    }
    
    
    // MARK: - Управление касаниями: заряд силы при удержании
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Начинаем зарядку только если сейчас ход игрока
        guard currentTurn == .player else { return }
        isCharging = true
        forceValue = forceMin
        forceGauge.isHidden = false
        updateForceGauge()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isCharging else { return }
        isCharging = false
        forceGauge.isHidden = true
        
        // Запускаем снаряд с накопленной силой и фиксированным углом 45°
        launchProjectile(from: playerBull.position,
                         force: forceValue,
                         angle: fixedAngle,
                         isPlayer: true)
    }
}
