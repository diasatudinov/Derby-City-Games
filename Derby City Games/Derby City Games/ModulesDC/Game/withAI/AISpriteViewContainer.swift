import SwiftUI
import SpriteKit


struct AISpriteViewContainer: UIViewRepresentable {
    @StateObject var user = DCUser.shared
    @State var viewModel: GameViewModel
    var scene: GameScene
    func makeUIView(context: Context) -> SKView {
        // Устанавливаем фрейм равным размеру экрана
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        // Настраиваем сцену
        scene.scaleMode = .resizeFill
        
            scene.viewModel = viewModel
        
        skView.presentScene(scene)
        
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Обновляем размер SKView при изменении размеров SwiftUI представления
        uiView.frame = UIScreen.main.bounds
    }
}
