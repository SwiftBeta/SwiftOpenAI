import Foundation

public protocol ChatCompletionsStreamMappeable {
    func parse(data: Data) throws -> [ChatCompletionsStreamDataModel]
}

public struct ChatCompletionsStreamMapper: ChatCompletionsStreamMappeable {
    private enum Constant: String {
        case streamFinished = "[DONE]"
    }
    
    public init() { }
    
    public func parse(data: Data) throws -> [ChatCompletionsStreamDataModel] {
        guard let dataString = String(data: data, encoding: .utf8) else {
            return []
        }
        
        return try extractDataLine(from: dataString).map {
            guard let jsonData = $0.data(using: .utf8) else {
                return nil
            }
            if $0 == Constant.streamFinished.rawValue {
                return .finished
            } else {
                return try decodeChatCompletionsStreamDataModel(from: jsonData)
            }
        }.compactMap { $0 }
    }
    
    private func extractDataLine(from dataString: String,
                                 dataPrefix: String = "data: ") throws -> [String] {
        let lines = dataString.split(separator: "\n\n").map { String ($0) }
        return lines.map {
            $0.dropFirst(dataPrefix.count).trimmingCharacters(in: .whitespaces)
        }
    }

    private func decodeChatCompletionsStreamDataModel(from data: Data) throws -> ChatCompletionsStreamDataModel? {
        return try JSONDecoder().decode(ChatCompletionsStreamDataModel.self, from: data)
    }
}
