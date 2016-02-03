# Referrals for iOS
The best product is the one that sells itself. With referrals, you allow your users to invite others. With Shortcut you can create a seamless user flow to make your on-boarding experience as frictionless as possible.

##Requirements

The SDK works with any device running iOS6 and newer. The `NSURLComponents` class for URL parsing is only available on iOS9+ and has to be replaced by manual parsing or another library when supporting previous versions of iOS.

In order to make referrals work, you need to add our [Deep Linking SDK for iOS](https://developer.shortcut.sc/ios_sdk) to your app. This requires [custom URL-schemes] (https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/Inter-AppCommunication/Inter-AppCommunication.html) for deep links.

##How it works

Your existing user Johnny Appleseed with the user name `j_appleseed` wants to invite his friend John Doe to use your app. He clicks a button within your app which triggers the creation of a Shortcut. A custom share sheet or activity [view controller] (https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/ContentViews.html) is then displayed to allow Johnny to send the Shortcut to his friend. When the friend clicks the Shortcut he is taken to the App Store and when he opens the app, he is greeted by a customized welcome message from Johnny Appleseed containing e.g. a special offer or bonus points.

##Implementation

In this example, we define the referral parameter `referral_from` to identify the inviting user with the user name.

Add a button to your UI and wire it to an action in a view controller (this example assumes `shareButtonPressed`). Implement the action in the following way:


```objective-c
- (IBAction)shareButtonPressed:(id)button {

    NSString *title    = @"Invite from Johnny Appleseed";
    NSURL *websiteURL  = [NSURL URLWithString:@"http://your.site/invitation?referral_from=j_appleseed"];

    NSURL *deepLinkURL = [NSURL URLWithString:@"your-app://invitation?referral_from=j_appleseed"];

    SCDeepLinking *dl = [SCDeepLinking sharedInstance];
    [dl createShortLinkWithTitle:title
                      websiteURL:websiteURL
                     deepLinkURL:deepLinkURL
               completionHandler:^(NSURL *shortLinkURL, NSError *error) {

        if (!error) {
            [self displayShareSheetWithURL:shortLinkURL];
        } else {
            // do error handling...
        }
    }];
}

- (void)displayShareSheetWithURL:(NSURL *)urlToShare {
    // ...
}
```

When the invited user eventually installs and launches the app, the Shortcut Deep Linking SDK triggers your app delegate's `-application:openURL:sourceApplication:annotation:` method. Implement it the following way:

```objective-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    SCSession *deepLinkSession = [[SCDeepLinking sharedInstance] startSessionWithURL:url];

    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:deepLinkSession.url
                                                resolvingAgainstBaseURL:NO];
    if ([urlComponents.path isEqualToString:@"/invitation"]) {
        for (NSURLQueryItem *item in urlComponents.queryItems) {
            if ([item.name isEqualToString:@"referral_from"]) {
                [self displayWelcomeWindowWithReferrer:item.value];
                return YES;
            }
        }
    }

    return NO;
}

- (void)displayWelcomeWindowWithReferrer:(NSString *)referrerName {
    NSLog(@"You have been invited by %@", referrerName);
    // Display a customized welcome message here
}

```

##Extensions
You can also send coupon codes and more parameters with the Shortcut to create more sophisticated solutions. For this, you can define parameters such as `referral_code` or `referral_validity` and add them to your URL.

If you need more information or support on integrating referrals, please [contact us](mailto:support@shortcutmedia.com). We are happy to help!