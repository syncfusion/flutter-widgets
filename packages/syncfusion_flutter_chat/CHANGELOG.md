## [28.1.29] - 12/12/2024

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
