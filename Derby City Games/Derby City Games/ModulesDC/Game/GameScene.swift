import SpriteKit
import GameplayKit

// Физические категории для столкновений
struct PhysicsCategory {
    static let bullBody: UInt32 = 0x1 << 0
    static let bullHead: UInt32 = 0x1 << 1
    static let projectile: UInt32 = 0x1 << 2
    static let wall: UInt32 = 0x1 << 3
}

// Перечисление для очередности ходов
enum Turn {
    case player
    case opponent
}

enum SuperPowerMode {
    case none
    case doubleDamage
    case multiProjectile
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewModel: GameViewModel?
    
    var superPowerMode: SuperPowerMode = .none
    
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .resizeFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Узлы для быков-игроков
    var playerBull: SKSpriteNode!
    var opponentBull: SKSpriteNode!
    
    // Здоровье игроков
    var playerHealth: CGFloat = 100
    var opponentHealth: CGFloat = 100
    var playerHealthLabel: SKLabelNode!
    var opponentHealthLabel: SKLabelNode!
    
    // Параметры броска
    var angle: CGFloat = 45.0    // в градусах
    var force: CGFloat = 5.0    // произвольные единицы
    var angleLabel: SKLabelNode!
    var forceLabel: SKLabelNode!
    
    // Кнопка для броска
    var throwButton: SKLabelNode!
    
    // Очередность хода
    var currentTurn: Turn = .player
    
    // Ветер
    var wind: CGVector = CGVector(dx: 0, dy: 0)
    var windLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .cyan
        
        // Настройка физики
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        setupArena()
        setupBulls()
        setupUI()
        
