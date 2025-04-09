import SpriteKit
import GameplayKit


// MARK: - GameScene

class FriendGameScene: SKScene, SKPhysicsContactDelegate {
    
    // -------------------------------------------------------------
    // MARK: - Параметры для силы броска (charge)
    // -------------------------------------------------------------
    /// Минимальная сила при начале зарядки
    var forceMin: CGFloat = 20
    /// Максимальная сила
    var forceMax: CGFloat = 100
    /// Текущая сила (накапливается во время удержания)
    var forceValue: CGFloat = 20
    /// Скорость набора силы (единиц в секунду)
    var chargeRate: CGFloat = 50
    /// Флаг того, что происходит зарядка (удержание пальца)
    var isCharging = false
    /// Фиксированный угол броска (в градусах)
    let fixedAngle: CGFloat = 45
    /// Узел для отображения индикатора силы (дуга)
    var forceGauge = SKShapeNode()
    /// Время последнего обновления (для расчёта dt)
    var lastUpdateTime: TimeInterval = 0
    
    
    // -------------------------------------------------------------
    // MARK: - Основные свойства игры
    // -------------------------------------------------------------
    /// Связь со SwiftUI (например, через viewModel, если требуется)
    weak var viewModel: GameViewModel?
    /// Для работы магазина/скинов (если требуется)
    var storeVM = StoreViewModelDC()
    
    /// Текущий режим суперспособности (расширение функционала)
    var superPowerMode: SuperPowerMode = .none
    
    /// Спрайты быков – игрока (слева) и соперника (справа)
    var playerBull: SKSpriteNode!
    var opponentBull: SKSpriteNode!
    
    /// Индикаторы хода – красный треугольник, показывающий чей ход
    var playerIndicator: SKShapeNode!
    var opponentIndicator: SKShapeNode!
    
    /// Очередность хода
    var currentTurn: Turn = .player {
        didSet {
            updateTurnIndicator()
        }
    }
    
    
    // MARK: - Жизненный цикл сцены
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        setupArena()
        setupBulls()
        setupForceGauge()
        
