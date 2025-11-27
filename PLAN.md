# Wet Bulb Widget Development Plan

## Project Vision
Create a simple, intuitive widget that displays wet bulb temperature with color-coded safety guidance to help users understand heat danger at a glance. Eventually deploy as iOS/macOS widgets with companion configuration app.

## Phase 1: Proof of Concept (Current Focus)
**Goal**: Validate the concept, formula accuracy, and data availability with a simple web implementation.

### 1.1 Platform & Technology Selection
**Prototype Platform**: HTML/CSS/JavaScript Web App
- **Why**: Instant testing, no build tools, cross-platform
- **Benefits**: Easy to iterate, share, and validate before Swift investment
- **Trade-offs**: Not the final platform, but proves the concept

**API Considerations**:
- **OpenWeatherMap** (Free tier: 60 calls/min, 1M calls/month)
  - Provides: temperature, humidity, location lookup
  - Endpoint: Current Weather Data API
- **WeatherAPI.com** (Alternative - Free tier: 1M calls/month)
- **NWS API** (US only, completely free, no key required)

### 1.2 Wet Bulb Calculation
**Formula Options**:
1. **Stull Formula** (2011) - Good accuracy, simpler
   ```
   Tw = T * atan[0.151977 * sqrt(RH + 8.313659)] + atan(T + RH)
        - atan(RH - 1.676331) + 0.00391838 * RH^(3/2) * atan(0.023101 * RH)
        - 4.686035
   ```
   Where T = temperature (°C), RH = relative humidity (%)

2. **Davies-Jones Approximation** - Meteorologically accepted
   More complex but higher accuracy for extreme conditions

**Selected Approach**: Start with Stull, validate against known values

### 1.3 Safety Level Thresholds
Based on physiological research:

| Level | WBT Range (°C) | WBT Range (°F) | Color | Guidance |
|-------|----------------|----------------|-------|----------|
| Safe | < 21 | < 70 | Green | Normal activities safe for most people |
| Caution | 21-26 | 70-79 | Yellow | Stay hydrated, reduce intense exertion |
| Warning | 26-30 | 79-86 | Orange | Limit outdoor activity, take frequent breaks |
| Danger | 30-32 | 86-90 | Red | Avoid exertion, serious heat stress risk |
| Extreme | > 32 | > 90 | Dark Red | Life-threatening conditions possible |

**Activity Modifiers**:
- Rest: Use thresholds as-is
- Light Activity: Lower each threshold by 2-3°C
- Intense Exertion: Lower each threshold by 4-6°C

### 1.4 Proof of Concept Features
**MVP Features**:
- ✅ Fetch current temperature and humidity for user location
- ✅ Calculate wet bulb temperature
- ✅ Display large, readable WBT value with units
- ✅ Show color-coded safety level
- ✅ Provide activity-specific recommendations
- ✅ Display current dry bulb temp and humidity for reference
- ✅ Simple, clean interface optimized for glance-ability

**Nice-to-Have (if time permits)**:
- Fahrenheit/Celsius toggle
- Manual location entry
- Historical trend (past few hours)
- Feels-like comparison

### 1.5 Testing Checklist
- [ ] Formula validation against known WBT values
- [ ] API connectivity and error handling
- [ ] Color transitions at threshold boundaries
- [ ] Mobile responsive display
- [ ] Various climate conditions (dry heat, humid heat, cold)
- [ ] Edge cases (API failure, no location access)

## Phase 2: iOS/macOS Development (Future)
**Goal**: Native widgets with companion app for iPhone, iPad, and Mac.

### 2.1 Technology Stack
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Widget**: WidgetKit
- **Networking**: URLSession with async/await
- **Persistence**: UserDefaults for settings, Core Data if needed
- **Location**: CoreLocation

### 2.2 Architecture
```
WetBulbWidget/
├── WetBulbApp/              # Main companion app
│   ├── Views/               # SwiftUI views
│   ├── ViewModels/          # MVVM architecture
│   ├── Services/            # API, Location, Calculation services
│   └── Models/              # Data models
├── WetBulbWidget/           # Widget extension
│   ├── WetBulbWidget.swift  # Widget definition
│   ├── Provider.swift       # Timeline provider
│   └── WidgetViews.swift    # Widget UI
└── Shared/                  # Shared between app and widget
    ├── WetBulbCalculator.swift
    ├── WeatherService.swift
    └── Models.swift
```

### 2.3 Widget Specifications
**Widget Sizes**:
- **Small**: WBT value + color background
- **Medium**: WBT + current conditions + brief guidance
- **Large**: Full details with activity recommendations

**Update Strategy**:
- Update every 30 minutes
- Background refresh using timeline provider
- User can force refresh from companion app

### 2.4 Companion App Features
**Configuration**:
- Location selection (current, favorites)
- Temperature units (°F/°C)
- Activity level default
- Notification thresholds

**Additional Views**:
- Detailed current conditions
- Hourly forecast with WBT
- Educational content about wet bulb temperature
- Settings and about

### 2.5 iOS/macOS Specific Considerations
- **App Clips**: Consider for quick access without install
- **Widgets**: Support StandBy mode (iOS 17+)
- **Mac**: Menu bar widget option
- **watchOS**: Complication support
- **Privacy**: Location usage explanation, minimal data collection
- **Accessibility**: VoiceOver support, Dynamic Type

## Phase 3: Polish & Distribution (Future)
- App Store submission
- TestFlight beta testing
- Marketing materials
- User documentation
- Privacy policy
- Support infrastructure

## API Integration Details

### OpenWeatherMap Implementation
```
Endpoint: https://api.openweathermap.org/data/2.5/weather
Parameters:
  - lat, lon: Location coordinates
  - appid: API key
  - units: metric (for Celsius)

Response includes:
  - main.temp: Temperature in Celsius
  - main.humidity: Relative humidity %
  - name: Location name
```

### Geolocation Strategy
**Web Prototype**: Browser Geolocation API
**iOS/macOS**: CoreLocation with user permission

**Fallback**: Manual location entry or default to common test cities

## Success Criteria
**Proof of Concept**:
- ✅ Accurate WBT calculation (verified against reference values)
- ✅ Working API integration
- ✅ Intuitive color-coded display
- ✅ Useful, actionable guidance
- ✅ Smooth user experience

**Production App**:
- 4.5+ star rating
- < 1% crash rate
- Positive user feedback on utility
- Regular updates with weather data
- Minimal battery impact

## Timeline (Estimated)
**Phase 1 (PoC)**: Immediate (tonight/tomorrow)
**Phase 2 (iOS)**: After PoC validation
**Phase 3 (Polish)**: After beta testing

## Open Questions
1. Should we support "feels like" temperature alongside WBT?
2. How much educational content to include in the app?
3. Notification strategy for dangerous conditions?
4. Premium features or completely free?
5. Support for weather stations with WBGT data?

## Resources
- [Stull (2011) WBT Formula](https://journals.ametsoc.org/view/journals/apme/50/11/jamc-d-11-0143.1.xml)
- OpenWeatherMap API Docs
- Apple WidgetKit Documentation
- Human heat stress research papers
