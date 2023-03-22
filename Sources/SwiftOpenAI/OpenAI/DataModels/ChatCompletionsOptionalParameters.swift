import Foundation

public struct ChatCompletionsOptionalParameters {
    public let temperature: Int?
    public let topP: Int?
    public let n: Int?
    public let stop: String?
    public let maxTokens: Int?
    public let user: String?
    
    public init(temperature: Int = 1,
                  topP: Int = 1,
                  n: Int = 1,
                  stop: String? = nil,
                  maxTokens: Int? = nil,
                  presencePenalty: Int = 0,
                  frequencyPenalty: Int = 0,
                  user: String? = nil) {
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.stop = stop
        self.maxTokens = maxTokens
        self.user = user
    }
}
