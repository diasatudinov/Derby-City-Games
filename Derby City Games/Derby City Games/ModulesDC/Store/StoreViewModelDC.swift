import SwiftUI

class StoreViewModelDC: ObservableObject {
    @Published var shopItems: [Item] = [
        Item(name: "Classic arena", icon: "bgIcon1", image: "bgImage1", price: 100, category: .backgrounds),
        Item(name: "Desert", icon: "bgIcon2", image: "bgImage2", price: 100, category: .backgrounds),
        Item(name: "Arctic", icon: "bgIcon3", image: "bgImage3", price: 100, category: .backgrounds),
        Item(name: "Forest glade", icon: "bgIcon1", image: "bgImage4", price: 100, category: .backgrounds),
        
        Item(name: "Classic bull", icon: "skinIcon1", image: "skinImage1", price: 200, category: .skins),
        Item(name: "Fire bull", icon: "skinIcon2", image: "skinImage2", price: 200, category: .skins),
        Item(name: "Mechanical bull", icon: "skinIcon3", image: "skinImage3", price: 200, category: .skins),
        Item(name: "Rainbow bull", icon: "skinIcon4", image: "skinImage4", price: 200, category: .skins),
        
        Item(name: "Capa", icon: "throwIcon1", image: "throwIcon1", price: 300, category: .throwObjects),
        Item(name: "Barrel", icon: "throwIcon2", image: "throwIcon2", price: 300, category: .throwObjects),
        Item(name: "Stone", icon: "throwIcon3", image: "throwIcon3", price: 300, category: .throwObjects),
        Item(name: "Apple", icon: "throwIcon4", image: "throwIcon4", price: 300, category: .throwObjects),
        
        Item(name: "Double Damage", icon: "skillsIcon1", image: "skillsIcon1", price: 10, category: .skills),
        Item(name: "Shield", icon: "skillsIcon2", image: "skillsIcon2", price: 20, category: .skills),
        Item(name: "Reinforced Throw", icon: "skillsIcon3", image: "skillsIcon3", price: 30, category: .skills),
        Item(name: "Healing", icon: "skillsIcon4", image: "skillsIcon4", price: 40, category: .skills),
    ]
    
    @Published var boughtItems: [Item] = [
        Item(name: "Classic arena", icon: "bgIcon1", image: "bgImage1", price: 100, category: .backgrounds),
        Item(name: "Classic bull", icon: "skinIcon1", image: "skinImage1", price: 200, category: .skins),
        Item(name: "Capa", icon: "throwIcon1", image: "throwIcon1", price: 300, category: .throwObjects),
        Item(name: "Double Damage", icon: "skillsIcon1", image: "skillsIcon1", price: 10, category: .skills),

    ] {
        didSet {
            saveBoughtItem()
        }
    }
    
    @Published var currentBgItem: Item? {
        didSet {
            saveBgItem()
        }
    }
    
    @Published var currentSkinItem: Item? {
        didSet {
            saveSkinItem()
        }
    }
    
    @Published var currentThrowItem: Item? {
        didSet {
            saveThrowItem()
        }
    }
    
    @Published var currentSkillItem: Item? {
        didSet {
            saveSkillItem()
        }
    }
    
    init() {
        loadBgItem()
        loadSkinItem()
        loadThrowItem()
        loadSkillItem()
        loadBoughtItem()
        
        
    }
    
    private let userDefaultsBgKey = "userDefaultsBgKey1"
    private let userDefaultsSkinKey = "userDefaultsSkinKey1"
    private let userDefaultsThrowKey = "userDefaultsThrowKey1"
    private let userDefaultsSkillKey = "userDefaultsSkillKey1"
    private let userDefaultsBoughtKey = "boughtItem"

    //MARK: - BG Item userDefault
    func saveBgItem() {
        if let currentItem = currentBgItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsBgKey)
            }
        }
    }
    
    func loadBgItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBgKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentBgItem = loadedItem
        } else {
            currentBgItem = shopItems[0]
            print("No saved data found")
        }
    }
    
    //MARK: - Skin Item userDefault
    func saveSkinItem() {
        if let currentItem = currentSkinItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsSkinKey)
            }
        }
    }
    
    func loadSkinItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsSkinKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentSkinItem = loadedItem
        } else {
            currentSkinItem = shopItems[4]
            print("No saved data found")
        }
    }
    
    //MARK: - Throw Item userDefault
    func saveThrowItem() {
        if let currentItem = currentThrowItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsThrowKey)
            }
        }
    }
    
    func loadThrowItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsThrowKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentThrowItem = loadedItem
        } else {
            currentThrowItem = shopItems[8]
            print("No saved data found")
        }
    }
    
    //MARK: - Skill Item userDefault
    func saveSkillItem() {
        if let currentItem = currentSkillItem {
            if let encodedData = try? JSONEncoder().encode(currentItem) {
                UserDefaults.standard.set(encodedData, forKey: userDefaultsSkillKey)
            }
        }
    }
    
    func loadSkillItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsSkillKey),
           let loadedItem = try? JSONDecoder().decode(Item.self, from: savedData) {
            currentSkillItem = loadedItem
        } else {
            currentSkillItem = shopItems[12]
            print("No saved data found")
        }
    }
    
    func saveBoughtItem() {
        if let encodedData = try? JSONEncoder().encode(boughtItems) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsBoughtKey)
        }
        
    }
    
    func loadBoughtItem() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsBoughtKey),
           let loadedItem = try? JSONDecoder().decode([Item].self, from: savedData) {
            boughtItems = loadedItem
        } else {
            print("No saved data found")
        }
    }
    
}

struct Item: Codable, Hashable {
    var id = UUID()
    var name: String
    var icon: String
    var image: String
    var price: Int
    var category: storeSections
    
}
