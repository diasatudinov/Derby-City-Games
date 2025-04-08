import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var storeVM: StoreViewModelDC
    @StateObject var viewModel = GameViewModel()
    
    @State private var gameScene: FriendGameScene = {
        let scene = FriendGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    
    var body: some View {
        ZStack {
            SpriteViewContainer(viewModel: viewModel, scene: gameScene)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                    }
                    VStack {
                        if let currentSkin = storeVM.currentSkinItem {
                            HealthBar(value: $viewModel.playerHealth, maxValue: 100, color: .red, isPlayer: true, image: currentSkin.image)
                        }
                    }
                    Spacer()
                    
                    HealthBar(value: $viewModel.opponentHealth, maxValue: 100, color: .green, isPlayer: false, image: viewModel.opponentBullImage())
                    
                    Button {
                        
                        viewModel.restartGame()
                    } label: {
                        Image(.restartBtnDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    HStack(spacing: 20) {
                        if let skill = storeVM.currentSkillItem {
                            SuperPowerButton(iconName: skill.image, action: viewModel.activateSuperPower1)
                        }
                    }

                    WindBar(windValue: $viewModel.windValue, minVal: -10, maxVal: 10)
                        .frame(height: 10)
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                    
                    HStack(spacing: 20) {
                        SuperPowerButton(iconName: "bolt.fill", action: viewModel.activateSuperPower1)
                        SuperPowerButton(iconName: "flame.fill", action: viewModel.activateSuperPower2)
                    }
                
                }
                
                
                Spacer()
                
            }
        } .background(
            Image(.bgDC)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
        )
    }
}

#Preview {
    GameView(storeVM: StoreViewModelDC())
}


struct HealthBar: View {
    @Binding var value: CGFloat
    let maxValue: CGFloat
    let color: Color
    var isPlayer: Bool
    let image: String
    
    var body: some View {
        ZStack {
            
            
            // Заполненная часть
            if isPlayer {
                ZStack(alignment: .leading) {
                    Image(.hpBgDC)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: healthWidth, height: 12)
                        .foregroundColor(color)
                        .offset(x: 15, y: -4)
                }
            } else {
                ZStack(alignment: .trailing) {
                    Image(.hpBgDC)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: otherSideHealthWidth, height: 12)
                        .foregroundColor(color)
                        .offset(x: -15, y: -4)
                }
            }
            HStack {
                if isPlayer {
                    Spacer()
                }
                
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 67)
                
                if !isPlayer {
                    Spacer()
                }
            }
        }.frame(width: 305)
    }
    
    private var healthWidth: CGFloat {
        // Максимальная ширина 150
        let ratio = value / maxValue
        return max(0, min(258, 258 * ratio))
    }
    
    private var otherSideHealthWidth: CGFloat {
            let ratio = value / maxValue
            return max(0, min(258, 258 * ratio))
        }
}

struct WindBar: View {
    @Binding var windValue: CGFloat
    let minVal: CGFloat
    let maxVal: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.windTextDC)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            ZStack {
                // Фон
                Image(.windBgDC)
                    .resizable()
                    .scaledToFit()
                   
                // Индикатор ветра
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 23, height: 24)
                // Позиционируем внутри полосы
                    .offset(x: offsetX(in: 126), y: 0)
            }.frame(width: 126, height: 30)
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
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
                
        }
    }
}
