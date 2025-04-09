import SwiftUI
import SpriteKit

struct AIGameView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var storeVM: StoreViewModelDC
    @StateObject var viewModel = GameViewModel()
    
    @State private var gameScene: GameScene = {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        return scene
    }()
    @State private var powerUse = false
    
    var body: some View {
        ZStack {
            AISpriteViewContainer(viewModel: viewModel, scene: gameScene)
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
        }.background(
                
            Image(storeVM.currentBgItem?.image ?? "")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
        )
    }
}

#Preview {
    AIGameView(storeVM: StoreViewModelDC())
}
