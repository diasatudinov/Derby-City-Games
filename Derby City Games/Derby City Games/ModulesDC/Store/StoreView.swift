import SwiftUI

enum storeSections: String, Codable, Hashable {
    case backgrounds = "Backgrounds", 
         skins = "Skins" ,
         throwObjects = "Throwing \nobjects",
         skills = "Special \nskills"
}

struct StoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = DCUser.shared
    private let sections: [storeSections] = [.backgrounds, .skins, .throwObjects, .skills]
    
    @State private var selectedSection: storeSections = .backgrounds
    
    @ObservedObject var viewModel: StoreViewModelDC
    
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                HStack {
                    
                    switch selectedSection {
                    case .backgrounds:
                        ForEach(viewModel.shopItems.filter({ $0.category == selectedSection}), id: \.self) { item in
                            itemCell(for: item)
                        }
                    case .skins:
                        ForEach(viewModel.shopItems.filter({ $0.category == selectedSection}), id: \.self) { item in
                            itemCell(for: item)
                        }
                    case .throwObjects:
                        ForEach(viewModel.shopItems.filter({ $0.category == selectedSection}), id: \.self) { item in
                            itemCell(for: item)
                        }
                    case .skills:
                        ForEach(viewModel.shopItems.filter({ $0.category == selectedSection}), id: \.self) { item in
                            itemCell(for: item)
                        }
                    }
                    
                    
                    
                }
                
                
                
                
                
                HStack {
                    ForEach(sections, id: \.self) { section in
                        
                        ZStack {
                            Image(.buttonBgDC)
                                .resizable()
                                .scaledToFit()
                            TextWithBorder(text: section.rawValue, font: .system(size: DeviceInfo.shared.deviceType == .pad ?  28:14, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                                .multilineTextAlignment(.center)
                        }.frame(height: DeviceInfo.shared.deviceType == .pad ? 134:67)
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
    
    @ViewBuilder func itemCell(for item: Item) -> some View {
        ZStack {
            Image(.itemBgDC)
                .resizable()
                .scaledToFit()
               
            VStack {
                Image("\(item.icon)")
                    .resizable()
                    .scaledToFit()
                    .frame(height: DeviceInfo.shared.deviceType == .pad ? 114:57)
                
                TextWithBorder(text: item.name, font: .system(size: DeviceInfo.shared.deviceType == .pad ? 28:14, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                
                if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                    HStack {
                        Image(.coinDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 32:16)
                        
                        TextWithBorder(text: "\(item.price)", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 24:12, weight: .bold), textColor: .white, borderColor: .black, borderWidth: 1)
                    }
                } else {
                        Image(.coinDC)
                            .resizable()
                            .scaledToFit()
                            .frame(height: DeviceInfo.shared.deviceType == .pad ? 32:16)
                            .opacity(0)
                }
                
                Button {
                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                        switch selectedSection {
                        case .backgrounds:
                            viewModel.currentBgItem = item
                        case .skins:
                            viewModel.currentSkinItem = item
                            
                        case .throwObjects:
                            viewModel.currentThrowItem = item
                        case .skills:
                            viewModel.currentSkillItem = item
                        }
                    } else {
                        if user.money >= item.price {
                            user.minusUserMoney(for: item.price)
                            if !viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                                viewModel.boughtItems.append(item)
                            }
                        }
                    }
                } label: {
                    
                    if viewModel.boughtItems.contains(where: { $0.name == item.name }) {
                        
                        switch item.category {
                       
                        case .backgrounds:
                            if let bgItem = viewModel.currentBgItem, bgItem.name == item.name {
                                ZStack {
                                    Image(.recievedBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Selected", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            } else {
                                ZStack {
                                    Image(.pickUpBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Select", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            }
                        case .skins:
                            if let skinItem = viewModel.currentSkinItem, skinItem.name == item.name {
                                ZStack {
                                    Image(.recievedBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Selected", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            } else {
                                ZStack {
                                    Image(.pickUpBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Select", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            }
                        case .throwObjects:
                            if let throwItem = viewModel.currentThrowItem, throwItem.name == item.name {
                                ZStack {
                                    Image(.recievedBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Selected", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            } else {
                                ZStack {
                                    Image(.pickUpBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Select", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            }
                        case .skills:
                            if let skillItem = viewModel.currentSkillItem, skillItem.name == item.name {
                                ZStack {
                                    Image(.recievedBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Selected", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            } else {
                                ZStack {
                                    Image(.pickUpBg)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                                    TextWithBorder(text: "Select", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                        .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                                }
                            }
                        }
                        
                    } else {
                        
                        ZStack {
                            Image(DCUser.shared.money >= item.price ? .recievedBg: .notAchievedBg)
                                .resizable()
                                .scaledToFit()
                                .frame(height: DeviceInfo.shared.deviceType == .pad ? 82:41)
                            
                            TextWithBorder(text: "Buy", font: .system(size: DeviceInfo.shared.deviceType == .pad ? 20:10), textColor: .white, borderColor: .black, borderWidth: 1)
                                .offset(y: DeviceInfo.shared.deviceType == .pad ? -8:-4)
                        }
                    }
                }
            }
        } .frame(height: DeviceInfo.shared.deviceType == .pad ? 384:192)
    }
}

#Preview {
    StoreView(viewModel: StoreViewModelDC())
}


