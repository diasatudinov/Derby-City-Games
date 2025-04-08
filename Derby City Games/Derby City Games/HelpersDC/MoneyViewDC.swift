
import SwiftUI

struct MoneyViewDC: View {
    @StateObject var user = DCUser.shared
    var body: some View {
        ZStack {
            Image(.coinsBgDC)
                .resizable()
                .scaledToFit()
                
            HStack(spacing: 15) {
                Image(.coinsIconDC)
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 70:35)
                
                Text("\(user.money)")
                    .font(.system(size: DeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    
                
            }
        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 126:63)
            
    }
}

#Preview {
    MoneyViewDC()
}
