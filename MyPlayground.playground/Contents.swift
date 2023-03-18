import UIKit
import SwiftOpenAI

var openAI = OpenAI(api: API(),
                    apiKey: "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")


let result = await openAI.createChatCompletion(model: .gpt3_5(.turbo),
                                               messages: [.init(text: "¿Puedes pasarme el código de Hello World en Swift?", role: "user")])
print(result)
