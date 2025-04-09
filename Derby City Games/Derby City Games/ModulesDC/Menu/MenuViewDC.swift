import SwiftUI

struct MenuViewDC: View {
    @State private var showGame = false
    @State private var showRules = false
    @State private var showShop = false
    @State private var showAchievements = false
    @State private var showSettings = false
    
    @StateObject var settingsVM = SettingsViewModelDC()
    @StateObject var achievementsVM = AchievementsViewModel()
    @StateObject var storeVM = StoreViewModelDC()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 20) {
                    if geometry.size.width < geometry.size.height {
                        Spacer()
                    }
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
                    Spacer()
                    HStack {
                        if geometry.size.width > geometry.size.height {
                            VStack {
                                Spacer()
                                Image(.menuBullDC)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 300:200)
                                    .ignoresSafeArea()
                                
                            }
                            Spacer()
                        }
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
                                            
                                            TextWithBorder(text: "\(achievementsVM.achievements.filter({ $0.recieved}).count)/17", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  36:18, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
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
                        if geometry.size.width > geometry.size.height {
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
                    Spacer()
                }
            }.ignoresSafeArea()
                .background(
                    Image(.bgDC)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                    
                    
                )
                .onAppear {
                    if settingsVM.musicEnabled {
                        DCSoundManager.shared.playBackgroundMusic()
                    }
                }
                .onChange(of: settingsVM.musicEnabled) { enabled in
                    if enabled {
                        DCSoundManager.shared.playBackgroundMusic()
                    } else {
                        DCSoundManager.shared.stopBackgroundMusic()
                    }
                }
                .fullScreenCover(isPresented: $showGame) {
                    SelectGameModeView(storeVM: storeVM, achievementVM: achievementsVM)
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
    
}


#Preview {
    MenuViewDC()
}
