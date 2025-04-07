//
//  StoreView.swift
//  Derby City Games
//
//  Created by Dias Atudinov on 07.04.2025.
//

import SwiftUI

enum storeSections: String {
    case backgrounds = "Backgrounds", skins = "Skins" , throwObjects = "Throwing \nobjects", skills = "Special \nskills"
}

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    private let sections: [storeSections] = [.backgrounds, .skins, .throwObjects, .skills]
    
    @State private var selectedSection: storeSections = .backgrounds
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                
                
                
                HStack {
                    ForEach(sections, id: \.self) { section in
                        
                        ZStack {
                            Image(.buttonBgDC)
                                .resizable()
                                .scaledToFit()
                            TextWithBorder(text: section.rawValue, font: .system(size: DeviceInfo.shared.deviceType == .pad ?  28:14, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                .multilineTextAlignment(.center)
                        }.frame(height: 67)
                            .offset(y: selectedSection == section ? -20:0)
                            .onTapGesture {
                                withAnimation {
                                    selectedSection = section
                                }
                            }
                    }
                }
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
        }.background(
            Image(.bgDC)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
        )
    }
}

#Preview {
    StoreView()
}
