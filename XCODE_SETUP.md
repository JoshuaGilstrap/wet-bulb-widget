# Xcode Project Setup Instructions

## Required: Add Location Permission

The app needs location permission to fetch weather data for your current location.

### Steps:
1. In Xcode, select the **WetBulb** project in the navigator
2. Select the **WetBulb** target
3. Go to the **Info** tab
4. Under "Custom iOS Target Properties", click the **+** button
5. Add this key-value pair:
   - **Key**: `Privacy - Location When In Use Usage Description`
   - **Type**: String
   - **Value**: `We need your location to provide accurate wet bulb temperature for your area.`

Alternatively, you can add it directly:
- **Key**: `NSLocationWhenInUseUsageDescription`
- **Value**: `We need your location to provide accurate wet bulb temperature for your area.`

### Why This Is Required
Without this permission string, iOS will crash the app when we try to request location access. This is a privacy requirement that shows users why the app needs their location.

---

## Optional: Enable macOS Support (For Later)

When we're ready to add macOS support in Sprint 4:

1. Select the **WetBulb** target
2. Go to **General** tab
3. Under **Supported Destinations**, check **Mac**
4. Set minimum macOS version to **14.0** (macOS Sonoma)

This will allow the app to run on both iOS and macOS!

---

## Troubleshooting

### If files aren't showing in Xcode:
1. Right-click on the **WetBulb** folder in Xcode
2. Select **Add Files to "WetBulb"...**
3. Navigate to and select the **Models**, **Services**, and **Extensions** folders
4. Ensure these options are checked:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: WetBulb

### If you get build errors:
- Make sure all Swift files are added to the WetBulb target
- Check that the deployment target is iOS 17.0 or later
- Clean build folder: **Product → Clean Build Folder** (Shift+Cmd+K)

---

Once you've added the location permission, we're ready to proceed with building the UI!
