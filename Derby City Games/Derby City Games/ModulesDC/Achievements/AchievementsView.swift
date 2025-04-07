import SwiftUI

struct AchievementsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AchievementsViewModel
    var body: some View {
        ZStack {
            ZStack {
                Image(.achievementsTableBg)
                    .resizable()
                    .scaledToFit()
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        ForEach(viewModel.achievements, id: \.self) { ach in
                            achievementCell(achievement: ach)
                        }
                    }
                }.padding(.top, DeviceInfo.shared.deviceType == .pad ? 120:60).padding(.bottom, DeviceInfo.shared.deviceType == .pad ? 60:30)
                
            }.frame(height: DeviceInfo.shared.deviceType == .pad ? 686:343)
            
            VStack {
                HStack {
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
                }
                Spacer()
            }
        }
        .background(
            Image(.bgDC)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
        )
    }
    
    @ViewBuilder func achievementCell(achievement: Achievement) -> some View {
        
        HStack(spacing: DeviceInfo.shared.deviceType == .pad ? 20:10) {
            Image(achievement.recieved ? "\(achievement.image)":"\(achievement.image)Off")
                .resizable()
                .scaledToFit()
                .frame(width: DeviceInfo.shared.deviceType == .pad ? 100:50, height: DeviceInfo.shared.deviceType == .pad ? 100:50)
            
            VStack(alignment: .leading) {
                TextWithBorder(text: achievement.title, font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10, weight: .bold), textColor: .red, borderColor: .black, borderWidth: 2)
                    .multilineTextAlignment(.leading)
             
                HStack {
                    TextWithBorder(text: achievement.subtitle, font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                    Spacer()
                }
                .frame(width:DeviceInfo.shared.deviceType == .pad ? 220: 110)
                    .multilineTextAlignment(.leading)
            }
            
            Button {
                if !achievement.recieved {
                    if !viewModel.getAchievement(for: achievement.image) {
                        //viewModel.achievementIsDone(for: achievement.image)
                    } else {
                        viewModel.achievementRecieve(for: achievement)
                    }
                }
            } label: {
                if achievement.recieved {
                    ZStack {
                        Image(.recievedBg)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 80:40)
                        TextWithBorder(text: "Received", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                    }
                } else {
                    ZStack {
                        Image(viewModel.getAchievement(for: achievement.image) ? .pickUpBg : .notAchievedBg)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 80:40)
                        TextWithBorder(text: "Pick up", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                    }
                }
            }
            
        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 100:50)
        
    }
}

#Preview {
    AchievementsView(viewModel: AchievementsViewModel())
}
