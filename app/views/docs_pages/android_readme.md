# Shortcut SDK for Android

This SDK provides the following features:

- Collection of statistics (app usage, deep links).
- Support for [deferred deep linking](https://en.wikipedia.org/wiki/Deferred_deep_linking).
- Shortcut creation (short mobile deep links) to share from within your app.

There is also an [iOS version](https://github.com/shortcutmedia/shortcut-deeplink-sdk-ios) of this SDK.

## Requirements

The SDK works with Android API 10+.

## Installation

1. Download the latest .AAR file from the [releases page](https://github.com/shortcutmedia/shortcut-android-sdk/releases) and copy it to the project's libs directory (_typically `app/libs`_). 
2. Add a directory repository in `build.gradle` and add `compile 'sc.shortcut.sdk:shortcut-sdk:0.1.0@aar'` to the dependencies section of your application's `build.gradle` file.

```gradle
repositories {
  flatDir {
    dirs 'libs'
  }
}
```

```gradle
dependencies {
    compile 'sc.shortcut.sdk:shortcut-sdk:0.1.0@aar'
}
```

If for some reason this installion method does not work, check out [alternative installation methods](#alternative-installation-methods).


## Prerequisites

To make use of this SDK you need the following:

- An API key. Use the [Shortcut Manager](http://manager.shortcut.sc/mobile_apps) to create a mobile app with an associated API key.

For the deep linking features you need in addition:

- An Android app that supports deep linking. The section below [Add deep linking support to your app](#add-deep-linking-support-to-your-app) explains how to configure your app to support deep links.
 

## Integration into your app


### Enabling the SDK

There are 4 methods to enable the SDK inside your app. The preferred method is [Method 1: Register our Application class](#method-1-register-our-application-class). If your application needs to support pre-14 API, please use [Method 4: Manual session management](#method-4-manual-session-management-for-pre-14-support).

#### Method 1: Register our Application class

Simply register our application class in the `Manifest.xml` configuration file and add your authentication token:

```xml
    <application
        android:name="sc.shortcut.sdk.SCApplication"
        ...>
        <meta-data android:name="sc.shortcut.sdk.authToken" android:value="<your auth token>" />
```

That's it! Your app supports now deferred deep linking and statistics are gathered automatically.

#### Method 2: Extend from our Application class

If you already have an Application class then extend it with `SCApplication`.

```java
  public class YourApplication extends SCApplication
```

And add the authentication token to your `Manifest.xml`.

```xml
  <application>
    <meta-data android:name="sc.shortcut.sdk.authToken" android:value="<your key>" />
    ...
```

#### Method 3: Initialize the SDK yourself

_We do not support this yet!_

~~If you do not want to/can extend from `SCApplication` for some
reason you can initialize the SDK yourself in your
`Application#onCreate()` method or in the Activity receiving the
deep link intent.~~

```java
  @Override
  public void onCreate() {
    super.onCreate();
    new SCApplication(this);
}
```

#### Method 4: Manual session management for pre-14 support

Unless you need to support API pre-14 we recommend using automatic session managment (methods 1 - 3).

In your entry Activity add the following:

```java
  @Override
  protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      SCConfig config = new SCConfig("<your auth token>");
      Shortcut shortcut = Shortcut.getInstance(config, this);    
      if (savedInstanceState == null) { // You wanna probably ignore device rotation
        shortcut.sendAppOpenEvent();
        
        // if app was opened with a deep link
        shortcut.startSession(getIntent());
      }
  }

```

### Retrieve the deep link

Usually your app should respond to a deep link with a corresponding view. You can retrieve the deep link either from the incoming intent or from the `Shortcut` class.

Note that you can retrieve the deep link at any time during the activity's lifecyle, but generally you want to do so in `onCreate()` or `onStart()`.

The following example shows how to retrieve the deep link through the incoming intent. If the app was launched for the first time a possible deferred link is available through the intent:

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    ...

    if (Intent.ACTION_VIEW.equals(getIntent.getAction()) {
        Uri deepLink = getIntent().getData();
        if (deepLink != null) {
            Log.d(TAG, "opened with deep link: " + deepLink);
            // TODO show content for deep link
        }
    }
}
```

And in the example below the deep link is retrieved from `Shortcut`.

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    ...

    Uri deepLink = Shortcut.getInstance().getDeepLink()
    if (deepLink != null) {
        Log.d(TAG, "opened with deep link: " + deepLink);
        // TODO show content for deep link
    }
}

```

### Creating Short Links (short mobile deep links)

Shortcut allows you to generate short links immediately, no (potentially slow) backend roundtrip is required. This works as follows:

1. The SDK generates a unique short link and returns it to you immediately
2. The generated short link as well as all its parameters (website URL, title, deep links) are sent to the Shortcut backend in the background

This way you get a link immediately that you can present in a share sheet or send out via email, no need to wait for a backend.

Here is an example how to create a Short Link.
```java

SCShortLinkBuilder builder = new SCShortLinkBuilder(getActivity())
      .addWebLink("https://www.pinterest.com/meissnerceramic/allein-alone")
      .addDeepLink("pinterest://board/meissnerceramic/allein-alone");

// Returns null if network unavailble or if for some reason link could not have been generated
String shortLink = builder.createShortLink();
```

#### Alternative: Asynchronous creation

There is also an asynchronous way to create a new short link. It works as follows:

1. The SDK sends the parameters for the short link to the backend
2. The backend generates a new short link and returns it to the SDK
3. The SDK notifies you of the new short link via a callback listener

This way you have to wait for the backend to generate the short link, but if there are any errors (e.g. no network connection) then you can react to them.

The implementation of the example above would look like this with the asynchronous call:
```java

SCShortLinkBuilder builder = new SCShortLinkBuilder(getActivity())
      .addWebLink("https://www.pinterest.com/meissnerceramic/allein-alone")
      .addDeepLink("pinterest://board/meissnerceramic/allein-alone");

builder.createShortLink(new SCShortLinkCreateListener() {
    @Override
    public void onLinkCreated(Uri shortLink) {
        Log.i("Shortcut", "Got a short link " + shortLink);
    }
});
```

##### Different deep links per platform
If your deep links are not identical for the different platforms your app supports (iOS, Android, Windows Phone) then you can specify them on a per-platform basis: 

```java
SCShortLinkBuilder builder = new SCShortLinkBuilder(getActivity())
      .addWebLink("https://www.pinterest.com/meissnerceramic/allein-alone")
      .addAndroidDeepLink("pinterest+something://item/allein-alone")
      .addIosDeepLink("https://www.pinterest.com/meissnerceramic/allein-alone")
      .addWindowsPhoneDeepLink("pinterest://board/meissnerceramic/allein-alone");
```

##### Custom domain for short links
If you set up a custon domain for your short links in the Shortcut Manager and want to use it for short links created from the SDK as well, then you need to tell the SDK about it. 

This is done either by declaring it in the `Manifest.xml` file, 

```xml
  <application>
    <meta-data android:name="sc.shortcut.sdk.shortLinkUrlBase" android:value="http://short.com" />
    ...
```

or by setting the config programmatically 

```java
SCConfig config = Shortcut.getInstance().getConfig();
config.setBaseUrl("http://short.com");
```


### What's next?

Use the [Shortcut Manager](http://manager.shortcut.sc) to create a short-url and set up a deep link to your app specified.

## Add deep linking support to your app

Android already has support for deep links baked in. The Shortcut Deep Linking SDK extends the basic built-in functionality with deferred deep links, statistics of app interactions through deep links and short-url generation (suited for sharing).

In order to support deep links in your app add an intent filter to the `Activity` which you want to get opened when a short link is clicked. This is the entry point of your app. For details check out the [Android documentation](https://developers.google.com/app-indexing/android/app). The example below demonstrates how you would configure deep link support for the launcher activity in your app's `Manifest.xml`:

```XML
 <activity
      android:name=".MainActivity"
      android:label="@string/app_name" >
      <intent-filter>
          <action android:name="android.intent.action.MAIN" />
          <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>

      <!-- Add this intent filter below, and change the 'scheme' attribute to a unique -->
      <!-- custom scheme that identifies your app. The host and path attribute are     -->
      <!-- optional.                                                                   -->
      <intent-filter>
          <action android:name="android.intent.action.VIEW" />
          <category android:name="android.intent.category.DEFAULT" />
          <category android:name="android.intent.category.BROWSABLE" />
          <data
              android:host="shortcut.sc"
              android:scheme="scdemo"
              android:path="/demo"/>
      </intent-filter>
  </activity>
```

In order to test the deep link support the following command should launch your app:
```Shell
adb shell am start -a android.intent.action.VIEW -d "scdemo://shortcut.sc/demo"
```

## Alternative installation methods

### Add .AAR file as a module

1. Download the latest .AAR file from the [releases page](https://github.com/shortcutmedia/shortcut-deeplink-sdk-android/releases).
2. In Android Studio import the .AAR file (File -> New Module -> Import
   .JAR/.AAR).
3. Then in your app module `build.gradle` add the following dependency:
```Gradle
dependencies {
    compile project(':DeepLinkingSDK')
}
```

### Use jcenter or mavenCentral

_Support for jcenter and mavenCenteral is coming soon._

## License
This project is released under the MIT license. See included [LICENSE.txt](LICENSE.txt) file for details.
