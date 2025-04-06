import SwiftUI

struct MenuViewCTD: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showStatistics = false
    @State private var showSettings = false
    
    @StateObject var shopVM = ShopViewModelCTD()
    @StateObject var settingsVM = SettingsViewModelCTD()
    @StateObject var statVM = StatisticsViewModelCTD()
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    Button {
                        showGame = true
                    } label: {
                        Image(.playIconCTD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 380:190)
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            showSettings = true
                        } label: {
                            Image(.settingsIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 160:80)
                        }
                        
                        Button {
                            showStatistics = true
                        } label: {
                            Image(.statisticsIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 160:80)
                        }
                        
                        Button {
                            showShop = true
                        } label: {
                            Image(.shopIconCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 160:80)
                        }
                        Spacer()
                    }
                    Spacer()
                }.padding()
            }
            .background(
                ZStack {
                    Image(.menuBgCTD)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                    VStack {
                        Spacer()
                        HStack(alignment: .bottom) {
                            Image(.chickenMenuCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                            Spacer()
                            Image(.cookerCTD)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 350)
                                
                        }
                    }.edgesIgnoringSafeArea(.bottom)
                }
                
            )
            .onAppear {
                if settingsVM.musicEnabled {
                    MusicManagerCTD.shared.playBackgroundMusic()
                }
            }
            .onChange(of: settingsVM.musicEnabled) { enabled in
                if enabled {
                    MusicManagerCTD.shared.playBackgroundMusic()
                } else {
                    MusicManagerCTD.shared.stopBackgroundMusic()
                }
            }
            .fullScreenCover(isPresented: $showGame) {
                PickChickenViewCTD(viewModel: shopVM, statVM: statVM)
            }
            .fullScreenCover(isPresented: $showShop) {
                ShopViewCTD(viewModel: shopVM)
            }
            .fullScreenCover(isPresented: $showStatistics) {
                StatisticsViewCTD(statVM: statVM)
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsViewCTD(settings: settingsVM)
            }
            
        }
        
        
    }
    
}


#Preview {
    MenuViewCTD()
}