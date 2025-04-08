//
//  GameViewModel.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 08.04.2025.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerHealth: CGFloat = 100
    @Published var opponentHealth: CGFloat = 100
    @Published var windValue: CGFloat = 0
    
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
        
        // Обнуляем или меняем ветер
        windValue = 0
        
        // Перезапускаем сцену (можно написать свой метод resetScene в GameScene)
        gameScene?.resetScene()
    }
    
    // Пример суперспособности: увеличиваем урон, добавляем эффект и т.д.
    func activateSuperPower1() {
        // Например, увеличиваем силу броска у игрока
        gameScene?.superPowerMode = .doubleDamage
    }
    
    func activateSuperPower2() {
        // Другой эффект, например, «раздвоение» снарядов
        gameScene?.superPowerMode = .multiProjectile
    }
    
    // и т.д...
}
