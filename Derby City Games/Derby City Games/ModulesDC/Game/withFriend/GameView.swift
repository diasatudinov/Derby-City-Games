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
    
    @State private var powerUse = false
    
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
                        powerUse = false
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
                            switch skill.name {
                            case "Double Damage":
                                SuperPowerButton(iconName: skill.image, action: viewModel.activateSuperPower1, isUsed: $powerUse)
                            case "Shield":
                                SuperPowerButton(iconName: skill.image, action: viewModel.activateSuperPower2, isUsed: $powerUse)
                            case "Reinforced Throw":
                                SuperPowerButton(iconName: skill.image, action: viewModel.activateSuperPower3, isUsed: $powerUse)
                            case "Healing":
                                SuperPowerButton(iconName: skill.image, action: viewModel.activateSuperPower4, isUsed: $powerUse)
                            default:
                                Text("")
                            }
                            
                        }
                    }

                    WindBar(windValue: $viewModel.windValue, minVal: -10, maxVal: 10)
                        .frame(height: 10)
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                    
                    HStack(spacing: 20) {
                        SuperPowerButton(iconName: "", action: viewModel.activateSuperPower4, isUsed: $powerUse).opacity(0)
                    }
                
                }
                
                
                Spacer()
                
            }
            if viewModel.gameOver {
                if viewModel.playerWin {
                    ZStack {
                        Image(.winBgDC)
                            .resizable()
                            .scaledToFit()
                        VStack {
                            ZStack {
                                Image(.coinsBgDC)
                                    .resizable()
                                    .scaledToFit()
                                    
                                HStack(spacing: 15) {
                                    Image(.coinsIconDC)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 70:35)
                                    
                                    Text("100")
                                        .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                        
                                    
                                }
                            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 126:63)
                            
                            Button {
                                viewModel.restartGame()
                            } label: {
                                ZStack {
                                    Image(.buttonBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    TextWithBorder(text: "Retry", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 160:80)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ZStack {
                                    Image(.buttonBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    TextWithBorder(text: "Menu", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 160:80)
                            }
                        }.padding(.top)
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 686:343)
                } else {
                    ZStack {
                        Image(.loseBgDC)
                            .resizable()
                            .scaledToFit()
                        VStack {
                            Button {
                               viewModel.restartGame()
                            } label: {
                                ZStack {
                                    Image(.buttonBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    TextWithBorder(text: "Retry", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 160:80)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                ZStack {
                                    Image(.buttonBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    TextWithBorder(text: "Menu", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 160:80)
                            }
                        }.padding(.top)
                    }.frame(height: DeviceInfo.shared.deviceType == .pad ? 546:273)
                }
            }
            
        } .background(
            Image(storeVM.currentBgItem?.image ?? "")
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
    @Binding var isUsed: Bool
    var body: some View {
        Button {
            if !isUsed {
                action()
                isUsed = true
            }
        } label: {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
              
        }
    }
}
