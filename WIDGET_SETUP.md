# iOS Widget Setup Instructions

## Widget Code Files Created ✅

All widget code has been created in the `WetBulbWidget/` directory:
- `WetBulbWidget.swift` - Main widget definition
- `WetBulbWidgetProvider.swift` - Timeline provider (15-minute updates)
- `WetBulbWidgetEntry.swift` - Widget entry/data model
- `WetBulbWidgetBundle.swift` - Widget bundle entry point
- `SmallWidgetView.swift` - Small widget layout
- `MediumWidgetView.swift` - Medium widget layout
- `LargeWidgetView.swift` - Large widget layout

## Step 1: Add Widget Extension Target

1. **In Xcode**, select `File` → `New` → `Target...`
2. Select **Widget Extension** (under iOS)
3. Click **Next**
4. Configure:
   - **Product Name**: `WetBulbWidget`
   - **Include Configuration Intent**: ❌ UNCHECK (we don't need it)
   - Click **Finish**
5. When prompted "Activate WetBulbWidget scheme?", click **Activate**

## Step 2: Replace Generated Widget Files

Xcode will have created a `WetBulbWidget` folder with some default files. We need to replace them:

1. **Delete** the auto-generated files in the `WetBulbWidget` group in Xcode:
   - Delete `WetBulbWidget.swift` (the default one)
   - Delete `WetBulbWidgetBundle.swift` (the default one)
   - Delete `AppIntent.swift` (if it exists)
   - Keep `Assets.xcassets`

2. **Add our widget files**:
   - Drag the `WetBulbWidget` folder from Finder into Xcode
   - When prompted:
     - ✅ Copy items if needed
     - ✅ Create groups
     - ✅ Add to targets: **WetBulbWidget** (the widget target, NOT the main app)

## Step 3: Add Shared Code to Widget Target

The widget needs access to your models and services:

1. In Xcode's **Project Navigator**, select each of these files
2. In the **File Inspector** (right panel), check **BOTH** targets:
   - ✅ WetBulb (main app)
   - ✅ WetBulbWidget (widget extension)

**Files to add to both targets:**
```
Models/
  ├── ActivityLevel.swift ✅
  ├── SafetyLevel.swift ✅
  └── WeatherData.swift ✅

Services/
  ├── WetBulbCalculator.swift ✅
  ├── WeatherService.swift ✅
  └── LocationService.swift ❌ (skip this one - widgets can't use location)

Extensions/
  └── UserDefaults+Settings.swift ✅
```

**How to add files to widget target:**
- Select each file in Project Navigator
- Open File Inspector (⌥⌘1)
- Under "Target Membership", check ✅ WetBulbWidget

## Step 4: Set Up App Group (Critical for Data Sharing)

Widgets run in a separate process and can't access the app's UserDefaults directly. We need an App Group.

### 4.1 Add App Group Capability to Main App

1. Select **WetBulb** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Click **+** under App Groups
6. Enter: `group.com.yourname.wetbulb` (replace `yourname` with your actual name or company)
7. Click **OK**

### 4.2 Add App Group Capability to Widget

1. Select **WetBulbWidget** target
2. Go to **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups**
5. Check the SAME group: `group.com.yourname.wetbulb`

### 4.3 Update UserDefaults to Use App Group

We need to modify `UserDefaults+Settings.swift` to use the shared container.

**Find this line in `UserDefaults+Settings.swift`:**
```swift
UserDefaults.standard
```

**Replace ALL instances with:**
```swift
UserDefaults(suiteName: "group.com.yourname.wetbulb")!
```

(Make sure to use the EXACT same group name you created above)

## Step 5: Build and Run

1. Select the **WetBulbWidget** scheme in Xcode
2. Select a simulator or device
3. Press **Cmd+R** to build and run
4. Xcode will ask which app to run the widget with → select **WetBulb**
5. The app will launch, then the widget picker will appear
6. Add the widget to your home screen!

## Step 6: Test the Widget

### Testing Small Widget:
- Add a small widget to home screen
- Should show just wet bulb temperature with color background

### Testing Medium Widget:
- Add a medium widget to home screen
- Should show wet bulb temp + temperature + humidity

### Testing Large Widget:
- Add a large widget to home screen
- Should show wet bulb temp + conditions + top 3 recommendations

### Refresh Testing:
- Widget updates every 15 minutes automatically
- Open the main app to fetch fresh data
- Widget should update with new data

## Troubleshooting

### "No such module" errors:
- Make sure all shared files are added to BOTH targets (Step 3)
- Clean build folder: **Product → Clean Build Folder**

### Widget shows "No Data":
- Open the main app first to fetch weather data
- Make sure App Groups are configured identically in both targets
- Check that UserDefaults is using the shared suite name

### Widget not updating:
- Check that App Group names match exactly
- Verify UserDefaults+Settings uses the App Group suite name
- Try removing and re-adding the widget

### Build errors about missing files:
- Make sure you deleted the auto-generated widget files
- Verify all widget files are added to the WetBulbWidget target

---

## What the Widget Does

✅ **Updates every 15 minutes** with fresh weather data
✅ **Shows color-coded safety levels** (green → dark red)
✅ **Displays wet bulb temperature** in user's preferred unit
✅ **Shows current conditions** (temperature & humidity)
✅ **Provides safety recommendations** (large widget only)
✅ **Uses cached data** when network is unavailable
✅ **Shares settings** with main app (Fahrenheit/Celsius, activity level)

---

## Next Steps

Once the widget is working:
- Test all three sizes
- Verify it updates after using the main app
- Check that temperature unit setting is respected
- Test with different activity levels in settings

Then we can move on to **Sprint 4: macOS Support**! 🚀
