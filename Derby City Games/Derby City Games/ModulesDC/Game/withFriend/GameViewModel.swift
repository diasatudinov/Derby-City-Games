

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerHealth: CGFloat = 100
    @Published var opponentHealth: CGFloat = 100
    @Published var windValue: CGFloat = 0
    @Published var playerDamage: CGFloat = 5
    @Published var opponentDamage: CGFloat = 5
    @Published var gameOver: Bool = false
    @Published var playerWin: Bool = false
    let randomNum = Int.random(in: 1...3)
    // Можно хранить ссылку на сцену:
    weak var gameScene: GameScene?
    
    // Метод для связи со сценой
    func attachScene(_ scene: GameScene) {
        self.gameScene = scene
        scene.viewModel = self
    }
    
    // Перезапуск игры
    func restartGame() {
        // Сбрасываем здоровье
        playerHealth = 100
        opponentHealth = 100
        windValue = CGFloat.random(in: -8...8)
        playerWin = false
        gameOver = false
        // Перезапускаем сцену (можно написать свой метод resetScene в GameScene)
        guard let gameScene = gameScene else { return }
        gameScene.resetScene()
    }
    
    // Пример суперспособности: увеличиваем урон, добавляем эффект и т.д.
    func activateSuperPower1() {
        // Например, увеличиваем силу броска у игрока
        print("activateSuperPower1")
        gameScene?.superPowerMode = .doubleDamage
        playerDamage += playerDamage
    }
    
    func activateSuperPower2() {
        print("activateSuperPower2")
        gameScene?.superPowerMode = .shield
        opponentDamage = 0
    }
    
    func activateSuperPower3() {
        print("activateSuperPower3")
        gameScene?.superPowerMode = .superThrow
    }
    
    func activateSuperPower4() {
        print("activateSuperPower4")
        // Другой эффект, например, «раздвоение» снарядов
        gameScene?.superPowerMode = .healing
        playerHealth = 100
    }
    
    func resetPower() {
        playerDamage = 5
        opponentDamage = 5
    }
    
    func opponentBullImage() -> String {
        return "opponentBull\(randomNum)"
        
    }
    
    // и т.д...
}
