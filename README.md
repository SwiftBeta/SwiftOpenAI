# 🧰 SwiftOpenAI (OpenAI SDK)
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

This is a Swift community-driven repository for interfacing with the [OpenAI](https://platform.openai.com/docs/api-reference/) public API. 

- [Introduction](#introduction)
- [Demo App](#demo-app)
- [Installation New Project](#%EF%B8%8F-installation-new-project)
- [Usage](#-usage)
    - [Secure your API Key using a .plist](#secure-your-api-key-using-a-plist)
    - [Images](#images)
        - [Create Image](#create-image)
    - [Audio](#audio)
        - [Create Speech](#create-speech)
        - [Create Transcription](#create-transcription)
    - [Models](#models)
        - [List Models](#list-models)
    - [Chats](#chats)
        - [Create Chat with Stream](#create-chat-with-stream)
        - [Create Chat without Stream](#create-chat-without-stream)
        - [Create Chat with Image Input](#create-chat-with-image-input)
    - [Embeddings](#embeddings)
    - [Moderations](#moderations)
    - [Completions](#completions)
- [License](#-license)

## Introduction

`SwiftOpenAI` is a community-maintained, powerful, and easy-to-use Swift SDK. It is designed to integrate seamlessly with OpenAI's API. The main goal of this SDK is to make it simpler to access and interact with OpenAI's advanced AI models, such as GPT-4, GPT-3, and future models, all within your Swift applications.

To help developers, I have created this demo app. You only need to add your OpenAI API Key in the SwiftOpenAI.plist. Inside the demo app, you have access to the core features of the SDK.

![SwiftOpenAI Demo](https://github.com/SwiftBeta/SwiftOpenAI/assets/74316958/8a93f3ad-f895-4471-b8af-196dc052d336)

## Demo App

To try the demo app, you only need to open Demo.xcodeproj.

<img width="623" alt="Demo" src="https://github.com/SwiftBeta/SwiftOpenAI/assets/74316958/3f3d6765-5a96-48d3-9173-46bb2923dca1">

After that, you will see the project. The next step is to compile your project on one of the simulators (or a real device)

<img width="2672" alt="Xcode Demo" src="https://github.com/SwiftBeta/SwiftOpenAI/assets/74316958/279ba6f9-474e-4512-a802-fbfae95f2398">

## ⚙️ Installation New Project

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

Using `SwiftOpenAI` is simple and straightforward. Follow these steps to start interacting with OpenAI's API in your Swift project:

1. `Import SwiftOpenAI`
2. `var openAI = SwiftOpenAI(apiKey: "YOUR-API-KEY")`

## Secure your API Key using a .plist

To use SwiftOpenAI safely without hardcoding your API key, follow these steps:

- Create a .plist file: Add a new .plist file to your project, e.g., Config.plist.
- Add your API Key: Inside Config.plist, add a new row with the Key OpenAI_API_Key and paste your API key in the Value field.
- Load the API Key: Use the following code to load your API key from the .plist:

```swift
import Foundation
import SwiftOpenAI

// Define a struct to handle configuration settings.
struct Config {
    // Static variable to access the OpenAI API key.
    static var openAIKey: String {
        get {
            // Attempt to find the path of 'Config.plist' in the main bundle.
            guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
                // If the file is not found, crash with an error message.
                fatalError("Couldn't find file 'Config.plist'.")
            }
            
            // Load the contents of the plist file into an NSDictionary.
            let plist = NSDictionary(contentsOfFile: filePath)
            
            // Attempt to retrieve the value for the 'OpenAI_API_Key' from the plist.
            guard let value = plist?.object(forKey: "OpenAI_API_Key") as? String else {
                // If the key is not found in the plist, crash with an error message.
                fatalError("Couldn't find key 'OpenAI_API_Key' in 'Config.plist'.")
            }
            
            // Return the API key.
            return value
        }
    }
}

// Initialize an instance of SwiftOpenAI with the API key retrieved from Config.
var openAI = SwiftOpenAI(apiKey: Config.openAIKey)
```

## [Images](https://platform.openai.com/docs/api-reference/images)
### [Create Image](https://platform.openai.com/docs/api-reference/images/create)
Given a prompt and/or an input image, the model will generate a new image using DALL·E 3.

```swift
do {
    // Attempt to create an image using the OpenAI's DALL-E 3 model.
    let image = try await openAI.createImages(
        model: .dalle(.dalle3), // Specify the DALL-E 3 model.
        prompt: prompt, // Use the provided prompt to guide image generation.
        numberOfImages: 1, // Request a single image.
        size: .s1024 // Specify the size of the generated image.
    )
    
    // Print the resulting image.
    print(image)
} catch {
    // Handle any errors that occur during image creation.
    print("Error: \(error)")
}
```

## [Audio](https://platform.openai.com/docs/api-reference/audio)
### [Create Speech](https://platform.openai.com/docs/api-reference/audio/createSpeech)
Generates audio from the input text. You can specify the voice and responseFormat

```swift
do {
    // Define the input text that will be converted to speech.
    let input = "Hello, I'm SwiftBeta, a developer who in his free time tries to teach through his blog swiftbeta.com and his YouTube channel. Now I'm adding the OpenAI API to transform this text into audio"
    
    // Generate audio from the input text using OpenAI's text-to-speech API.
    let data = try await openAI.createSpeech(
        model: .tts(.tts1), // Specify the text-to-speech model, here tts1.
        input: input, // Provide the input text.
        voice: .alloy, // Choose the voice type, here 'alloy'.
        responseFormat: .mp3, // Set the audio response format as MP3.
        speed: 1.0 // Set the speed of the speech. 1.0 is normal speed.
    )
    
    // Retrieve the file path in the document directory to save the audio file.
    if let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("speech.mp3") {
        do {
            // Save the generated audio data to the specified file path.
            try data.write(to: filePath)
            // Confirm saving of the audio file with a print statement.
            print("Audio file saved: \(filePath)")
        } catch {
            // Handle any errors encountered while writing the audio file.
            print("Error saving Audio file: \(error)")
        }
    }
} catch {
    // Handle any errors encountered during the audio creation process.
    print(error.localizedDescription)
}
```

### [Create Transcription](https://platform.openai.com/docs/api-reference/audio/createTranscription)
Transcribes audio into the input language.

```swift
// Placeholder for the data from your video or audio file.
let fileData = // Data from your video, audio, etc.

// Specify the transcription model to be used, here 'whisper'.
let model: OpenAITranscriptionModelType = .whisper

do {
    // Attempt to transcribe the audio using OpenAI's transcription service.
    for try await newMessage in try await openAI.createTranscription(
        model: model, // The specified transcription model.
        file: fileData, // The audio data to be transcribed.
        language: "en", // Set the language of the transcription to English.
        prompt: "", // An optional prompt for guiding the transcription, if needed.
        responseFormat: .mp3, // The format of the response. Note: Typically, transcription responses are in text format.
        temperature: 1.0 // The creativity level of the transcription. A value of 1.0 promotes more creative interpretations.
    ) {
        // Print each new transcribed message as it's received.
        print("Received Transcription \(newMessage)")
        
        // Update the UI on the main thread after receiving transcription.
        await MainActor.run {
            isLoading = false // Update loading state.
            transcription = newMessage.text // Update the transcription text.
        }
    }
} catch {
    // Handle any errors that occur during the transcription process.
    print(error.localizedDescription)
}
```

## [Chats](https://platform.openai.com/docs/api-reference/chat)
### [Create Chat with Stream](https://platform.openai.com/docs/api-reference/chat/create)
Given a chat conversation, the model will return a chat completion response.

```swift
// Define an array of MessageChatGPT objects representing the conversation.
let messages: [MessageChatGPT] = [
  // A system message to set the context or role of the assistant.
  MessageChatGPT(text: "You are a helpful assistant.", role: .system),
  // A user message asking a question.
  MessageChatGPT(text: "Who won the world series in 2020?", role: .user)
]

// Define optional parameters for the chat completion request.
let optionalParameters = ChatCompletionsOptionalParameters(
    temperature: 0.7, // Set the creativity level of the response.
    stream: true, // Enable streaming to get responses as they are generated.
    maxTokens: 50 // Limit the maximum number of tokens (words) in the response.
)

do {
    // Create a chat completion stream using the OpenAI API.
    let stream = try await openAI.createChatCompletionsStream(
        model: .gpt4(.base), // Specify the model, here GPT-4 base model.
        messages: messages, // Provide the conversation messages.
        optionalParameters: optionalParameters // Include the optional parameters.
    )
    
    // Iterate over each response received in the stream.
    for try await response in stream {
        // Print each response as it's received.
        print(response)
    }
} catch {
    // Handle any errors encountered during the chat completion process.
    print("Error: \(error)")
}
```

### [Create Chat without Stream](https://platform.openai.com/docs/api-reference/chat/create)
Given a chat conversation, the model will return a chat completion response.

```swift
// Define an array of MessageChatGPT objects representing the conversation.
let messages: [MessageChatGPT] = [
    // A system message to set the context or role of the assistant.
    MessageChatGPT(text: "You are a helpful assistant.", role: .system),
    // A user message asking a question.
    MessageChatGPT(text: "Who won the world series in 2020?", role: .user)
]

// Define optional parameters for the chat completion request.
let optionalParameters = ChatCompletionsOptionalParameters(
    temperature: 0.7, // Set the creativity level of the response.
    maxTokens: 50 // Limit the maximum number of tokens (words) in the response.
)

do {
    // Request chat completions from the OpenAI API.
    let chatCompletions = try await openAI.createChatCompletions(
        model: .gpt4(.base), // Specify the model, here GPT-4 base model.
        messages: messages, // Provide the conversation messages.
        optionalParameters: optionalParameters // Include the optional parameters.
    )

    // Print the received chat completions.
    print(chatCompletions)
} catch {
    // Handle any errors encountered during the chat completion process.
    print("Error: \(error)")
}
```

### [Create Chat with Image Input](https://platform.openai.com/docs/api-reference/chat/create)
Given a chat conversation with a image input, the model will return a chat completion response.

```swift
// Define a text message to be used in conjunction with an image.
let message = "What appears in the photo?"

// URL of the image to be analyzed.
let imageVisionURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/M31bobo.jpg/640px-M31bobo.jpg"

do {
    // Create a message object for chat completion with image input.
    let myMessage = MessageChatImageInput(
        text: message, // The text part of the message.
        imageURL: imageVisionURL, // URL of the image to be included in the chat.
        role: .user // The role assigned to the message, here 'user'.
    )
    
    // Define optional parameters for the chat completion request.
    let optionalParameters: ChatCompletionsOptionalParameters = .init(
        temperature: 0.5, // Set the creativity level of the response.
        stop: ["stopstring"], // Define a stop string for the model to end responses.
        stream: false, // Disable streaming to get complete responses at once.
        maxTokens: 1200 // Limit the maximum number of tokens (words) in the response.
    )
    
    // Request chat completions from the OpenAI API with image input.
    let result = try await openAI.createChatCompletionsWithImageInput(
        model: .gpt4(.gpt_4_vision_preview), // Specify the model, here GPT-4 vision preview.
        messages: [myMessage], // Provide the message with image input.
        optionalParameters: optionalParameters // Include the optional parameters.
    )
    
    // Print the result of the chat completion.
    print("Result \(result?.choices.first?.message)")
    
    // Update the message with the content of the first response, if available.
    self.message = result?.choices.first?.message.content ?? "No value"
    
    // Update the loading state to false as the process completes.
    self.isLoading = false
    
} catch {
    // Handle any errors encountered during the chat completion process.
    print("Error: \(error)")
}
```

## [Models](https://platform.openai.com/docs/api-reference/models)
### [List Models]([https://platform.openai.com/docs/api-reference/models](https://platform.openai.com/docs/api-reference/models/list))
List and describe the various models available in the API. You can refer to the Models documentation to understand what models are available and the differences between them.

```swift
do {
    // Request a list of models available in the OpenAI API.
    let modelList = try await openAI.listModels()

    // Print the list of models received from the API.
    print(modelList)
} catch {
    // Handle any errors that occur during the request.
    print("Error: \(error)")
}
```

## [Embeddings](https://platform.openai.com/docs/api-reference/embeddings)
Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.

```swift
// Define the input text for which embeddings will be generated.
let inputText = "Embeddings are a numerical representation of text."

do {
    // Attempt to generate embeddings using OpenAI's API.
    let embeddings = try await openAI.embeddings(
        model: .embedding(.text_embedding_ada_002), // Specify the embedding model, here 'text_embedding_ada_002'.
        input: inputText // Provide the input text for which embeddings are needed.
    )
    
    // Print the embeddings generated from the input text.
    print(embeddings)
} catch {
    // Handle any errors that occur during the embeddings generation process.
    print("Error: \(error)")
}
```

## [Moderations](https://platform.openai.com/docs/api-reference/embeddings)
Given a input text, outputs if the model classifies it as violating OpenAI's content policy.

```swift
// Define the text input to be checked for potentially harmful or explicit content.
let inputText = "Some potentially harmful or explicit content."

do {
    // Request moderation on the input text using OpenAI's API.
    let moderationResults = try await openAI.moderations(
        input: inputText // Provide the text input for moderation.
    )
    
    // Print the results of the moderation.
    print(moderationResults)
} catch {
    // Handle any errors that occur during the moderation process.
    print("Error: \(error)")
}
```

## [Completions](https://platform.openai.com/docs/api-reference/completions)
Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.

```swift
// Define a prompt for generating text completions.
let prompt = "Once upon a time, in a land far, far away,"

// Set optional parameters for the completion request.
let optionalParameters = CompletionsOptionalParameters(
    prompt: prompt, // The initial text prompt to guide the model.
    maxTokens: 50, // Limit the maximum number of tokens (words) in the completion.
    temperature: 0.7, // Set the creativity level of the response.
    n: 1 // Number of completions to generate.
)

do {
    // Request text completions from OpenAI using the GPT-3.5 model.
    let completions = try await openAI.completions(
        model: .gpt3_5(.turbo), // Specify the model, here GPT-3.5 turbo.
        optionalParameters: optionalParameters // Include the optional parameters.
    )
    
    // Print the generated completions.
    print(completions)
} catch {
    // Handle any errors encountered during the completion generation process.
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


