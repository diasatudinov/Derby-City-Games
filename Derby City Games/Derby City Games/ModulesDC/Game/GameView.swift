//
//  GameView.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 07.04.2025.
//


import SwiftUI
import SpriteKit

struct GameView: View {
    // Создаём сцену с нужными размерами
    var scene: SKScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        // Используем SpriteView для отображения SpriteKit сцены
        SpriteView(scene: scene)
            .ignoresSafeArea() // Игнорируем безопасные зоны для полного покрытия экрана
    }
}

#Preview {
    GameView()
}
