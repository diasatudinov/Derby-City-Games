//
//  GameView.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 08.04.2025.
//


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
