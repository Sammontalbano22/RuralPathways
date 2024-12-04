import Foundation

struct Config {
    // OpenAI API Key
    static let openAIAPIKey: String = {
        guard let url = Bundle.main.url(forResource: "Config1", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = plist["OpenAI_API_Key"] as? String else {
            fatalError("OpenAI API Key not found in Config.plist")
        }
        return key
    }()
    
    //OpenAI API Key
    static let College_Scorecard: String = {
        guard let url = Bundle.main.url(forResource: "Config1", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = plist["College_Scorecard-API-Key"] as? String else {
            fatalError("College scorecard not found in Config.plist")
        }
        return key
    }()
}
