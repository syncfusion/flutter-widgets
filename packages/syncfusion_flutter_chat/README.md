![Syncfusion Flutter Chat banner](https://cdn.syncfusion.com/content/images/Flutter/chat/chat_pub_banner.png)

# Flutter Chat library

The [Flutter Chat](https://www.syncfusion.com/flutter-widgets/flutter-Chat?utm_source=pubdev&utm_medium=listing&utm_campaign=flutter-Chat-pubdev) package is a UI library designed to help you create a robust chat application within your Flutter projects.

## Overview
* Offers a modern conversation UI to facilitate communication among users.
* Displays both one-on-one and group conversations.
* Provides a wide range of customization options for message content, headers, footers, avatars, editors, and action buttons.

**Disclaimer:** This is a commercial package. To use this package, you need to have either a Syncfusion commercial license or Free [Syncfusion Community license](https://www.syncfusion.com/products/communitylicense). For more details, please check the [LICENSE](https://github.com/syncfusion/flutter-examples/blob/master/LICENSE).

## Table of content:
- [Chat Features](#chat-features)
- [Get the demo application](#get-the-demo-application)
- [Useful links](#other-useful-links)
- [Installation](#installation)
- [Flutter Chat example](#flutter-chat-example)
- [Support and feedback](#support-and-feedback)
- [About Syncfusion](#about-syncfusion)

## Chat Features:

**Placeholder:** Define a custom widget to show when there are no messages in the chat. This feature is especially beneficial for providing users with an engaging or pertinent message that signifies the conversation is currently empty.

**Composer:** This is the primary text editor where users can compose new chat messages. There is an option to define a custom widget to serve as a composer, allowing one or more widgets to provide multiple options for composing a message.

**Action button:** This is used for the Send button. Pressing this action button invokes the callback, where the outgoing user rebuilds the chat widget with their composed message. There is an option to define a custom widget consisting of one or more interactive widgets to serve as action buttons, such as a send button, microphone button, or file attachment button.

**Conversation:** This displays the content of incoming and outgoing messages. Each message includes details such as the message text, time stamp, and author. There is an option available to individually customize incoming and outgoing messages, providing a distinct appearance for each message type.

- **Incoming:** The content of incoming messages can be customize. Change the background color, content shape, and other features according to the message user or specific conditions.

- **Outgoing:** The content of outgoing messages can be customized. Change the background color, content shape, and other features according to the message user or specific conditions.

- **Header:** The header displays the username of the message's author along with the time stamp. Additionally, users can build a custom widget to display more information about the chat message.

- **Footer:** Define a custom widget to display additional information about the chat message, such as the time stamp or message delivery status.

- **Avatar:** The author's avatar displays either an image or the initials of their name. By default, if the avatar image source is not defined, the user's initials will be displayed. Additionally, users can create a custom widget that shows more information about them.

- **Content:** Users can customize the message content's background color, content shape, and other features based on the user or other specific conditions. By default, the text content is shown as not selectable, but there is an option to display the message content using a custom widget.

## Get the demo application

Explore the full capabilities of our Flutter widgets on your device by installing our sample browser applications from the below app stores, and view samples code in GitHub.

<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.syncfusion.flutter.examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/google-play-store.png"/></a>
  <a href="https://flutter.syncfusion.com"><img src="https://cdn.syncfusion.com/content/images/FTControl/web-sample-browser.png"/></a>
  <a href="https://www.microsoft.com/en-us/p/syncfusion-flutter-gallery/9nhnbwcsf85d?activetab=pivot:overviewtab"><img src="https://cdn.syncfusion.com/content/images/FTControl/windows-store.png"/></a> 
</p>
<p align="center">
  <a href="https://install.appcenter.ms/orgs/syncfusion-demos/apps/syncfusion-flutter-gallery/distribution_groups/release"><img src="https://cdn.syncfusion.com/content/images/FTControl/macos-app-center.png"/></a>
  <a href="https://snapcraft.io/syncfusion-flutter-gallery"><img src="https://cdn.syncfusion.com/content/images/FTControl/snap-store.png"/></a>
  <a href="https://github.com/syncfusion/flutter-examples"><img src="https://cdn.syncfusion.com/content/images/FTControl/github-samples.png"/></a>
</p>

## Other useful links

Take a look at the following to learn more about the Syncfusion Flutter Chat.

* [Syncfusion Flutter Chat product page](https://www.syncfusion.com/flutter-widgets/flutter-chat)
* [User guide documentation for Chat](https://help.syncfusion.com/flutter/chat)
* [Knowledge base](https://www.syncfusion.com/kb)

## Installation

Add the [latest version](https://pub.dev/packages/syncfusion_flutter_chat/install) of [Syncfusion Flutter Chat](https://pub.dev/packages/syncfusion_flutter_chat) widget to your `pubspec.yaml` file..

## Flutter Chat example 

Import Chat library using the code provided below.

```dart
import 'package:syncfusion_flutter_chat/chat.dart';
```
### Add Chat widget

Initialize the Chat widget as a child of any widget.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SfChat(),
  );
}
```

### Bind data source

To bind the message conversations to the `Chat` widget, the predefined data model class `ChatMessage` is used. This class contains three essential properties: `text`, `time`, and `author`, which are required for rendering a chat message. The following code snippet illustrates how to assign data to the `Chat` widget.

```dart
late List<ChatMessage> _messages;

@override
void initState() {
  _messages = <ChatMessage>[
    ChatMessage(
      text: 'Hello, how can I help you today?',
      time: DateTime.now(),
      author: const ChatAuthor(
        id: 'a2c4-56h8-9x01-2a3d',
        name: 'Incoming user name',
      ),
    ),
  ];
  super.initState();
}

@override
Widget build(BuildContext context) {
  return SfChat(
    messages: _messages,
    outgoingUser: '8ob3-b720-g9s6-25s8',
    composer: const ChatComposer(
      decoration: InputDecoration(
        hintText: 'Type a message',
      ),
    ),
    actionButton: ChatActionButton(
      onPressed: (String newMessage) {
        setState(() {
          _messages.add(ChatMessage(
            text: newMessage,
            time: DateTime.now(),
            author: const ChatAuthor(
              id: '8ob3-b720-g9s6-25s8',
              name: 'Outgoing user name',
            ),
          ));
        });
      },
    ),
  );
}

@override
void dispose() {
  _messages.clear();
  super.dispose();
}
```

The following output illustrates the result of the above code sample.

![Default Chat demo](https://cdn.syncfusion.com/content/images/Flutter/chat/chat_pub_getting_started_demo.gif)

## Support and feedback

* For questions, reach out to our [Syncfusion support team](https://support.syncfusion.com/support/tickets/create) or post them through the [Community forums](https://www.syncfusion.com/forums). Submit a feature request or a bug in our [Feedback portal](https://www.syncfusion.com/feedback/flutter).
* To renew your subscription, click [renew](https://www.syncfusion.com/sales/products) or contact our sales team at sales@syncfusion.com | Toll Free: 1-888-9 DOTNET.

## About Syncfusion

Founded in 2001 and headquartered in Research Triangle Park, N.C., Syncfusion has more than 20,000 customers and more than 1 million users, including large financial institutions, Fortune 500 companies, and global IT consultancies.

Today we provide 1,000+ controls and frameworks for web ([ASP.NET Core](https://www.syncfusion.com/aspnet-core-ui-controls), [ASP.NET MVC](https://www.syncfusion.com/aspnet-mvc-ui-controls), [ASP.NET WebForms](https://www.syncfusion.com/jquery/aspnet-web-forms-ui-controls), [JavaScript](https://www.syncfusion.com/javascript-ui-controls), [Angular](https://www.syncfusion.com/angular-ui-components), [React](https://www.syncfusion.com/react-ui-components), [Vue](https://www.syncfusion.com/vue-ui-components), [Flutter](https://www.syncfusion.com/flutter-widgets), and [Blazor](https://www.syncfusion.com/blazor-components)), mobile ([Xamarin](https://www.syncfusion.com/xamarin-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), [Flutter](https://www.syncfusion.com/flutter-widgets), [UWP](https://www.syncfusion.com/uwp-ui-controls), and [JavaScript](https://www.syncfusion.com/javascript-ui-controls)), and desktop development ([Flutter](https://www.syncfusion.com/flutter-widgets), [WinForms](https://www.syncfusion.com/winforms-ui-controls), [WPF](https://www.syncfusion.com/wpf-ui-controls), [UWP](https://www.syncfusion.com/uwp-ui-controls), [.NET MAUI](https://www.syncfusion.com/maui-controls), and [WinUI](https://www.syncfusion.com/winui-controls)). We provide ready-to-deploy enterprise software for dashboards, reports, data integration, and big data processing. Many customers have saved millions in licensing fees by deploying our software.