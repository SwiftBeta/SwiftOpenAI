# 🧰 SwiftOpenAI (OpenaAI SDK)
![Portada](https://user-images.githubusercontent.com/74316958/226199102-640e639d-a46f-4891-9d03-140d8f9a5efc.png)
[![Build Status](https://app.bitrise.io/app/f2f57021-2138-4c3c-8297-297e35300c72/status.svg?token=Q_DK2uHJyMAZn2diNTk3lQ&branch=main)](https://app.bitrise.io/app/f2f57021-2138-4c3c-8297-297e35300c72)
<br/>
[![Twitter Follow](https://img.shields.io/twitter/follow/swiftbeta_?style=social)](https://twitter.com/swiftbeta_)
<br/>
[![Youtube Views](https://img.shields.io/youtube/channel/views/UC2MAP8k0bzwq_OAA_zQw27A?style=social)](https://twitter.com/swiftbeta)
[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UC2MAP8k0bzwq_OAA_zQw27A?style=social)](https://youtube.com/swiftbeta?sub_confirmation=1)
<br/>
![GitHub Stars](https://img.shields.io/github/stars/swiftbeta?style=social)
![GitHub Followers](https://img.shields.io/github/followers/swiftbeta?style=social)
<br/>
[![Discord](https://img.shields.io/discord/922567653778944031?style=social&label=Discord&logo=discord)](https://www.swiftbeta.com/discord)

## Introduction

`SwiftOpenAI` is a powerful and easy-to-use Swift SDK designed to seamlessly integrate with `OpenAI's API`. The main goal of this SDK is to simplify the process of accessing and interacting with OpenAI's cutting-edge AI models, such as GPT-4, GPT-3, and future models, all within your Swift applications.

![Untitled](https://user-images.githubusercontent.com/74316958/228327592-e45e7dc1-fa04-4042-81c8-dc1fca52ff47.gif)

## ⚙️ Installation

Open Xcode and open the `Swift Package Manager` section, then paste the Github URL from this repository (Copy -> https://github.com/SwiftBeta/SwiftOpenAI.git) to install the Package in your project.

<table>
  <tr>
    <td>
      <img width="600" alt="Installation-1" src="https://user-images.githubusercontent.com/74316958/226197041-8e9eef1d-c4aa-4fab-bb8a-9d96e260be7e.png">
    </td>
    <td>
      <img width="600" alt="Installation-2" src="https://user-images.githubusercontent.com/74316958/226197049-f587dcf9-c6f0-4542-9b6d-e9cbcc03fdce.png">
    </td>
  </tr>
</table>

## 💻 Usage

Using SwiftOpenAI` is simple and straightforward. Follow these steps to start interacting with OpenAI's API in your Swift project:

1. `Import SwiftOpenAI`
2. `var openAI = SwiftOpenAI(apiKey: "YOUR-API-KEY")`

## [Models](https://platform.openai.com/docs/api-reference/models)
List and describe the various models available in the API. You can refer to the Models documentation to understand what models are available and the differences between them.

```swift
do {
    let modelList = try await openAI.listModels()
    print(modelList)
} catch {
    print("Error: \(error)")
}
```

## [Completions](https://platform.openai.com/docs/api-reference/completions)
Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.

```swift
let prompt = "Once upon a time, in a land far, far away,"
let optionalParameters = CompletionsOptionalParameters(prompt: prompt, maxTokens: 50, temperature: 0.7, n: 1)

do {
    let completions = try await openAI.completions(model: .gpt3_5(.text_davinci_003), optionalParameters: optionalParameters)
    print(completions)
} catch {
    print("Error: \(error)")
}
```

## [ChatCompletions with Stream](https://platform.openai.com/docs/api-reference/chat/create)
Given a chat conversation, the model will return a chat completion response.

```swift
let messages: [MessageChatGPT] = [
  MessageChatGPT(text: "You are a helpful assistant.", role: .system),
  MessageChatGPT(text: "Who won the world series in 2020?", role: .user)
]
let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.7, stream: true, maxTokens: 50)

do {
    let stream = try await openAI.createChatCompletionsStream(model: .gpt4(.base), messages: messages, optionalParameters: optionalParameters)
    
    for try await response in stream {
        print(response)
    }
} catch {
    print("Error: \(error)")
}
```

## [ChatCompletions without Stream](https://platform.openai.com/docs/api-reference/chat/create)
Given a chat conversation, the model will return a chat completion response.

```swift
let messages: [MessageChatGPT] = [
    MessageChatGPT(text: "You are a helpful assistant.", role: .system),
    MessageChatGPT(text: "Who won the world series in 2020?", role: .user)
]
let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.7, maxTokens: 50)

do {
    let chatCompletions = try await openAI.createChatCompletions(model: .gpt4(.base), messages: messages, optionalParameters: optionalParameters)
    print(chatCompletions)
} catch {
    print("Error: \(error)")
}
```

## [Edits](https://platform.openai.com/docs/api-reference/edits)
Given a prompt and an instruction, the model will return an edited version of the prompt.

```swift
let inputText = "The car have four weels."
let instruction = "Please correct any grammatical errors in the text."

do {
    let edits = try await openAI.edits(model: .edit(.text_davinci_edit_001), input: inputText, instruction: instruction)
  print(edits)
} catch {
  print("Error: \(error)")
}
```

## [Create Image with DALL·E 2](https://platform.openai.com/docs/api-reference/images/create)
Given a prompt and/or an input image, the model will generate a new image.

```swift
do {
    let images = try await openAI.createImages(prompt: prompt,
                                               numberOfImages: 4,
                                               size: .s1024)
    print(images)                                               
} catch {
    print("Error: \(error)")
}
```

## [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.

```swift
let inputText = "Embeddings are a numerical representation of text."

do {
  let embeddings = try await openAI.embeddings(model: .embedding(.text_embedding_ada_002), input: inputText)
  print(embeddings)
} catch {
  print("Error: \(error)")
}
```

## [Moderations](https://platform.openai.com/docs/api-reference/embeddings)
Given a input text, outputs if the model classifies it as violating OpenAI's content policy.

```swift
let inputText = "Some potentially harmful or explicit content."

do {
    let moderationResults = try await openAI.moderations(input: inputText)
    print(moderationResults)
} catch {
    print("Error: \(error)")
}
```

---

## Code Examples using the API

Here you have a full example using SwiftUI:

The `createChatCompletions` method allows you to interact with the OpenAI API by generating chat-based completions. Provide the necessary parameters to customize the completions, such as model, messages, and other optional settings.

![1](https://user-images.githubusercontent.com/74316958/229309185-205c9b43-03b2-4a23-95e0-3fbaf9949d0b.gif)


```swift
import SwiftUI
import SwiftOpenAI

struct ContentView: View {
    var openAI = SwiftOpenAI(apiKey: "YOUR-API-KEY")
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                do {
                    for try await newMessage in try await openAI.createChatCompletionsStream(model: .gpt3_5(.turbo),
                                                                                             messages: [.init(text: "Generate the Hello World in Swift for me", role: .user)],
                                                                                             optionalParameters: .init(stream: true)) {
                           print("New Message Received: \(newMessage) ")
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
```

## Another example
The `createChatCompletions` method allows you to interact with the OpenAI API by generating chat-based completions. Provide the necessary parameters to customize the completions, such as model, messages, and other optional settings.

![2](https://user-images.githubusercontent.com/74316958/229309147-23169fa6-b495-44fb-913e-de2c57b9a716.gif)

```swift
import SwiftUI
import SwiftOpenAI

struct ContentView: View {
    var openAI = SwiftOpenAI(apiKey: "YOUR-API-KEY")
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                do {
                    let result = try await openAI.createChatCompletions(model: .gpt3_5(.turbo),
                                                                        messages: [.init(text: "Generate the Hello World in Swift for me", role: .user)])
                    print(result)
                } catch {
                    print(error)
                }
            }
        }
    }
}
```

## 📝 License
MIT License

Copyright 2023 SwiftBeta

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## 📬 CONTACT INFORMATION
swiftbeta.blog@gmail.com

[twitter.com/swiftbeta_](https://www.twitter.com/swiftbeta_)

[youtube.com/@swiftbeta](https://youtube.com/@swiftbeta)


