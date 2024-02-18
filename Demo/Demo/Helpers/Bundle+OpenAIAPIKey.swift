import Foundation

extension Bundle {
    func getOpenAIApiKey() -> String? {
        guard let path = Bundle.main.path(forResource: "SwiftOpenAI", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let value = plist.object(forKey: "OpenAI_API_Key") as? String,
                !value.isEmpty else {
            print("👇 Add your OpenAI API Key inside the project's SwiftOpenAI.plist 👇\nVisit: 🔗 https://platform.openai.com/api-keys")
            return nil
        }
        return value
    }
}
