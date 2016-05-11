# Referrals for Android
The best product is the one that sells itself. With referrals, you allow your users to invite others. With Shortcut you can create a seamless user flow to make your on-boarding experience as frictionless as possible.

##Requirements

The SDK works with Android API 10+.

In order to make referrals work, you need to add our [Shortcut SDK for Android](https://developer.shortcut.sc/shortcut_sdk)to your app. 

##How it works

Your existing user Johnny Appleseed with the user name `j_appleseed` wants to invite his friend John Doe to use your app. He clicks a button/menu item within your app which triggers the creation of a Shortcut and creates a new share intent with the Shortcut. A share action is then displayed to allow Johnny to send the Shortcut to his friend. When the friend clicks the Shortcut he is taken to the Google PlayStore and when he opens the app, he is greeted by a customized welcome message from Johnny Appleseed containing e.g. a special offer or bonus points.

##Implementation

In this example, we define the referral parameter `referral_from` to identify the inviting user with the user name.

Add a button to your UI and wire it up in the corresponding Activity or Fragment. Following an example with a `ACTION_SEND` intent:

```java
...

rootView.findViewById(R.id.share_short_link).setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        SCShortLinkBuilder builder = new SCShortLinkBuilder(getActivity())
                .addWebLink("https://www.pinterest.com/meissnerceramic/allein-alone?referral_from=j_appleseed")
                .addAndroidDeepLink("pinterest://board/meissnerceramic/allein-alone?referral_from=j_appleseed")
                .addIosDeepLink("pinterest://board/meissnerceramic/allein-alone?referral_from=j_appleseed");
        String shortLink = builder.createShortLink();


        // Create the new Intent using the 'Send' action.
        Intent sendIntent = new Intent(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, shortLink);
        sendIntent.setType("text/plain");
        startActivity(sendIntent);
    }
});

...

```


When the invited user eventually installs and launches the app, you can retrieve the referral parameter from the deep link again:

```java

@Override
protected void onCreate(Bundle savedInstanceState) {
    ...

    Uri deepLink = Shortcut.getInstance().getDeepLink()
    if (deepLink != null) {
        Log.d(TAG, "You have been invited by " + deepLinkFromSDK.getQueryParameter("referral_from") );
    }
}

```

##Extensions
You can also send coupon codes and more parameters with the Shortcut to create more sophisticated solutions. For this, you can define parameters such as `referral_code` or `referral_validity` and add them to your URL.

If you need more information or support on integrating referrals, please [contact us](mailto:support@shortcutmedia.com). We are happy to help!
