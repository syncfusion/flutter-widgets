## Unreleased

**General**

*  The compatible version of our Flutter chat and AI assistView widget has been updated to Flutter SDK 3.29.0.
*  The Syncfusion<sup>&reg;</sup> Flutter chat and AI assistView example sample have been updated to support [kotlin build scripts](https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply) in Android platform.
*  The Syncfusion<sup>&reg;</sup> Flutter chat and AI assistView example sample have been updated to support [Swift package manager](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers) in macOS and iOS platforms.

## Chat

### Breaking Changes

Following breaking changes will occur in Chat.

## SfChat:

- The `bubbleHeaderBuilder` property has been renamed to `messageHeaderBuilder`.
- The `bubbleAvatarBuilder` property has been renamed to `messageAvatarBuilder`.
- The `bubbleContentBuilder` property has been renamed to `messageContentBuilder`.
- The `bubbleFooterBuilder` property has been renamed to `messageFooterBuilder`.
- The `incomingBubbleSettings` property has been renamed to `incomingMessageSettings`.
- The `outgoingBubbleSettings` property has been renamed to `outgoingMessageSettings`.
- The `ChatBubbleSettings` class has been renamed to `ChatMessageSettings`.

## ChatComposer:

- The `padding` property has been renamed to `margin`.

## ChatComposer.builder():

- The `padding` property has been renamed to `margin`.

## ChatActionButton:

- The `padding` property has been renamed to `margin`.

## ChatMessageSettings:

- The `showUserName` property has been renamed to `showAuthorName`.
- The `showUserAvatar` property has been renamed to `showAuthorAvatar`.
- The `contentBackgroundColor` property has been renamed to `backgroundColor`.
- The `contentShape` property has been renamed to `shape`.
- The `padding` property has been renamed to `margin`.
- The `contentPadding` property has been renamed to `padding`.

## AssistView

### Breaking Changes

Following breaking changes will occur in AIAssistView.

## SfAIAssistView:

- The `bubbleHeaderBuilder` property has been renamed to `messageHeaderBuilder`.
- The `bubbleAvatarBuilder` property has been renamed to `messageAvatarBuilder`.
- The `bubbleContentBuilder` property has been renamed to `messageContentBuilder`.
- The `bubbleFooterBuilder` property has been renamed to `messageFooterBuilder`.
- The `bubbleAlignment` property has been renamed to `messageAlignment`.
- The `AssistBubbleAlignment` enum has been renamed to `AssistMessageAlignment`.
- The `responseBubbleSettings` property has been renamed to `responseMessageSettings`.
- The `requestBubbleSettings` property has been renamed to `requestMessageSettings`.
- The `onBubbleToolbarItemSelected` property has been renamed to `onToolbarItemSelected`.
- The `AssistBubbleToolbarItemSelectedCallback` typedef has been renamed to `AssistToolbarItemSelectedCallback`.
- The `AssistBubbleSettings` class has been renamed to `AssistMessageSettings`.

## AssistMessageSettings:

- The `showUserName` property has been renamed to `showAuthorName`.
- The `showUserAvatar` property has been renamed to `showAuthorAvatar`.
- The `contentBackgroundColor` property has been renamed to `backgroundColor`.
- The `contentShape` property has been renamed to `shape`.
- The `padding` property has been renamed to `margin`.
- The `contentPadding` property has been renamed to `padding`.

## AssistSuggestionSettings:

- The `padding` property has been renamed to `margin`.

## AssistComposer:

- The `padding` property has been renamed to `margin`.

## AssistComposer.builder():

- The `padding` property has been renamed to `margin`.

## AssistActionButton:

- The `padding` property has been renamed to `margin`.

## AssistMessageToolbarSettings:

- The `padding` property has been renamed to `margin`.

## Core

### Breaking Changes

Following breaking changes will occur in core.

## SfChatThemeData:

- The `outgoingBubbleContentBackgroundColor` property has been renamed to `outgoingMessageBackgroundColor`.
- The `incomingBubbleContentBackgroundColor` property has been renamed to `incomingMessageBackgroundColor`.
- The `outgoingBubbleContentShape` property has been renamed to `outgoingMessageShape`.
- The `incomingBubbleContentShape` property has been renamed to `incomingMessageShape`.

## SfAIAssistViewThemeData:

- The `requestBubbleContentBackgroundColor` property has been renamed to `requestMessageBackgroundColor`.
- The `responseBubbleContentBackgroundColor` property has been renamed to `responseMessageBackgroundColor`.
- The `requestBubbleContentShape` property has been renamed to `requestMessageShape`.
- The `responseBubbleContentShape` property has been renamed to `responseMessageShape`.

## [28.2.7] - 25/02/2025

**General**

* The minimum Dart version of our Flutter widgets has been updated to 3.4 from 3.3.

## [28.1.36] - 12/24/2024

**General**

* The compatible version of our Flutter chat and AI assistView widgets has been updated to Flutter SDK 3.27.0.

## [28.1.33] - 12/12/2024

### General

* All of our Syncfusion<sup>&reg;</sup> Flutter widgets have been updated to support [`WebAssembly`](https://docs.flutter.dev/platform-integration/web/wasm) (WASM) as a compilation target for building web applications.
* The minimum Dart version of our Flutter widgets has been updated to 3.3 from 2.17.

### AI AssistView (Preview)

Initial release.

**Features**
1. Request and response message.
2. Composer - The primary text editor where the user can compose request messages.
3. Action button - This represents the send button, which invokes a callback with the text entered in the default composer, where the user can request their preferred AI to respond to their request.
4. Placeholder - This allows you to specify a custom widget to display when there are no messages in the chat or in the header of all messages.
5. Bubble - This holds each message's header, content, footer, and avatar.
6. Suggestions - This allows you to specify a list of suggestions for the response message that can align with the request message.
7. Loading indicator - This indicates the loading status of the AI response.

### Chat (Preview)

**Features**

* Added suggestion support to chat messages. 

## [27.1.51] - 30/09/2024

**General**

* Added a description to the library.
* API documentation link has been redirected to https://pub.dev/documentation/syncfusion_flutter_chat/latest/chat/chat-library.html from
https://pub.dev/documentation/syncfusion_flutter_chat/latest/syncfusion_flutter_chat/syncfusion_flutter_chat-library.html

## [27.1.48-beta] - 09/24/2024

Initial release.

**Features** 
1. Messages - A list of ChatMessage objects that will be displayed in the chat interface as either incoming or outgoing messages, depending on the current user.
2. Composer - The primary text editor where the user can compose new chat messages.
3. Action button - This represents the send button, which invokes a callback with the text entered in the default composer.
4. Placeholder - This allows you to specify a custom widget to display when there are no messages in the chat.
5. Bubble - This holds each message's header, content, footer, and avatar.
