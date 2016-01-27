#Shortcut App Banners

##Integration instructions

To integrate the app banner on your website you have to integrate the following piece of code on your website:

```java
<script>
  document.write('<scr'+'ipt src="https://shortcut-service.shortcutmedia.com/assets/app_banner.js"></scr'+'ipt>');
  window.addEventListener('load', function() {
    ShortcutAppBanner.setup({

      bannerId: 18,
      deepLink: 'YOUR DEEP LINK HERE'

    });
    ShortcutAppBanner.show();
  });
</script>

```

**Important**: Please replace `YOUR DEEP LINK HERE` in the snippet above with the deep link to corresponding to your website, e.g. `myapp://deep/link`.

If you have different deep links for different platforms, then you can specify the deep links per platform:

```java
<script>
  document.write('<scr'+'ipt src="https://shortcut-service.shortcutmedia.com/assets/app_banner.js"></scr'+'ipt>');
  window.addEventListener('load', function() {
    ShortcutAppBanner.setup({

      bannerId:             18,
      iosDeepLink:          'YOUR iOS DEEP LINK HERE',
      androidDeepLink:      'Your Android DEEP LINK HERE',
      windowsPhoneDeepLink: 'Your Windows Phone DEEP LINK HERE'

    });
    ShortcutAppBanner.show();
  });
</script>

```