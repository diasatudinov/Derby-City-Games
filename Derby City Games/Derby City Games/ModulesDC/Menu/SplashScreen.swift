
import SwiftUI

struct SplashScreen: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    Spacer()
                    Image(.logoDC)
                        .resizable()
                        .scaledToFit()
                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 346:173)
                    
                    ZStack {
                        VStack(spacing: 5) {
                            
                            
                            
                            HStack {
                                Spacer()
                                CustomProgressView(progress: progress)
                                Spacer()
                            }
                            TextWithBorder(text: "Loading", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  64:32, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                            
                            TextWithBorder(text: "Accuracy is everything! Aim like a champion bullfighter!", font: .system(size: DeviceInfo.shared.deviceType == .pad ?  32:16, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 2)
                            
                        }
                    }
                    .foregroundColor(.black)
                    .padding(.bottom, DeviceInfo.shared.deviceType == .pad ? 50:25)
                }
            }.background(
                Image(.bgDC)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                  
                
            )
            .onAppear {
                startTimer()
            }
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                withAnimation {
                    progress += 0.01
                }
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    SplashScreen()
}

struct CustomProgressView: View {
    /// Значение прогресса от 0.0 до 1.0
    var progress: CGFloat
    let loaderWidth: CGFloat = DeviceInfo.shared.deviceType == .pad ? 530:268
    let loaderBGWidth: CGFloat = DeviceInfo.shared.deviceType == .pad ? 620:305
    var body: some View {
        
            
                ZStack {
                    Image(.loadingBgDC)
                        .resizable()
                        .scaledToFit()
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.brown)
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 40:20)
                            .cornerRadius(DeviceInfo.shared.deviceType == .pad ? 20:10)
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: loaderWidth * progress, height: DeviceInfo.shared.deviceType == .pad ? 40:20)
                            .cornerRadius(DeviceInfo.shared.deviceType == .pad ? 20:10)
                        Image("loadingBullDC")
                            .resizable()
                            .frame(width: DeviceInfo.shared.deviceType == .pad ? 126:63, height: DeviceInfo.shared.deviceType == .pad ? 140:70)
                            .offset(x: max(0, min(loaderWidth * progress - (DeviceInfo.shared.deviceType == .pad ? 40:20), loaderWidth - (DeviceInfo.shared.deviceType == .pad ? 80:40))), y: DeviceInfo.shared.deviceType == .pad ? -20:-10)
                    }.frame(width: loaderWidth)
                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -6:-3)
                }.frame(width: loaderBGWidth)
            
    }
}