        viewModel?.windValue = CGFloat.random(in: -10...10)
    }
    
    // Настройка арены: добавляем стену между игроками
    func setupArena() {
        // Стена располагается в центре между игроками.
        let wallWidth: CGFloat = 20
        let wallHeight: CGFloat = size.height * 0.4
        let wall = SKSpriteNode(color: .gray, size: CGSize(width: wallWidth, height: wallHeight))
        wall.position = CGPoint(x: size.width / 2, y: size.height * 0.2 + wallHeight / 2)
        wall.name = "wall"
        wall.zPosition = 2
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wall.physicsBody?.collisionBitMask = PhysicsCategory.projectile
        addChild(wall)
    }
    
    // Создаём быков, их физические тела и «головы» для критического урона
    func setupBulls() {
        // Игрок
        playerBull = SKSpriteNode(imageNamed: "bull")
        playerBull.position = CGPoint(x: size.width * 0.2, y: size.height * 0.2)
        playerBull.zPosition = 3
        addChild(playerBull)
        
        let playerBody = SKPhysicsBody(rectangleOf: CGSize(width: playerBull.size.width * 0.8,
                                                            height: playerBull.size.height * 0.6))
        playerBody.isDynamic = false
        playerBody.categoryBitMask = PhysicsCategory.bullBody
        playerBull.physicsBody = playerBody
        
        let playerHead = SKShapeNode(circleOfRadius: playerBull.size.width * 0.2)
        playerHead.fillColor = .red
        playerHead.strokeColor = .clear
        playerHead.position = CGPoint(x: 0, y: playerBull.size.height * 0.3)
        playerHead.physicsBody = SKPhysicsBody(circleOfRadius: playerBull.size.width * 0.2)
        playerHead.physicsBody?.isDynamic = false
        playerHead.physicsBody?.categoryBitMask = PhysicsCategory.bullHead
        playerHead.name = "playerHead"
        playerBull.addChild(playerHead)
        
        // Противник
        opponentBull = SKSpriteNode(imageNamed: "bull")
        opponentBull.xScale = -1   // Отзеркаливаем для разнообразия
        opponentBull.position = CGPoint(x: size.width * 0.8, y: size.height * 0.2)
        opponentBull.zPosition = 3
        addChild(opponentBull)
        
        let opponentBody = SKPhysicsBody(rectangleOf: CGSize(width: opponentBull.size.width * 0.8,
                                                              height: opponentBull.size.height * 0.6))
        opponentBody.isDynamic = false
        opponentBody.categoryBitMask = PhysicsCategory.bullBody
        opponentBull.physicsBody = opponentBody
        
        let opponentHead = SKShapeNode(circleOfRadius: opponentBull.size.width * 0.2)
        opponentHead.fillColor = .red
        opponentHead.strokeColor = .clear
        opponentHead.position = CGPoint(x: 0, y: opponentBull.size.height * 0.3)
        opponentHead.physicsBody = SKPhysicsBody(circleOfRadius: opponentBull.size.width * 0.2)
        opponentHead.physicsBody?.isDynamic = false
        opponentHead.physicsBody?.categoryBitMask = PhysicsCategory.bullHead
        opponentHead.name = "opponentHead"
        opponentBull.addChild(opponentHead)
        
        // Метки здоровья
        playerHealthLabel = SKLabelNode(text: "Player Health: \(Int(playerHealth))")
        playerHealthLabel.fontSize = 16
        playerHealthLabel.fontColor = .black
        playerHealthLabel.position = CGPoint(x: playerBull.position.x, y: playerBull.position.y + playerBull.size.height)
        addChild(playerHealthLabel)
        
        opponentHealthLabel = SKLabelNode(text: "Opponent Health: \(Int(opponentHealth))")
        opponentHealthLabel.fontSize = 16
        opponentHealthLabel.fontColor = .black
        opponentHealthLabel.position = CGPoint(x: opponentBull.position.x, y: opponentBull.position.y + opponentBull.size.height)
        addChild(opponentHealthLabel)
    }
    
    // Настройка UI: метки для регулировки угла и силы, кнопка броска, отображение ветра
    func setupUI() {
        angleLabel = SKLabelNode(text: "Angle: \(Int(angle))°")
        angleLabel.fontSize = 18
        angleLabel.fontColor = .black
        angleLabel.position = CGPoint(x: size.width * 0.2, y: size.height * 0.9)
        addChild(angleLabel)
        
        forceLabel = SKLabelNode(text: "Force: \(Int(force))")
        forceLabel.fontSize = 18
        forceLabel.fontColor = .black
        forceLabel.position = CGPoint(x: size.width * 0.4, y: size.height * 0.9)
        addChild(forceLabel)
        
        throwButton = SKLabelNode(text: "Бросить")
        throwButton.fontSize = 24
        throwButton.fontColor = .blue
        throwButton.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
        throwButton.name = "throwButton"
        addChild(throwButton)
        
        windLabel = SKLabelNode(text: "Ветер: 0")
        windLabel.fontSize = 18
        windLabel.fontColor = .black
        windLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.95)
        addChild(windLabel)
    }
    
    func resetScene() {
        // Удаляем все узлы, пересоздаём арену, быков, т.п.
        removeAllChildren()
        removeAllActions()
        
        setupArena()
        setupBulls()
        
        superPowerMode = .none
        
        // Снова настроим ветер
        viewModel?.windValue = CGFloat.random(in: -10...10)
    }
    
    
    // Обработка касаний: если нажата кнопка «Бросить», запускаем бросок. Иначе – меняем угол или силу.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        if nodesAtPoint.contains(where: { $0.name == "throwButton" }) {
            if currentTurn == .player {
                launchProjectile(from: playerBull.position, isPlayer: true)
            }
        } else {
            // Левая половина экрана меняет угол, правая – силу
            if location.x < size.width / 2 {
                angle = max(10, min(80, (location.y / size.height) * 90))
                angleLabel.text = "Angle: \(Int(angle))°"
            } else {
                force = max(5, min(20, (location.y / size.height) * 20))
                forceLabel.text = "Force: \(Int(force))"
            }
        }
    }
    
    // Функция запуска снаряда
    func launchProjectile(from position: CGPoint, isPlayer: Bool) {
        // Создаём снаряд, делаем его более заметным и устанавливаем zPosition выше, чтобы он был поверх других элементов.
        let projectile = SKShapeNode(circleOfRadius: 10)
        projectile.fillColor = .yellow
        projectile.strokeColor = .black
        projectile.zPosition = 4
        
        // Смещаем начальную позицию, чтобы снаряд не начинался внутри быка, который его бросает.
        var startPosition = position
        if isPlayer {
            // Для игрока смещаем вправо и вверх
            startPosition.x += 50
            startPosition.y += 50
        } else {
            // Для противника смещаем влево и вверх
            startPosition.x -= 50
            startPosition.y += 50
        }
        projectile.position = startPosition
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        projectile.physicsBody?.affectedByGravity = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.bullBody | PhysicsCategory.bullHead | PhysicsCategory.wall
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.bullBody | PhysicsCategory.bullHead | PhysicsCategory.wall
        addChild(projectile)
        
        // Переводим угол в радианы и рассчитываем импульс.
        let radians = angle * (.pi / 180)
        let dx = cos(radians) * force * (isPlayer ? 1 : -1)
        let dy = sin(radians) * force
        let impulse = CGVector(dx: dx, dy: dy)
        projectile.physicsBody?.applyImpulse(impulse)
        
        // Переключаем ход: если был ход игрока, запускаем ИИ с задержкой.
        if currentTurn == .player {
            currentTurn = .opponent
            run(SKAction.wait(forDuration: 2.0)) { [weak self] in
                self?.aiTurn()
            }
        } else {
            currentTurn = .player
        }
    }
    
    // Простой ИИ: случайно выбирает угол и силу, затем бросает снаряд от позиции противника.
    func aiTurn() {
        angle = CGFloat.random(in: 20...70)
        force = CGFloat.random(in: 3...9)
        angleLabel.text = "Angle: \(Int(angle))°"
        forceLabel.text = "Force: \(Int(force))"
        launchProjectile(from: opponentBull.position, isPlayer: false)
    }
    
    // В методе update каждую итерацию к снаряду применяется сила ветра.
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Если нужно влиять на снаряды силой ветра из viewModel
        if let windVal = viewModel?.windValue {
            for node in children {
                if let shape = node as? SKShapeNode,
                   shape.physicsBody?.categoryBitMask == PhysicsCategory.projectile {
                    shape.physicsBody?.applyForce(CGVector(dx: windVal, dy: 0))
                }
            }
        }
        
    }
    
    // Обработка столкновений: определяем попадания по быкам и удаляем снаряд при столкновении со стеной.
    func didBegin(_ contact: SKPhysicsContact) {
        // Если снаряд столкнулся со стеной – удаляем его.
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
        
        // Базовый урон
        var damage: CGFloat = 20
        if isHeadHit {
            damage *= 1.5  // критический урон
        }
        
        // Определяем, какой из быков получил урон
        if let bull = bullNode {
            if bull.parent == playerBull {
                playerHealth -= damage
                playerHealthLabel.text = "Player Health: \(Int(playerHealth))"
                if playerHealth <= 0 {
                    gameOver(winner: "Opponent")
                }
            } else if bull.parent == opponentBull {
                opponentHealth -= damage
                opponentHealthLabel.text = "Opponent Health: \(Int(opponentHealth))"
                if opponentHealth <= 0 {
                    gameOver(winner: "Player")
                }
            }
        }
        
        // Удаляем снаряд после столкновения
        projectileNode?.removeFromParent()
    }
    
    // Завершение игры
    func gameOver(winner: String) {
        let gameOverLabel = SKLabelNode(text: "\(winner) победил!")
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameOverLabel)
        
        isPaused = true
    }
}
