# Sesquicentennial iOS

The iOS application for the Sesquicentennial Event to happen in 2016 at
Carleton College.

### Configuration

You'll need to include a file called Keys.plist
that contains the necessary API key for Google
Maps. Simply place a file that looks like the
following as Carleton150/Keys.plist and you
should be ready to start the build process:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>GoogleMaps</key>
    <string>Your key here</string>
</dict>
</plist>
```

### Build Process

* `git clone https://github.com/sesquicentennial/iOS`
* If you don't already have Cocoapods:
  * `sudo gem install cocoapods`
* `cd iOS`
* `pod install`
* `open Carleton150.xcworkspace`
* Try running the app!
