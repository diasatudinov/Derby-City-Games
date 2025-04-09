import SwiftUI

struct SelectGameModeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var storeVM: StoreViewModelDC
    @ObservedObject var achievementVM: AchievementsViewModel

    @State private var openOnline = false
    @State private var openAI = false
    @State private var openFriend = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Button {
                        presentationMode.wrappedValue.dismiss()

                    } label: {
                        Image(.backIconDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
                    }
                    Spacer()
                    
                    
                    MoneyViewDC()
                }.padding([.horizontal, .top])
                
                
                
                HStack {
                    VStack {
                        Spacer()
                        Image(.menuBullDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 300:200)
                            
                        
                    }
                    VStack (spacing: 0){
                        HStack(spacing: 20) {
                            Spacer()
                            Button {
                                openFriend = true
                            } label: {
                                ZStack {
                                    Image(.withFriendBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    TextWithBorder(text: "With friend", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? 46:23)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 280:140)
                            }
                            
                            Button {
                                openAI = true
                            } label: {
                                ZStack {
                                    Image(.withAIBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    TextWithBorder(text: "With AI", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? 46:23)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 280:140)
                            }
                            Spacer()
                        }
                        
                        
                            
                            Button {
                                openOnline = true
                            } label: {
                                ZStack {
                                    Image(.onlineBgDC)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    TextWithBorder(text: "Online", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? 46:23)
                                }.frame(height: DeviceInfo.shared.deviceType == .pad ? 310:155)
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
                }.ignoresSafeArea()
                
            }
        }
            .background(
                Image(.bgDC)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                
                
            )
            .fullScreenCover(isPresented: $openAI) {
                AIGameView(storeVM: storeVM)
            }
            .fullScreenCover(isPresented: $openFriend) {
                GameView(storeVM: storeVM, achievementVM: achievementVM)
            }
            .fullScreenCover(isPresented: $openOnline) {
                AIGameView(storeVM: storeVM)
            }
    }
}

#Preview {
    SelectGameModeView(storeVM: StoreViewModelDC(), achievementVM: AchievementsViewModel())
}