        // При старте задаём случайное значение ветра (если viewModel подключён)
        if viewModel != nil {
            DispatchQueue.main.async {
                self.viewModel?.windValue = CGFloat.random(in: -8...8)
            }
        }
    }
    
    
    // MARK: - Настройка арены
    
    func setupArena() {
        let wallNode = SKSpriteNode(imageNamed: "wallDC")
        wallNode.size = CGSize(width: DeviceInfo.shared.deviceType == .pad ? 100:50, height: DeviceInfo.shared.deviceType == .pad ? 344:172)
        wallNode.position = CGPoint(x: size.width / 2, y: DeviceInfo.shared.deviceType == .pad ? 340/2:170/2)
        wallNode.zPosition = 2
        
        wallNode.physicsBody = SKPhysicsBody(rectangleOf: wallNode.size)
        wallNode.physicsBody?.isDynamic = false
        wallNode.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wallNode.physicsBody?.collisionBitMask = PhysicsCategory.projectile
        
        addChild(wallNode)
    }
    
    
    // MARK: - Настройка быков и индикатора хода
    
    func setupBulls() {
        
        // Для игрока используем скин из магазина
        guard let skinItem = storeVM.currentSkinItem else { return }
        let bullHeight: CGFloat = DeviceInfo.shared.deviceType == .pad ? 340: 170
        let margin60: CGFloat = DeviceInfo.shared.deviceType == .pad ? 120: 60
        let margin20: CGFloat = DeviceInfo.shared.deviceType == .pad ? 40: 20

        // Игрок (слева)
        playerBull = SKSpriteNode(imageNamed: skinItem.image)
        // Приводим высоту к 170, масштабируем по ширине соответственно (в данном случае масштаб рассчитывается по ширине)
        let scalePlayer = bullHeight / playerBull.size.width
        playerBull.size = CGSize(width: playerBull.size.width * scalePlayer, height: bullHeight)
        // Размещаем игрока слева
        playerBull.position = CGPoint(x: playerBull.size.width/2 + margin60, y: bullHeight/2 + margin20)
        playerBull.zPosition = 3
        addChild(playerBull)
        
        // Добавляем "голову" для критических попаданий
        let playerHead = SKShapeNode(circleOfRadius: playerBull.size.width * 0.2)
        playerHead.fillColor = .clear
        playerHead.strokeColor = .clear
        playerHead.position = CGPoint(x: 0, y: playerBull.size.height * 0.3)
        playerHead.name = "playerHead"
        playerHead.physicsBody = SKPhysicsBody(circleOfRadius: playerBull.size.width * 0.2)
        playerHead.physicsBody?.isDynamic = false
        playerHead.physicsBody?.categoryBitMask = PhysicsCategory.bullHead
        playerBull.addChild(playerHead)
        
        // Индикатор хода для игрока – красный треугольник
        playerIndicator = createTurnIndicator()
        // Размещаем над игроком (например, сверху, с небольшим смещением)
        playerIndicator.position = CGPoint(x: 0, y: playerBull.size.height/2 + 10)
        playerBull.addChild(playerIndicator)
        
        
        // Соперник (справа)
        guard let viewModel = viewModel else { return }
        opponentBull = SKSpriteNode(imageNamed: viewModel.opponentBullImage())
        // Пропорционально уменьшаем изображение (используем тот же scalePlayer)
        opponentBull.size = CGSize(width: opponentBull.size.width * scalePlayer, height: bullHeight)
        opponentBull.position = CGPoint(x: size.width - (opponentBull.size.width/2 + margin60), y: bullHeight/2 + margin20)
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
        
        // Индикатор хода для соперника
        opponentIndicator = createTurnIndicator()
        opponentIndicator.position = CGPoint(x: 0, y: opponentBull.size.height/2 + 10)
        opponentBull.addChild(opponentIndicator)
        
        // Изначально ход у игрока, поэтому индикатор соперника скрыт
        updateTurnIndicator()
    }
    
    /// Создаёт красный треугольник (SKShapeNode) для индикатора хода
    func createTurnIndicator() -> SKShapeNode {
        let path = UIBezierPath()
        // Определяем треугольник с базой 20 и высотой 20
        path.move(to: CGPoint(x: -10, y: 0))
        path.addLine(to: CGPoint(x: 10, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 20))
        path.close()
        
        let triangle = SKShapeNode(path: path.cgPath)
        triangle.fillColor = .red
        triangle.strokeColor = .red
        triangle.zPosition = 100
        return triangle
    }
    
    /// Обновляет видимость индикаторов хода в зависимости от currentTurn
    func updateTurnIndicator() {
        switch currentTurn {
        case .player:
            playerIndicator.isHidden = false
            opponentIndicator.isHidden = true
        case .opponent:
            playerIndicator.isHidden = true
            opponentIndicator.isHidden = false
        }
    }
    
    
    // MARK: - Настройка индикатора силы (force gauge)
    
    func setupForceGauge() {
        forceGauge.fillColor = .red
        forceGauge.strokeColor = .clear
        forceGauge.zPosition = 10
        forceGauge.isHidden = true
        // Размещаем индикатор, например, в верхней части экрана
        forceGauge.position = CGPoint(x: 100, y: size.height * 0.75)
        addChild(forceGauge)
    }
    
    /// Рисует дугу, показывающую процент накопления силы (от 0 до 100%)
    func updateForceGauge() {
        let fraction = (forceValue - forceMin) / (forceMax - forceMin)
        let clamped = max(0, min(1, fraction))
        
        let startAngle = -CGFloat.pi / 2
        let arcAngle = CGFloat.pi * clamped // до 180° в полном заряде
        let endAngle = startAngle + arcAngle
        
        let radius: CGFloat = 40
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
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
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        // Если идёт зарядка – увеличиваем силу броска
        if isCharging {
            forceValue += CGFloat(dt) * chargeRate
            if forceValue > forceMax {
                forceValue = forceMax
            }
            updateForceGauge()
        }
        
        // Применяем ветер к снарядам, если задан
        if let windVal = viewModel?.windValue {
            for node in children {
                if let sprite = node as? SKSpriteNode, sprite.name == "projectile" {
                    sprite.physicsBody?.applyForce(CGVector(dx: windVal, dy: 0))
                }
            }
        }
    }
    
    
    // MARK: - Запуск снаряда (фиксированный угол 45°)
    
    /// Запускает снаряд с накопленной силой и фиксированным углом.
    /// Для игры с другом, позиция броска определяется активным игроком.
    func launchProjectile(force: CGFloat, angle: CGFloat = 45) {
        // Определяем, чей сейчас ход и получаем активного быка
        let isPlayerTurn = (currentTurn == .player)
        let activeBull = isPlayerTurn ? playerBull : opponentBull
        
        // Если не удалось получить активного быка, выходим
        guard let startingBull = activeBull else { return }
        
        // Выбираем изображение бросаемого объекта из storeVM
        guard let throwItem = storeVM.currentThrowItem else { return }
        let projectile = SKSpriteNode(imageNamed: throwItem.image)
        projectile.size = CGSize(width: 50, height: 50)
        projectile.name = "projectile"
        projectile.zPosition = 4
        
        // Смещаем позицию старта, чтобы объект не создавался внутри быка
        var startPos = startingBull.position
        if isPlayerTurn {
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
        let dx = cos(radians) * force * (isPlayerTurn ? 1 : -1)
        let dy = sin(radians) * force
        projectile.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
        // После броска переключаем ход
        currentTurn = isPlayerTurn ? .opponent : .player
    }
    
    
    // MARK: - Простой ИИ для игры с другом не используется.
    // В режиме игры с другом броски выполняются по очереди через управление касаниями.
    
    
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
        
        var damage: CGFloat = 5
        if isHeadHit { damage *= 1.5 }
        
        if let hitBull = bullNode {
            // Если bullNode является самим быком или его дочерним узлом,
            // обновляем здоровье через viewModel.
            if hitBull == playerBull || hitBull.parent == playerBull {
                viewModel?.playerHealth -= damage
                if let health = viewModel?.playerHealth, health <= 0 {
                    gameOver(winner: "Opponent")
                }
            } else if hitBull == opponentBull || hitBull.parent == opponentBull {
                viewModel?.opponentHealth -= damage
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
    
    
    // MARK: - Управление касаниями (заряд силы)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Начинаем зарядку, если текущий ход соответствует активному игроку
        // (в игре с другом оба игрока используют один и тот же экран, поэтому обрабатываем касание, если ход активен)
        guard currentTurn == .player || currentTurn == .opponent else { return }
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
        launchProjectile(force: forceValue, angle: fixedAngle)
    }
}
