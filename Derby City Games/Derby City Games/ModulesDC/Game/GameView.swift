import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject var viewModel = GameViewModel()
    
    // Создаём (или переиспользуем) сцену
    var scene: GameScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        // Связываем сцену с вью-моделью
        viewModel.attachScene(scene)
        return scene
    }
    
    var body: some View {
        ZStack {
            // 1) SpriteKit сцена на заднем плане
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            // 2) SwiftUI-элементы поверх
            VStack {
                // Верхняя панель с жизнями
                HStack {
                    // Шкала жизни игрока
                    HealthBar(value: $viewModel.playerHealth, maxValue: 100, color: .red)
                    
                    Spacer()
                    
                    // Шкала жизни соперника
                    HealthBar(value: $viewModel.opponentHealth, maxValue: 100, color: .green)
                }
                .padding(.horizontal)
                
                // Индикатор ветра
                Text("Wind: \(viewModel.windValue, specifier: "%.1f")")
                    .padding(.vertical, 5)
                
                // Полоска ветра (условно, от -10 до 10)
                WindBar(windValue: $viewModel.windValue, minVal: -10, maxVal: 10)
                    .frame(height: 10)
                    .padding(.horizontal, 40)
                
                // Раздел для суперспособностей (иконки)
                HStack(spacing: 20) {
                    SuperPowerButton(iconName: "bolt.fill", action: viewModel.activateSuperPower1)
                    SuperPowerButton(iconName: "flame.fill", action: viewModel.activateSuperPower2)
                }
                .padding(.vertical, 5)
                
                Spacer()
                
                // Кнопка рестарта внизу
                Button {
                    viewModel.restartGame()
                } label: {
                    Text("Restart")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    GameView()
}


struct HealthBar: View {
    @Binding var value: CGFloat
    let maxValue: CGFloat
    let color: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Серый фон
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 150, height: 20)
                .foregroundColor(.gray.opacity(0.3))
            
            // Заполненная часть
            RoundedRectangle(cornerRadius: 8)
                .frame(width: healthWidth, height: 20)
                .foregroundColor(color)
        }
    }
    
    private var healthWidth: CGFloat {
        // Максимальная ширина 150
        let ratio = value / maxValue
        return max(0, min(150, 150 * ratio))
    }
}

struct WindBar: View {
    @Binding var windValue: CGFloat
    let minVal: CGFloat
    let maxVal: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Фон
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.gray.opacity(0.3))
                
                // Индикатор ветра
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                    // Позиционируем внутри полосы
                    .offset(x: offsetX(in: geo.size.width), y: 0)
            }
        }
    }
    
    func offsetX(in totalWidth: CGFloat) -> CGFloat {
        // windValue от minVal до maxVal
        // 0 => центр
        let range = maxVal - minVal
        let ratio = (windValue - minVal) / range
        // Чтобы круг был по центру при windValue = 0, нужен сдвиг от -totalWidth/2 до +totalWidth/2
        return (ratio - 0.5) * totalWidth
    }
}

struct SuperPowerButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.yellow)
                .padding()
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
        }
    }
}
