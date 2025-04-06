//
//  MoneyViewCTD.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 06.04.2025.
//


import SwiftUI

struct MoneyViewDC: View {
    @StateObject var user = CTDUser.shared
    @StateObject var statVM = StatisticsViewModelCTD()
    var body: some View {
        ZStack {
            Image(.coinsBg)
                .resizable()
                .scaledToFit()
                
            HStack(spacing: 15) {
                
                Text("\(user.money)")
                    .font(.system(size: CTDDeviceManager.shared.deviceType == .pad ? 40:20, weight: .black))
                    .foregroundStyle(.white)
                    .textCase(.uppercase)
                    
                Image(.coinIconCTD)
                    .resizable()
                    .scaledToFit()
                    .frame(height: CTDDeviceManager.shared.deviceType == .pad ? 74:37)
            }
        }.frame(height: CTDDeviceManager.shared.deviceType == .pad ? 100:50)
            .onChange(of: user.money) { value in
                if user.oldMoney > value {
                    statVM.goldSpent += abs(user.oldMoney - value)
                } else {
                    statVM.goldAccumulated += abs(user.oldMoney - value)
                }
            }
    }
}

#Preview {
    MoneyViewDC()
}
