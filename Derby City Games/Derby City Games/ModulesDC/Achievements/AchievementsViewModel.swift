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
    
    @Published var achievements: [Achievement] = [
        Achievement(image: "achievement1", title: "First fight", subtitle: "To finish the first match", recieved: false),
        Achievement(image: "achievement2", title: "Sharp Eye", subtitle: "Hit your opponent 10 times in a row", recieved: false),
        Achievement(image: "achievement3", title: "Crusher", subtitle: "Win 10 matches in a row", recieved: false),
        Achievement(image: "achievement4", title: "Formidable Bull", subtitle: "Deal 5000 damage over the course of the game", recieved: false),
        Achievement(image: "achievement5", title: "Wind Assist", subtitle: "Hit your opponent using the wind's influence", recieved: false),
        
        Achievement(image: "achievement6", title: "Precise Calculation", subtitle: "Win with the last throw with minimal health", recieved: false),
        Achievement(image: "achievement7", title: "Force of Nature", subtitle: "Use every type of throwing object", recieved: false),
        Achievement(image: "achievement8", title: "Critical Moment", subtitle: "Deal critical damage 5 times in a single fight", recieved: false),
        Achievement(image: "achievement9", title: "King of the arena", subtitle: "Capture 80% of wins in ranked matches", recieved: false),
        Achievement(image: "achievement10", title: "Victorious", subtitle: "50 victories", recieved: false),
        
        Achievement(image: "achievement11", title: "Iron Bull", subtitle: "Survive a match when you have 10% or less health left", recieved: false),
        Achievement(image: "achievement12", title: "Arena Legend", subtitle: "Achieve 100 victories", recieved: false),
        Achievement(image: "achievement13", title: "Defender", subtitle: "Deflect 10 attacks with your shield", recieved: false),
        Achievement(image: "achievement14", title: "Bull Fury", subtitle: "Win a match using only boosted throws", recieved: false),
        Achievement(image: "achievement15", title: "Tactical Master", subtitle: "Win a match using at least 3 different skills", recieved: false),
        
        Achievement(image: "achievement16", title: "Golden Bull", subtitle: "Accumulate 10,000 coins", recieved: false),
        Achievement(image: "achievement17", title: "Invulnerable", subtitle: "Win the match without taking a single hit", recieved: false),
    ]
    
    func achievementRecieve(for achievement: Achievement) {
        if let index = achievements.firstIndex(where: { $0.image == achievement.image }) {
            achievements[index].recieved = true
        }
    }
    
    func achievementIsDone(for achievement: String) {
        
        switch achievement {
        case "achievement1":
            achievement1 = true
        case "achievement2":
            achievement2 = true
        case "achievement3":
            achievement3 = true
        case "achievement4":
            achievement4 = true
        case "achievement5":
            achievement5 = true
        case "achievement6":
            achievement6 = true
        case "achievement7":
            achievement7 = true
        case "achievement8":
            achievement8 = true
        case "achievement9":
            achievement9 = true
        case "achievement10":
            achievement10 = true
        case "achievement11":
            achievement11 = true
        case "achievement12":
            achievement12 = true
        case "achievement13":
            achievement13 = true
        case "achievement14":
            achievement14 = true
        case "achievement15":
            achievement15 = true
        case "achievement16":
            achievement16 = true
        case "achievement17":
            achievement17 = true
        default:
            print("error")
        }
    }
    
    func getAchievement(for achievement: String) -> Bool {
        
        switch achievement {
        case "achievement1":
            return achievement1
        case "achievement2":
            return achievement2
        case "achievement3":
            return achievement3
        case "achievement4":
            return achievement4
        case "achievement5":
            return achievement5
        case "achievement6":
            return achievement6
        case "achievement7":
            return achievement7
        case "achievement8":
            return achievement8
        case "achievement9":
            return achievement9
        case "achievement10":
            return achievement10
        case "achievement11":
            return achievement11
        case "achievement12":
            return achievement12
        case "achievement13":
            return achievement13
        case "achievement14":
            return achievement14
        case "achievement15":
            return achievement15
        case "achievement16":
            return achievement16
        case "achievement17":
            return achievement17
        default:
            return false
        }
    }
}

struct Achievement: Codable, Equatable, Hashable {
    var id = UUID()
    var image: String
    var title: String
    var subtitle: String
    var recieved: Bool
}
