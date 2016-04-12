# Short Link API

The Short Link API allows you to create Shortcuts (short links with optional mobile deep links).

### Prerequisites

To use the Short Link API you need an API key with an authentication token. You can get one by signing up for the [Shortcut Manager](http://manager.shortcutmedia.com). After signing up you have to create a new mobile app instance in the Shortcut Manager and then you get an API key with a token for it.

### Short overview

You create Shortcuts by submitting the required data (title, website URL and optional mobile deep linking data) to

`https://shortcut-service.shortcutmedia.com/api/v1/short_link/create`.

Here is an example using `curl`:

```
curl -d "auth_token=XXX"                                          \
     -d "website_url=http://mywebsite.com"                        \
     -d "title=Link to my website"                                \
     -d "ios_deep_link=myapp://some/ios/path"                     \
     -d "android_deep_link=myapp://some/android/path"             \
     -d "windows_phone_deep_link=myapp://some/windows_phone/path" \
     https://shortcut-service.shortcutmedia.com/api/v1/short_link/create
```

Replace `XXX` with your token (see [Prerequisites](#prerequisites)) and all data fields with your data.

You will get a response that looks like this:

```javascript
{
  "uuid": "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
  
  "title":       "Link to my website",
  "website_url": "http://mywebsite.com"
  
  "short_url": "http://scm.st/XYZ",
  
  "mobile_deep_link": {
    "ios_app_name":      "My App",
    "ios_app_store_url": "https://itunes.apple.com/us/app/myapp/idXXX?mt=8&uo=4",
    "ios_deep_link":     "myapp://some/ios/path",
    
    "android_app_name":      "My App",
    "android_app_store_url": "https://play.google.com/store/apps/details?id=XXX",
    "android_deep_link":     "myapp://some/android/path",

    "windows_phone_app_name":      "My App",
    "windows_phone_app_store_url": "https://www.microsoft.com/en-us/store/apps/myapp/XXX",
    "windows_phone_deep_link":     "myapp://some/windows_phone/path"
  },
  
  "created_at": "1970-01-01T00:00:00.000Z",
  "updated_at": "1970-01-01T00:00:00.000Z"
}
```

Congratulations, you have just created your first Shortcut! Of the most interest to you is the `short_url` value in the response: it is the link to the new Shortcut.

### Auto-Completion of missing input values

If you do not provide a `title` or deep link data (`ios_deep_link`, `android_deep_link`, `windows_phone_deep_link`) with your request then the API tries to automatically complete it with data fetched from meta tags on the website. Please use [AppLinks](http://applinks.org/) or [Twitter App Card](https://dev.twitter.com/cards/types/app) meta tags on your website to provide deep link data.

---

## Reference

### Input

##### API endpoint:

`https://shortcut-service.shortcutmedia.com/api/v1/short_link/create`

Submit a `POST` request to the endpoint and include your input data in the request body. Use either form encoding (`application/x-www-form-urlencoded` or `multipart/form-data`) or JSON (`application/json`) to encode your input data.

##### Authentication:

Include an `auth_token` data field in you input. See [Prerequisites](#prerequisites) about how to obtain your token.

##### Data fields:

You can include the following data fields in your request:

- `website_url`: The URL of your website/the link you want to create a Shortcut for. Mandatory.
- `title`: A short description of the website. Optional.
- `ios_deep_link`: A deep link into an iOS app that corresponds to your website. Optional. Example: `myapp://some/path?in=app`.
- `android_deep_link`: A deep link into an Android app that corresponds to your website. Optional. Example: `myapp://some/path?in=app`.
- `windows_phone_deep_link`: A deep link into a Windows Phone app that corresponds to your website. Optional. Example: `myapp://some/path?in=app`.



### Output

The API returns a JSON response. When the creation of the Shortcut succeeded then the response contains data about the Shortcut; if an error occurred then the response contains some details about the error.

##### Data fields:

The following data fields are included if the Shortcut was created successfully:

- `uuid`: The UUID of the Shortcut.
- `title`: A short description of the Shortcut. Either provided by you or taken from your website's meta tags.
- `website_url`: The URL of your website.
- `short_url`: The URL of the Shortcut.
- `mobile_deep_link[ios_deep_link]`: The deep link that is opened when the Shortcut is visited on an iOS device. Either provided by you or taken from your website's meta tags.
- `mobile_deep_link[android_deep_link]`: The deep link that is opened when the Shortcut is visited on an Android device. Either provided by you or taken from your website's meta tags.
- `mobile_deep_link[windows_phone_deep_link]`: The deep link that is opened when the Shortcut is visited on a Windows Phone device. Either provided by you or taken from your website's meta tags.


The following data fields are included if an error occurred:

- `error`: A short description of the error.

##### Errors:

If an error occurs the API gives you a short description in the `error` data field. It also communicates the type of error through the response status code.

The following errors might occur:

- **401 Unauthorized / Authentication error:** You did provide an invalid authentication token or none at all. See [Authentication](#authentication) about how to obtain your token and include it in your request.
- **422 Unprocessable Entity / Invalid parameters:** You did include invalid data in your request. Make sure that you provide a valid http(s) URL in the `website_url` field. If you want to set a title for the Shortcut make sure to not provide an empty string for the (optional) `title` data field.