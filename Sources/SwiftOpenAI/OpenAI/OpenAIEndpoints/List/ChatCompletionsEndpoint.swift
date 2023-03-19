import Foundation

struct ChatCompletionsEndpoint: Endpoint {
    private let model: OpenAIModelType
    private var messages: [[String: String]] = []
    
    private let optionalParameters: ChatCompletionsOptionalParameters?
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String = "chat/completions"
    
    init(model: OpenAIModelType,
         messages: [MessageChatGPT],
         optionalParameters: ChatCompletionsOptionalParameters?) {
        self.model = model
        self.messages = Self.mapMessageModelToDictionary(messages: messages)
        self.optionalParameters = optionalParameters
    }
    
    var parameters: [String : Any]? {
        ["model": self.model.name as Any,
         "messages": self.messages as Any,
         "temperature": self.optionalParameters?.temperature as Any,
         "top_p": self.optionalParameters?.topP as Any,
         "n": self.optionalParameters?.n as Any,
         "stream": self.optionalParameters?.stream as Any,
         "stop": self.optionalParameters?.stop as Any,
         "max_tokens": self.optionalParameters?.maxTokens as Any]
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
