# 🧰 SwiftOpenAI (OpenaAI SDK)
![Portada](https://user-images.githubusercontent.com/74316958/226199102-640e639d-a46f-4891-9d03-140d8f9a5efc.png)
[![Build Status](https://app.bitrise.io/app/f2f57021-2138-4c3c-8297-297e35300c72/status.svg?token=Q_DK2uHJyMAZn2diNTk3lQ&branch=main)](https://app.bitrise.io/app/f2f57021-2138-4c3c-8297-297e35300c72)
[![Youtube Views](https://img.shields.io/youtube/channel/views/UC2MAP8k0bzwq_OAA_zQw27A?style=social)](https://twitter.com/swiftbeta)
[![YouTube Channel Subscribers](https://img.shields.io/youtube/channel/subscribers/UC2MAP8k0bzwq_OAA_zQw27A?style=social)](https://youtube.com/swiftbeta?sub_confirmation=1)
![GitHub Followers](https://img.shields.io/github/followers/swiftbeta?style=social)

## Introduction

`SwiftOpenAI` is a powerful and easy-to-use Swift SDK designed to seamlessly integrate with `OpenAI's API`. The main goal of this SDK is to simplify the process of accessing and interacting with OpenAI's cutting-edge AI models, such as GPT-4, GPT-3, and future models, all within your Swift applications.

![Untitled](https://user-images.githubusercontent.com/74316958/227765603-2f291b9e-3550-4adc-8426-ad981f050df3.gif)

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

## 1️⃣ Import SwiftOpenAI
First, import the SwiftOpenAI module in the file where you want to use it:
```swift
import SwiftOpenAI
```

## 2️⃣ Create an instance of SwiftOpenAI
Next, create an instance of the SwiftOpenAI class, passing your OpenAI API key as a parameter. Make sure you have already obtained an API key from your [OpenAI account](https://platform.openai.com/account/api-keys).
```swift
var openAI = SwiftOpenAI(apiKey: "YOUR-API-KEY")
```

## 3️⃣ Use the createChatCompletionsStream method (Receive message in real time)
The `createChatCompletionsStream` method allows you to interact with the OpenAI API by generating chat-based completions. Provide the necessary parameters to customize the completions, such as model, messages, and other optional settings.

```swift
do {
    for try await newMessage in try await openAI.createChatCompletionsStream(model: .gpt3_5(.turbo),
                                                                             messages: [.init(text: "Generate the Hello World in Swift for me", role: "user")],
                                                                             optionalParameters: .init(stream: true)) {
                print("New Message Received: \(newMessage) ")
    }
} catch {
    print(error)
}
```

Here you have a full example using SwiftUI:

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
                                                                                             messages: [.init(text: "Generate the Hello World in Swift for me", role: "user")],
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

## 4️⃣ Use the createChatCompletions method
The `createChatCompletions` method allows you to interact with the OpenAI API by generating chat-based completions. Provide the necessary parameters to customize the completions, such as model, messages, and other optional settings.

```swift
do {
    let result = try await openAI.createChatCompletions(model: .gpt3_5(.turbo),
                                                        messages: [.init(text: "Generate the Hello World in Swift for me", role: "user")])
    print(result)
} catch {
    print(error)
}
```

Here you have a full example using SwiftUI:

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
                                                                        messages: [.init(text: "Generate the Hello World in Swift for me", role: "user")])
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


