import SwiftUI

struct RulesView: View {
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
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
        .background(
            Image(.rulesView)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
        )
    }
}

#Preview {
    RulesView()
}
