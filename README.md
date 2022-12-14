# Google Calendar API Demo
### Built on SwiftUI using GoogleSignIn and GoogleAPIClientForREST

This app is built to show all the events associated with a google account.


## Demo Video


https://user-images.githubusercontent.com/32486561/203391101-c55a6c7a-7629-416c-8b7d-1c4920833bed.mp4




## Features

- Sign in via Google
- Accept Calendar Permissions
- All the calendar data gets synced to the app.
- Users can view all the calendars they have
- Users can view all the events associated with a calendar
- Filter events by Year and Month
- Search for calendars and events from spotlight
- Supports `iOS`, `iPadOS`, `macOS` (Supports Mac Catalyst)

## Tech

This demo uses a number of open source projects to work properly:

- [GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS) - Enables iOS and macOS apps to sign in with Google.
- [GoogleAPIClientForRest](https://github.com/google/google-api-objectivec-client-for-rest) - Google API Client in ObjC to fetch API data for google services
- [Lottie](https://github.com/airbnb/lottie-ios) - An iOS library to natively render After Effects vector animations.
- [Core Spotlight](https://developer.apple.com/documentation/corespotlight) - Indexing app so users can search the content from Spotlight and Safari.
- [Core Services](https://developer.apple.com/documentation/coreservices/) - Access and manage key operating system services, such as launch and identity services.

And of course this demo app itself is open source with a [public repository](https://github.com/ipratikk-work/Google-Calendar-API-Demo/) on GitHub.

## Installation

- Minimum Xcode version - `13.2`
- Minimum Deployment Version
    - iOS - `15.2`
    - macOS - `12.1`
- Fetch Google Auth 2.0 token from [Google cloud console](https://console.cloud.google.com/apis/credentials).
- Enable Calendar API
- Modify OAuth 2.0 token and add calendar scopes, as required.
- Add testers to the OAuth token
- Create API key with the app bundle identifier
- Download the OAuth 2.0 plist file and add to project
- Rename the Plist file to `GoogleInfo.plist`
- Install the packages via `SPM (Swift Package Manager)` or Wait for the packages to be resolved automatically

Install the dependencies and devDependencies and build the application.

## Development

Want to contribute? Great!

This app uses `SwiftUI + Combine` for binding data and creating the UI.


### Work In Progress
- Deeplink for events in spotlight
- Optimising indexing of events in spotlight
- Using a Watch for Google calendar instead of timed API calls (Unable to get proper documentation on this in [GoogleAPIClientForRest](https://github.com/google/google-api-objectivec-client-for-rest))

> **Open to contributions and enhancements on the project**

## License

MIT

**Free Software, Hell Yeah!**
