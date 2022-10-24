# Getting started with the AircoreMediaPanel

The AircoreMediaPanel SDK provides an extremely customizable widget that you can embed within your existing apps and enables you to add high-quality, real-time voice
chat to your iOS app quickly and easily, without the need to understand the
complexities of building a real-time system on your own. It is powered by the [AirtimeMedia SDK](https://github.com/airtimemedia/AirtimeMedia-iOS "AirtimeMedia SDK") under the hood and utilizes our advanced media optimization and adaptation framework and our world-wide media distribution system to provide your users with high-quality, low-latency multi-party voice chat features for groups of up to 24 participants.
The MediaPanel widget is extremely customizable to your existing branding and visual language.

### Installation

The preferred way of installing AircoreMediaPanel is using SPM via Xcode

From Xcode :
1. Create a new or open an existing iOS project (insert Xcode min/iOS deployment min version here)
2. Go to File > Swift Packages > Add Package Dependency
3.  In the "Search or Enter Package URL" box, paste the URL of the AircoreMediaPanel SDK ( https://github.com/aircoreio/aircore-media-panel-ios) and tap "Add Package"
4. Once Xcode fetches your package you may see a dialog "Choose Package Products for AircoreMediaPanel". Select AircoreMediaPanel from the list and tap "Add Packages"
5. If you encounter any issues with building after adding the package,
Go to File > Swift Packages > Reset Package Caches


### API Keys

To start using the MediaPanel you will need to create an app in the [Developer Console](https://developer.aircore.io "Developer Console") and choose between one of the two different API Keys provided to you.
To learn more about the two different API Keys so that you can choose the right one based on your needs, please refer to [Apps and API Keys](https://docs.aircore.io/key-concepts#apps-and-api-keys "Apps and API Keys")

### Client initialization

The Client object is the primary controller which powers the MediaPanel. Besides authentication and initializing the low level AircoreMedia SDK under the hood, it allows you to configure user metadata that the MediaPanel relies upon, control logging, and provides methods to connect/disconnect to listen to important events that happen behind the scenes that your app might be interested to plug into.
The Client allows your app to bring your existing user/channel models and seamlessly integrate them into the Media Panel.


#### Client initialization with Publishable API Key  

```swift
import AircoreMediaPanel

// Use a Publishable API Key directly from the developer console
let client = Client.create(publishableKey: key, userID: userID)
```

#### Client initialization with Secret API Key/Session Auth token

```swift
import AircoreMediaPanel

// Use a session auth token provided by your server by communication with the Aircore's provisioning service using the Secret API key
let client = Client.create(authToken: authToken, userID: userID)
```

Once you create a Client object, you can set up properties for the user that will be used to represent the user on the MediaPanel.

```swift
client.userDisplayName = "Jane Doe"
client.userAvatarURL =  "http://user-profile-picture.png"
```

### Configuration

To configure the MediaPanel and modify the behavior of the panel itself or change the defaults for the various elements that makeup the panel, create a MediaPanelConfiguration object.

```swift
let config = MediaPanelConfiguration(
    panelTitle: "My Channel",
    panelSubtitle: "My Channel is a happy space where people can have fun",
    ...
)
```

You can configure the text used in every element of the panel by setting the appropriate property.

```swift
let stringsConfig = MediaPanelConfiguration.Strings(
    joinButton: "Join",
    joiningButton: "Joining...",
    joinButtonTooltip: "Tap Join to start the audio session",
    leaveButton: "Leave",
    retryButton: "Retry",
    emptyCallTitle: "No one is on the call yet.",
    emptyCallSubtitle: "Tap Join below to be the first!",
    channelIsFullLabel: "The channel is full",
    genericErrorLabel: "Something went wrong..."
)
        
let config = MediaPanelConfiguration(
    ...
    strings: stringsConfig
    ...
)
```

#### Collapsed and Expanded State options

You can further customize the expanded and collapsed state independently.

```swift
let config = MediaPanelConfiguration(
    ...
    collapsedStateOptions: MediaPanelConfiguration.CollapsedStateOptions(
        maxAvatars: 3,
        panelTitle: "Collpased Title",
        panelSubtitle: "Collpased Sub-title",
        joinButton: "Collapsed Join"
       ...
    ),
    expandedStateOptions: MediaPanelConfiguration.ExpandedStateOptions(
        panelTitle:"Expanded Title",
        panelSubtitle: "Expanded Sub-title",
        joinButton: "Expanded Join"
        ...
    )
    ...
)
```

#### Examples:

![Collapsed State](https://docs.aircore.io/ios/mediapanel/assets/collapsed-state.png "Collapsed State") ![Expanded State](https://docs.aircore.io/ios/mediapanel/assets/expanded-state.png "Expanded State")  
For the complete configuration options, refer to our [configuration docs](https://docs.aircore.io/ios/mediapanel/1.0.0/documentation/aircoremediapanel/mediapanelconfiguration)

### Theming

The Theme object is optional to create a MediaPanel, but if you want to create your own Theme that conforms to your existing apps you could provide one during the MediaPanel creation.
The theme provides extensive customization to most of the elements visible on the panel. A theme object can also be reused as necessary with other instances of the MediaPanel.

```swift
let myTheme = Theme(
    backgroundColor: UIColor.yellow,
    primaryColor: .blue,
    dangerColor: UIColor.red,
    borderRadius: 24,
    borderWidth: 2,
    borderColor: .green,
    fontFamily: UIFont(name: "Helvetica", size: 14)!,
    textColor: .red,
    subtextColor: UIColor.green,
    primaryContrastColor: .darkGray,
    dangerContrastColor: UIColor.purple,
    avatar: Theme.Avatar(
        background: .cyan,
        borderShape: Theme.BorderShape.circle(),
        spacing: 10
    )
)
```

#### Examples:

![Example 1](https://docs.aircore.io/ios/mediapanel/assets/theme1.png "Example 1") ![Example 1](https://docs.aircore.io/ios/mediapanel/assets/theme2.png "Example 2")  

For the complete theming options, refer to our [theming docs](https://docs.aircore.io/ios/mediapanel/1.0.0/documentation/aircoremediapanel/theme)

### Media Panel

Finally, we're ready to put all this together to create the MediaPanel and set it up with your existing ViewController!

```swift
client.connect(channelID: channel)

let panel = MediaPanel(
    client: client,
    channelID: channel,
    configuration: configuration,
    theme: myTheme //Optional
)

panel.present(in: self, style: .bottomBar)
```

### Notifications and Errors

You can subscribe to useful events that may be relevant to your app's business logic, receive errors etc. and respond accordingly:

```swift
client.on(.localUserJoined) { channelID, userID in
    print("I just joined a call!")
}

client.on(.sessionAuthTokenNearingExpiry) { channelID, userID in
    // Fetch a new auth token from your server and update the client!
}

client.on(.sessionAuthTokenInvalid) { channelID, userID in
    // Request the server for a new token
}

client.onError { channelID, error in
    // Handle any errors
}
```

For the complete events reference, refer to our [events docs](https://docs.aircore.io/ios/mediapanel/1.0.0/documentation/aircoremediapanel/clientevents)


### Teardown and cleanup

When you are done with the panel, you can tear-down the client and the panel as follows:

```swift
// Disconnecting a specific Channel ID
client.disconnect(fromChannelID: channel)

// Tear down of the client (it will disconnect automatically from all connected channels)
client.destroy()
```

Once you invoke destroy you won't be able to reuse the client with any new panels and will have to create a new instance of the client.  

### Reference documentation

The complete API Reference documentation can be found on [docs.aircore.io](https://docs.aircore.io/ios/mediapanel/api-reference/)

### Sample apps

1. A SwiftUI example integration can be found [here](https://github.com/aircoreio/aircore-media-panel-ios-samples/tree/main/MediaPanel-SwiftUI)
2. An UIKit/Swift example integration can be found [here](https://github.com/aircoreio/aircore-media-panel-ios-samples/tree/main/MediaPanel-UIKit-Swift)
3. An UIKit/ObjC example integration can be found [here](https://github.com/aircoreio/aircore-media-panel-ios-samples/tree/main/MediaPanel-UIKit-ObjC)

### Minimum versions

- Xcode - 13.3
- iOS - 13.0

### Limitations

- The simulator is not supported on macOS systems with Apple Silicon.
- Bitcode must be **disabled**.

### Miscellaneous

- Since the MediaPanel requires microphone permissions to function, iOS requires  developers using the microphone permission to set the [**NSMicrophoneUsageDescription** ](https://developer.apple.com/documentation/bundleresources/information_property_list/nsmicrophoneusagedescription "**NSMicrophoneUsageDescription** ")
