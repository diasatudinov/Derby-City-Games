import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var viewModel: SettingsViewModelDC
    private let languages = ["English", "German", "Spanish"]
    @State private var langIndex = 0
    var body: some View {
        ZStack {
            
            VStack(spacing: 15) {
                TextWithBorder(text: "Sound", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                
                HStack {
                    TextWithBorder(text: "Off", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                    
                    Button {
                        withAnimation {
                            viewModel.musicEnabled.toggle()
                        }
                    } label: {
                        
                        Image(viewModel.musicEnabled ? .onDC : .offDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 72:36)
                    }
                    
                    TextWithBorder(text: "On", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                }
                
                TextWithBorder(text: "Language", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                
                langView()
            }
            
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
            Image(.settingsBgDC)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
        )
    }
    
    @ViewBuilder func langView() -> some View {
        
        VStack {
            HStack {
                Button {
                    if langIndex > 0 {
                        langIndex -= 1
                    }
                } label: {
                    Image(.arrowDC)
                        .resizable()
                        .scaledToFit()
                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 62:31)
                }
                
                Image("\(languages[langIndex])FlagDC")
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 84:42)
                Button {
                    if langIndex < 2 {
                        langIndex += 1
                    }
                } label: {
                    Image(.arrowDC)
                        .resizable()
                        .scaledToFit()
                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 62:31)
                        .scaleEffect(x: -1, y: 1)
                }
            }
            
            TextWithBorder(text: languages[langIndex], font: .system(size: DeviceInfo.shared.deviceType == .pad ? 32:16, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
        }
        
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModelDC())
}
