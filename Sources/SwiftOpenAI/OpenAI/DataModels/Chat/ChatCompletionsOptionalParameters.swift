import Foundation

public struct ChatCompletionsOptionalParameters {
    public let temperature: Double?
    public let topP: Int?
    public let n: Int?
    public let stop: String?
    public let stream: Bool
    public let maxTokens: Int?
    public let user: String?

    public init(temperature: Double = 1.0,
                topP: Int = 1,
                n: Int = 1,
                stop: String? = nil,
                stream: Bool = false,
                maxTokens: Int? = nil,
                presencePenalty: Int = 0,
                frequencyPenalty: Int = 0,
                user: String? = nil) {
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.stop = stop
        self.stream = stream
        self.maxTokens = maxTokens
        self.user = user
    }
}
