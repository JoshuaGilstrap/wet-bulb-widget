# macOS Support Setup Instructions

## Overview

We're making the Wet Bulb app universal - running on both iOS and macOS with native widgets for each platform. Most of the code is already shared, we just need to enable macOS support and make a few platform-specific adaptations.

## Step 1: Enable macOS Deployment Target

1. **In Xcode**, select the **WetBulb** project in the navigator
2. Select the **WetBulb** target
3. Go to the **General** tab
4. Under **Supported Destinations**, click the **+** button
5. Select **Mac** → **Mac (Designed for iPad)**
6. Set **Minimum Version**: macOS 14.0 (Sonoma)

This makes the app run on macOS using Mac Catalyst - it will automatically adapt the iOS UI for desktop.

## Step 2: Platform-Specific Code (Already Handled)

Our code already uses SwiftUI which adapts to each platform automatically. The only files that need platform-specific handling are:

- **LocationService.swift** - Already iOS/macOS compatible (CoreLocation works on both)
- **WeatherService.swift** - Already platform-agnostic
- **All UI files** - SwiftUI automatically adapts

No changes needed! 🎉

## Step 3: Add macOS Widget Extension

Just like we did for iOS, we need a separate widget extension for macOS.

### 3.1 Create macOS Widget Target

1. **In Xcode**, select `File` → `New` → `Target...`
2. Select **macOS** tab
3. Choose **Widget Extension**
4. Click **Next**
5. Configure:
   - **Product Name**: `WetBulbMacWidget`
   - **Include Configuration Intent**: ❌ UNCHECK
   - Click **Finish**
6. When prompted "Activate WetBulbMacWidget scheme?", click **Activate**

### 3.2 Replace Generated Widget Files

Similar to iOS widget setup:

1. **Delete** auto-generated files in `WetBulbMacWidget` group:
   - Delete the default `WetBulbMacWidget.swift`
   - Delete the default bundle file
   - Keep `Assets.xcassets`

2. **Copy widget files** from iOS widget:
   - We can reuse the same widget views!
   - Just need to add them to the Mac widget target

### 3.3 Add Shared Code to macOS Widget Target

Select each file and add to **WetBulbMacWidget** target:

```
Models/
  ├── ActivityLevel.swift ✅
  ├── SafetyLevel.swift ✅
  └── WeatherData.swift ✅

Services/
  ├── WetBulbCalculator.swift ✅
  ├── WeatherService.swift ✅
  └── LocationService.swift ❌ (widgets don't use location)

Extensions/
  └── UserDefaults+Settings.swift ✅

WetBulbWidget/ (iOS widget files - reuse for macOS)
  ├── WetBulbWidget.swift ✅
  ├── WetBulbWidgetProvider.swift ✅
  ├── WetBulbWidgetEntry.swift ✅
  ├── WetBulbWidgetBundle.swift ✅
  ├── SmallWidgetView.swift ✅
  ├── MediumWidgetView.swift ✅
  └── LargeWidgetView.swift ✅
```

### 3.4 Set Up App Group for macOS Widget

Same as iOS:

1. Select **WetBulb** target
2. In **Signing & Capabilities**, verify App Group is already there
   - Should show `group.com.yourname.wetbulb`
   - If not, add it again for macOS

3. Select **WetBulbMacWidget** target
4. **Signing & Capabilities** → **+ Capability** → **App Groups**
5. Check the SAME group: `group.com.yourname.wetbulb`

## Step 4: Build and Run

### Test macOS App:
1. Select **WetBulb** scheme
2. Select **My Mac** as the run destination
3. Press **Cmd+R**
4. App should launch on macOS!

### Test macOS Widget:
1. Select **WetBulbMacWidget** scheme
2. Select **My Mac** as the run destination
3. Press **Cmd+R**
4. Widget picker will appear
5. Add widget to Notification Center or desktop

## Platform Differences to Expect

### macOS App:
- Window-based instead of full screen
- Title bar with standard window controls
- Larger default window size
- Menu bar (File, Edit, etc.)
- Keyboard shortcuts work
- Settings available via Cmd+,

### macOS Widgets:
- Notification Center widgets (sidebar)
- Desktop widgets (macOS Sonoma+)
- Same three sizes as iOS
- Same update frequency (15 minutes)
- Click to open main app

## Troubleshooting

### "Mac not available" in run destinations:
- Make sure you selected "Mac (Designed for iPad)" not regular Mac Catalyst
- Check minimum macOS version is set correctly

### Widget not showing:
- Verify App Group is configured for Mac widget target
- Check that all shared files are added to WetBulbMacWidget target
- Try removing and re-adding the widget

### Build errors:
- Clean build folder: **Product → Clean Build Folder**
- Make sure all targets are set correctly
- Verify code signing is configured

## What Works on macOS

✅ **Main App Features:**
- All iOS features work on macOS
- Weather data fetching
- Location services
- Settings persistence
- Color-coded safety levels
- Activity-based recommendations

✅ **Widget Features:**
- Same three sizes as iOS
- 15-minute updates
- Shares data with main app
- Color-coded displays
- Shows recommendations

## Optional: Menu Bar Support

If you want a menu bar app later (shows WBT in menu bar), we can add that as a future enhancement. For now, the desktop widget provides quick access.

---

## Next Steps

Once macOS support is enabled:
1. Test the main app on macOS
2. Test widgets in Notification Center
3. Test desktop widgets (if on macOS Sonoma+)
4. Verify settings sync between iOS and macOS (if using same iCloud account)

Then you'll have a complete universal app! 🚀
