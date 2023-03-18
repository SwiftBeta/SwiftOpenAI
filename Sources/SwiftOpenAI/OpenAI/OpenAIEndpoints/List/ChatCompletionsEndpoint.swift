import Foundation

struct ChatCompletionsEndpoint: Endpoint {
    private let model: OpenAIModelType
    private var messages: [[String: String]] = []
    
    private let temperature: Int?
    private let topP: Int?
    private let n: Int?
    private let steam: Bool?
    private let stop: String?
    private let maxTokens: Int?
    private let presencePenalty: Int?
    private let frequencyPenalty: Int?
    private let user: String?
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String = "chat/completions"
    
    init(model: OpenAIModelType,
         messages: [MessageChatGPT],
         temperature: Int? = nil,
         topP: Int? = nil,
         n: Int? = nil,
         steam: Bool? = nil,
         stop: String? = nil,
         maxTokens: Int? = nil,
         presencePenalty: Int? = nil,
         frequencyPenalty: Int? = nil,
         user: String? = nil) {
        self.model = model
        self.messages = Self.mapMessageModelToDictionary(messages: messages)
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.steam = steam
        self.stop = stop
        self.maxTokens = maxTokens
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.user = user
    }
    
    var parameters: [String : Any]? {
        ["model": self.model.name as Any,
         "messages": self.messages as Any]
    }
    
    private static func mapMessageModelToDictionary(messages: [MessageChatGPT]) -> [[String: String]] {
        var myConversationDictionary: [String: String] = [:]
        
        for message in messages {
            myConversationDictionary["role"] = message.role
            myConversationDictionary["content"] = message.text
        }
        
        return [myConversationDictionary]
    }
}
