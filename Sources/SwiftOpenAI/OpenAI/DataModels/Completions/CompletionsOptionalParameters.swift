import Foundation

public struct CompletionsOptionalParameters {
    public let prompt: String
    public let suffix: String?
    public let maxTokens: Int?
    public let temperature: Double?
    public let topP: Int?
    public let n: Int?
    public let logprobs: Int?
    public let echo: Bool?
    public let stop: String?
    public let presencePenalty: Int?
    public let frequencyPenalty: Int?
    public let bestOf: Int?
    public let user: String?

    public init(prompt: String,
                suffix: String = "",
                maxTokens: Int? = 16,
                temperature: Double? = 1.0,
                topP: Int? = 1,
                n: Int? = 1,
                logprobs: Int? = nil,
                echo: Bool? = false,
                stop: String? = nil,
                presencePenalty: Int? = 0,
                frequencyPenalty: Int? = 0,
                bestOf: Int? = 1,
                user: String = "") {
        self.prompt = prompt
        self.suffix = suffix
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.topP = topP
        self.n = n
        self.logprobs = logprobs
        self.echo = echo
        self.stop = stop
        self.presencePenalty = presencePenalty
        self.frequencyPenalty = frequencyPenalty
        self.bestOf = bestOf
        self.user = user
    }
}
