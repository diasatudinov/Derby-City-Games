import SwiftUI

class AchievementsViewModel: ObservableObject {
    @AppStorage("Achievement1") var achievement1: Bool = false
    @AppStorage("Achievement2") var achievement2: Bool = false
    @AppStorage("Achievement3") var achievement3: Bool = false
    @AppStorage("Achievement4") var achievement4: Bool = false
    @AppStorage("Achievement5") var achievement5: Bool = false
    @AppStorage("Achievement6") var achievement6: Bool = false
    @AppStorage("achievement7") var achievement7: Bool = false
    @AppStorage("achievement8") var achievement8: Bool = false
    @AppStorage("achievement9") var achievement9: Bool = false
    @AppStorage("achievement10") var achievement10: Bool = false
    @AppStorage("achievement11") var achievement11: Bool = false
    @AppStorage("achievement12") var achievement12: Bool = false
    @AppStorage("achievement13") var achievement13: Bool = false
    @AppStorage("achievement14") var achievement14: Bool = false
    @AppStorage("achievement15") var achievement15: Bool = false
    @AppStorage("achievement16") var achievement16: Bool = false
    @AppStorage("achievement17") var achievement17: Bool = false
    @AppStorage("achievement18") var achievement18: Bool = false
    @AppStorage("achievement19") var achievement19: Bool = false
    @AppStorage("achievement20") var achievement20: Bool = false
    
    func achievement1Done(for achievement: Int) {
        
        switch achievement {
        case 1:
            achievement1 = true
        case 2:
            achievement2 = true
        case 3:
            achievement3 = true
        case 4:
            achievement4 = true
        case 5:
            achievement5 = true
        case 6:
            achievement6 = true
        case 7:
            achievement7 = true
        case 8:
            achievement8 = true
        case 9:
            achievement9 = true
        case 10:
            achievement10 = true
        case 11:
            achievement11 = true
        case 12:
            achievement12 = true
        case 13:
            achievement13 = true
        case 14:
            achievement14 = true
        case 15:
            achievement15 = true
        case 16:
            achievement16 = true
        case 17:
            achievement17 = true
        case 18:
            achievement18 = true
        case 19:
            achievement19 = true
        case 20:
            achievement20 = true
        default:
            print("error")
        }
    }
}