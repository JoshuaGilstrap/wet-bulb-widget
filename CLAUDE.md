# Claude Development Guidance - Wet Bulb Widget

## Project Overview
Building a wet bulb temperature widget that provides at-a-glance heat safety information with color-coded guidance and recommendations.

## Core Objectives
1. Calculate accurate wet bulb temperature from ambient temperature and humidity
2. Provide intuitive color-coded safety levels
3. Offer activity-specific guidance (rest, light activity, exertion)
4. Make it simple and immediately understandable

## Development Philosophy
- **Proof of Concept First**: Start with web-based implementation for easy testing
- **Formula Accuracy**: Use scientifically validated wet bulb calculation
- **Clear Communication**: Avoid false precision, acknowledge limitations
- **User-Centric**: Design for quick glance comprehension

## Wet Bulb Temperature Science
- **Critical Threshold**: ~35°C WBT is theoretically lethal for sustained exposure
- **Activity Matters**: Dangerous thresholds lower with exertion (28-32°C WBT)
- **Better than Dry Bulb**: Integrates temperature AND humidity for heat danger
- **Not WBGT**: Our WBT calculation doesn't account for solar radiation and wind (WBGT does)
- **Best Use**: Indoor/shade contexts or conservative outdoor estimates

## Safety Color Bands (Preliminary)
- **Green (Safe)**: < 21°C WBT - Normal activities safe
- **Yellow (Caution)**: 21-26°C WBT - Monitor hydration, reduce intense exertion
- **Orange (Warning)**: 26-30°C WBT - Limit outdoor activity, frequent breaks
- **Red (Danger)**: 30-32°C WBT - Avoid exertion, stay hydrated, seek cooling
- **Dark Red (Extreme)**: > 32°C WBT - Serious health risk, minimize exposure

## Technical Approach (Phase 1 - Proof of Concept)
- **Platform**: Web (HTML/CSS/JavaScript) for rapid testing
- **API**: OpenWeatherMap or similar (free tier available)
- **Formula**: Stull or simplified psychrometric wet bulb calculation
- **Testing**: Local file execution, no build system needed
- **Location**: Geolocation API or manual entry

## Technical Approach (Phase 2 - Production)
- **Platform**: SwiftUI for iOS/macOS widgets
- **Widget**: WidgetKit framework
- **Configuration**: Companion app for location/preferences
- **Data Persistence**: UserDefaults for settings
- **Background Updates**: Timeline provider for widget updates

## Coding Standards
- Swift-like conventions even in JavaScript (camelCase, clear naming)
- Comprehensive comments for complex calculations
- Error handling for API failures
- Graceful degradation for missing data

## Key Questions to Validate
1. Can we get reliable temperature and humidity data from free APIs?
2. Is the wet bulb calculation accurate enough for safety guidance?
3. Do the color bands make intuitive sense to users?
4. Does the interface provide value at a glance?

## Next Steps
1. ✅ Create planning documents
2. Research and select weather API
3. Implement wet bulb calculation
4. Build web prototype
5. Test with real-world data
6. Iterate based on results
7. Plan Swift migration
