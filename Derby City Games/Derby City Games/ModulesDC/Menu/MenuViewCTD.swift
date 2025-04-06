//
//  MenuViewCTD.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 06.04.2025.
//


import SwiftUI

struct MenuViewCTD: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showStatistics = false
    @State private var showSettings = false
    
//    @StateObject var shopVM = ShopViewModelCTD()
//    @StateObject var settingsVM = SettingsViewModelCTD()
//    @StateObject var statVM = StatisticsViewModelCTD()
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 20) {
                    ZStack {
                        HStack(alignment: .top) {
                            Button {
                                showSettings = true
                            } label: {
                                Image(.rulesIconDC)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                            }
                            Spacer()
                            
                            
                            MoneyViewDC()
                        }
                        HStack {
                            Spacer()
                            Image(.logoDC)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 228:114)
                            
                            Spacer()
                        }
                        
                    }
                    HStack {
                        VStack {
                            Spacer()
                            Image(.menuBullDC)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 440:220)
                                .ignoresSafeArea()
                            
                        }
                        Spacer()
                    VStack {
                        HStack(spacing: 20) {
                            Spacer()
                            Button {
                                showSettings = true
                            } label: {
                                MenuTextBg(text: "Play")
                            }
                            
                            Button {
                                showStatistics = true
                            } label: {
                                MenuTextBg(text: "Store")
                            }
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            
                            Button {
                                showStatistics = true
                            } label: {
                                ZStack {
                                    Image(.buttonBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    VStack {
                                        TextWithBorder(text: "Achievements", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  36:18, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                            .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                        
                                        TextWithBorder(text: "0/17", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  36:18, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                            .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                    }
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 200:100)
                                
                            }
                            
                            Button {
                                showSettings = true
                            } label: {
                                MenuTextBg(text: "Settings")
                            }
                        }
                    }
                        VStack {
                            Spacer()
                            Image(.menuBullDC)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 440:220)
                                .ignoresSafeArea()
                                .opacity(0)
                        }
                }
                    
                }.padding()
            }.ignoresSafeArea()
            .background(
                Image(.bgDC)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                  
                
            )
//            .onAppear {
//                if settingsVM.musicEnabled {
//                    MusicManagerCTD.shared.playBackgroundMusic()
//                }
//            }
//            .onChange(of: settingsVM.musicEnabled) { enabled in
//                if enabled {
//                    MusicManagerCTD.shared.playBackgroundMusic()
//                } else {
//                    MusicManagerCTD.shared.stopBackgroundMusic()
//                }
//            }
            .fullScreenCover(isPresented: $showGame) {
//                PickChickenViewCTD(viewModel: shopVM, statVM: statVM)
            }
            .fullScreenCover(isPresented: $showShop) {
//                ShopViewCTD(viewModel: shopVM)
            }
            .fullScreenCover(isPresented: $showStatistics) {
//                StatisticsViewCTD(statVM: statVM)
            }
            .fullScreenCover(isPresented: $showSettings) {
//                SettingsViewCTD(settings: settingsVM)
            }
            
        }
        
        
    }
    
}


#Preview {
    MenuViewCTD()
}
