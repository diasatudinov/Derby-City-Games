import SwiftUI

struct MenuViewCTD: View {
    @State private var showGame = false
    @State private var showRules = false
    @State private var showShop = false
    @State private var showAchievements = false
    @State private var showSettings = false
    
    
    //    @StateObject var shopVM = ShopViewModelCTD()
    @StateObject var settingsVM = SettingsViewModelDC()
    @StateObject var achievementsVM = AchievementsViewModel()
    @StateObject var storeVM = StoreViewModelDC()
    var body: some View {
        
        ZStack {
            VStack(spacing: 20) {
                ZStack(alignment: .top) {
                    HStack(alignment: .top) {
                        Button {
                            showRules = true
                        } label: {
                            Image(.rulesIconDC)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                        }
                        Spacer()
                        
                        
                        MoneyViewDC()
                    }
                    
                    HStack(alignment: .top) {
                        Spacer()
                        Image(.logoDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 228:114)
                        
                        Spacer()
                    }
                    
                }.padding([.horizontal, .top], 20)
                HStack {
                    VStack {
                        Spacer()
                        Image(.menuBullDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 300:200)
                            .ignoresSafeArea()
                        
                    }
                    Spacer()
                    VStack {
                        HStack(spacing: 20) {
                            Spacer()
                            Button {
                                showGame = true
                            } label: {
                                MenuTextBg(text: "Play")
                            }
                            
                            Button {
                                showShop = true
                            } label: {
                                MenuTextBg(text: "Store")
                            }
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            
                            Button {
                                showAchievements = true
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
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 300:200)
                            .ignoresSafeArea()
                            .opacity(0)
                    }
                }
                
            }
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
                SelectGameModeView(storeVM: storeVM)
            }
            .fullScreenCover(isPresented: $showRules) {
                RulesView()
            }
            .fullScreenCover(isPresented: $showAchievements) {
                AchievementsView(viewModel: achievementsVM)
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsView(viewModel: settingsVM)
            }
            .fullScreenCover(isPresented: $showShop) {
                StoreView(viewModel: storeVM)
            }
        
    }
    
}


#Preview {
    MenuViewCTD()
}
