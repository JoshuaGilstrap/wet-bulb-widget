# Wet Bulb Widget - iOS/macOS Development Plan

## Project Overview
Transform the proven HTML/JavaScript proof of concept into a native iOS and macOS app with widget support, maintaining the same core functionality and user experience while leveraging platform-native features.

## Platform Strategy: Universal App

**Good news**: We can absolutely build this as a universal (multiplatform) app!

### How Universal Apps Work
- **Single Xcode Project**: One project builds for both iOS and macOS
- **Shared Code**: Most business logic, models, and calculations are shared
- **Platform-Specific UI**: SwiftUI adapts automatically, with some conditional code for platform differences
- **Separate Widget Extensions**: iOS widgets and macOS widgets are separate targets but share core code

### Your Current Setup
Your Xcode project was created as iOS-only, but we can easily convert it to multiplatform by:
1. Adding macOS as a deployment target in project settings
2. Creating conditional code where platforms differ
3. Adding separate widget extension targets for each platform

**Recommendation**: Build shared core first, then add platform-specific features. This approach is clean and maintainable.

---

## Phase 1: Core Foundation (Shared Code) ✅ COMPLETED

### 1.1 Project Structure Setup ✅
**Goal**: Organize codebase for code sharing between iOS, macOS, and widgets

```
WetBulb/
├── WetBulb/                          # Main iOS app
│   ├── WetBulbApp.swift
│   ├── Models/                       # ✅ Created
│   │   ├── ActivityLevel.swift
│   │   ├── SafetyLevel.swift
│   │   └── WeatherData.swift
│   ├── Services/                     # ✅ Created
│   │   ├── WetBulbCalculator.swift
│   │   ├── WeatherService.swift
│   │   └── LocationService.swift
│   ├── Extensions/                   # ✅ Created
│   │   └── UserDefaults+Settings.swift
│   ├── Views/
│   │   ├── iOS/                      # Coming in Sprint 2
│   │   └── macOS/                    # Coming in Sprint 4
│   └── Assets.xcassets
├── WetBulbWidget/                    # NEW: iOS widget extension
└── WetBulbMacWidget/                 # NEW: macOS widget extension
```

---

## Phase 2: iOS Main App (NEXT)

### 2.1 View Model
Create the brain of the app that manages state and coordinates services.

### 2.2 Main Views
Build SwiftUI views matching the HTML proof of concept:
- ContentView (main coordinator)
- WetBulbDisplayCard (large colored safety display)
- CurrentConditionsGrid (temp + humidity)
- ActivityPicker
- RecommendationsList
- SettingsView

### 2.3 Integration
Wire everything together and test on iOS simulator/device.

---

## Phase 3: iOS Widget Extension

Widget features for home screen:
- Small: WBT + color background
- Medium: WBT + temp/humidity + safety level
- Large: Full view with recommendations

---

## Phase 4: macOS Support

Enable macOS deployment and create desktop widgets.

---

## Phase 5: Polish & Testing

Error handling, accessibility, testing.

---

## Implementation Status

### Sprint 1: Core Foundation ✅ COMPLETE
- [x] Create shared code module structure
- [x] Build data models (WeatherData, SafetyLevel, ActivityLevel)
- [x] Implement WetBulbCalculator with Stull formula
- [x] Create WeatherService for Open-Meteo API
- [x] Implement LocationService
- [x] Create AppSettings with UserDefaults

### Sprint 2: iOS Main App (IN PROGRESS)
- [ ] Build WeatherViewModel
- [ ] Create main ContentView
- [ ] Build WetBulbDisplayCard
- [ ] Create CurrentConditionsGrid
- [ ] Implement ActivityPicker
- [ ] Build RecommendationsList
- [ ] Create SettingsView
- [ ] Add location permission to Info.plist
- [ ] Test on simulator

### Sprint 3: iOS Widget (PENDING)
### Sprint 4: macOS Support (PENDING)
### Sprint 5: Polish & Testing (PENDING)

---

**Total Estimate**: 10-15 days of focused development for MVP

---

See full detailed plan in earlier sections of this document.
