

import SwiftUI

struct MenuTextBg: View {
    @State var text: String
    var body: some View {
        ZStack {
            Image(.buttonBgDC)
                .resizable()
                .scaledToFit()
            
            TextWithBorder(text: text, font: .system(size: DeviceInfo.shared.deviceType == .pad ?  64:32, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 200:100)
    }
}

#Preview {
    MenuTextBg(text: "Play")
}
