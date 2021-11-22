# MxG

MxG is weight tracking mobile (and web) application built using Flutter and Firebase. You can record weight measurements and save them in the app. The app can also send daily or weekly reminders through your phone's notifications.
* Data is saved in Firestore.
* Reminders are delivered with Cloud Messaging (on mobile only).
* Authentication is handled by Firebase Auth.

This is a personal project where the goal was to deliver a functional and relatively useful app to either the Play Store or App Store.

Currently, I don't have access to a Mac development environment, so only the Android version is available [here](https://play.google.com/store/apps/details?id=com.mxg.mxg).

The web version can be found [here](https://mxg-weight.web.app). However, it lacks proper scaling for the wider screen size. 

![Android-ss1](https://play-lh.googleusercontent.com/j-KHNoXB0Zju84PJekzZKY2eZ0lXjNqrsgDQDZaCob3Gq6mMuU8Cn-I71DHiqyX8PUs=w1536-h746-rw) ![Android-ss2](https://play-lh.googleusercontent.com/xGlgGqpXZDidG2HJ97_NrkzZDoYNDUsOLqdQro2abQZBT46C8lQirNRalSi1FxN6Yg=w1536-h746-rw) ![Android-ss2](https://play-lh.googleusercontent.com/Cu_zvhILDezYT-2V3IZg3QSofB48a4ioaWqJ17d3DrI2_fl1urBY1DP_1n4tbrPQmQ=w1536-h746-rw) ![Android-ss3](https://play-lh.googleusercontent.com/c53W3-0KpjjgRgJpy6FHRGR8liVHcsumi9t2PtSRFHIhHeJNwnvFxP2ZaZVltPIHe9M7=w1536-h746-rw)

# Missing IOS configurations:

- Localization, https://flutter.dev/docs/development/accessibility-and-localization/internationalization#localizing-for-ios-updating-the-ios-app-bundle
- Most Firebase configurations
