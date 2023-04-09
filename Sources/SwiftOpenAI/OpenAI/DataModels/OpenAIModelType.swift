import Foundation

public enum OpenAIModelType {
    case gpt4(GPT4)
    case gpt3_5(GPT3_5)
    case edit(EditModel)
    case embedding(EmbeddingModel)

    var name: String {
        switch self {
        case .gpt4(let gpt4Model):
            return gpt4Model.rawValue
        case .gpt3_5(let gpt3_5Model):
            return gpt3_5Model.rawValue
        case .edit(let editModel):
            return editModel.rawValue
        case .embedding(let embeddingModel):
            return embeddingModel.rawValue
        }
    }
}

public enum GPT4: String {
    case base = "gpt-4"
    case gpt_4_0314 = "gpt-4-0314"
    case gpt_4_32k = "gpt-4-32k"
    case gpt_4_32k_0314 = "gpt-4-32k-0314"
}

public enum GPT3_5: String {
    case turbo = "gpt-3.5-turbo"
    case gpt_3_5_turbo_0301 = "gpt-3.5-turbo-0301"
    case text_davinci_003 = "text-davinci-003"
    case text_davinci_002 = "text-davinci-002"
    case code_davinci_002 = "code-davinci-002"
}

public enum EditModel: String {
    case text_davinci_edit_001 = "text-davinci-edit-001"
    case code_davinci_edit_001 = "code-davinci-edit-001"
}

public enum EmbeddingModel: String {
    case text_embedding_ada_002 = "text-embedding-ada-002"
}
