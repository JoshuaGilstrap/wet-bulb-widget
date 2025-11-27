# Wet Bulb Temperature Widget

A simple, intuitive widget that displays wet bulb temperature with color-coded safety guidance to help users understand heat danger at a glance.

## 🎯 What is Wet Bulb Temperature?

Wet bulb temperature (WBT) is a measure that combines air temperature and humidity to indicate the body's ability to cool itself through evaporation of sweat. It's a more accurate indicator of heat danger than temperature alone.

**Why it matters:**
- A dry 40°C (104°F) can be survivable
- A humid 35°C WBT can be lethal regardless of fitness or hydration
- WBT integrates temperature AND humidity into one meaningful number
- Critical for understanding heat danger in a warming, more humid climate

## 🚀 Quick Start - Proof of Concept

### How to Run

1. **Simply open the HTML file in your browser:**
   ```bash
   # On Mac:
   open index.html

   # On Linux:
   xdg-open index.html

   # On Windows:
   start index.html
   ```

2. **Allow location access** when prompted (or it will default to San Francisco)

3. **View your current wet bulb temperature** with safety recommendations!

### No API Key Required!

This proof of concept uses **Open-Meteo**, a free weather API that requires no registration or API key. Perfect for testing!

## 📊 Features

### Current Implementation (v1.0 - Web PoC)

✅ **Wet Bulb Calculation**: Scientifically accurate using Stull (2011) formula
✅ **Real-time Weather Data**: Auto-fetches temperature and humidity for your location
✅ **Color-Coded Safety Levels**: 5 distinct safety levels (Safe → Extreme Danger)
✅ **Activity-Based Guidance**: Adjusts recommendations for rest, light, moderate, or intense activity
✅ **Detailed Recommendations**: Specific safety advice for each condition/activity combination
✅ **Temperature Units**: Toggle between Fahrenheit and Celsius
✅ **Responsive Design**: Works on desktop and mobile
✅ **No Build Required**: Single HTML file, runs immediately

## 🎨 Safety Color Codes

| Color | Level | WBT Range (°C) | WBT Range (°F) | Meaning |
|-------|-------|----------------|----------------|---------|
| 🟢 Green | Safe | < 21 | < 70 | Normal activities safe |
| 🟡 Yellow | Caution | 21-26 | 70-79 | Stay hydrated, reduce intense exertion |
| 🟠 Orange | Warning | 26-30 | 79-86 | Limit outdoor activity, frequent breaks |
| 🔴 Red | Danger | 30-32 | 86-90 | Avoid exertion, serious heat stress risk |
| ⚫ Dark Red | Extreme | > 32 | > 90 | Life-threatening conditions possible |

**Note**: Thresholds automatically adjust based on selected activity level. Intense activities lower safe thresholds by ~6°C.

## 🧮 The Science

### Wet Bulb Temperature Formula

We use the **Stull (2011)** formula, which is meteorologically validated:

```
Tw = T × atan[0.151977 × √(RH + 8.313659)] + atan(T + RH)
     - atan(RH - 1.676331) + 0.00391838 × RH^(3/2) × atan(0.023101 × RH)
     - 4.686035
```

Where:
- `Tw` = Wet bulb temperature (°C)
- `T` = Dry bulb temperature (°C)
- `RH` = Relative humidity (%)

**Valid for**: -20°C to 50°C and 5% to 99% humidity

### Why Not WBGT?

**Wet Bulb Globe Temperature (WBGT)** is more comprehensive (adds solar radiation and wind), but:
- Requires specialized equipment (black globe thermometer)
- Can't be calculated from standard weather data
- Our WBT is more conservative and works well for indoor/shade contexts

### Activity-Based Thresholds

Research shows heat danger thresholds decrease with physical activity:

| Activity Level | Threshold Adjustment |
|----------------|---------------------|
| Rest / Indoor | No adjustment (baseline) |
| Light Activity | -2°C from baseline |
| Moderate Activity | -4°C from baseline |
| Intense Exertion | -6°C from baseline |

Example: "Safe" threshold at 21°C WBT for rest becomes 15°C for intense exertion.

## 📁 Project Structure

```
wet-bulb-widget/
├── index.html              # Main web app (standalone, complete)
├── README.md              # This file
├── PLAN.md                # Comprehensive development plan
├── CLAUDE.md              # Development guidance and philosophy
├── API_RESEARCH.md        # Weather API comparison and selection
├── BACKGROUND.md          # Original conversation context
└── .gitignore
```

## 🧪 Testing the Formula

To validate the wet bulb calculation, test against known values:

| Temp (°C) | Humidity (%) | Expected WBT (°C) |
|-----------|--------------|-------------------|
| 30 | 50 | ~21.5 |
| 35 | 60 | ~27.1 |
| 25 | 80 | ~22.7 |
| 40 | 30 | ~25.6 |

Open the browser console and test:
```javascript
calculateWetBulbTemp(30, 50)  // Should return ~21.5
```

## 🔄 Future Roadmap

### Phase 2: iOS/macOS Native App

- **Platform**: SwiftUI + WidgetKit
- **Features**:
  - Home screen and Lock screen widgets
  - StandBy mode support
  - Mac menu bar widget
  - watchOS complications
  - Hourly forecasts with WBT
  - Location favorites
  - Notification system for dangerous conditions
  - Educational content about heat safety

### Phase 3: Advanced Features

- Historical trends and daily patterns
- Heat index comparison
- UV index integration
- Acclimatization tracking
- Emergency cooling center locator
- Share/export functionality

## 💡 Usage Tips

1. **Check before outdoor activities**: Look before exercising, working outside, or planning events
2. **Select your activity level**: The app adjusts recommendations based on what you're doing
3. **Monitor throughout the day**: Conditions can change rapidly
4. **Share with vulnerable groups**: Elderly, children, and those with health conditions are most at risk
5. **Don't rely solely on temperature**: A "comfortable" 85°F with high humidity can be more dangerous than 100°F with low humidity

## ⚠️ Important Disclaimers

- **Not medical advice**: This tool provides general guidance. Consult healthcare professionals for personal advice.
- **Individual variation**: Heat tolerance varies by acclimatization, age, health, medications, etc.
- **Indoor/shade bias**: WBT doesn't account for direct sun or wind (unlike WBGT)
- **Use multiple indicators**: Consider heat index, personal comfort, and common sense
- **Emergency situations**: Call emergency services (911) for heat-related illness

## 🛠️ Technical Details

### Weather Data Source
- **API**: Open-Meteo (https://open-meteo.com)
- **Endpoints**: Current weather forecast API
- **Data**: Temperature (2m) and relative humidity (2m)
- **Update frequency**: On-demand (click refresh)
- **Coverage**: Global
- **Cost**: Free, no API key required

### Browser Requirements
- Modern browser with JavaScript enabled
- Geolocation API support (optional - fallback available)
- ES6+ JavaScript support

### Performance
- **Load time**: < 1 second
- **API response**: Typically 200-500ms
- **Data size**: ~2KB per weather request
- **Offline**: Not supported (requires API for current data)

## 🤝 Contributing

This is currently a proof of concept. Feedback welcome on:
- Formula accuracy
- Safety threshold appropriateness
- UI/UX improvements
- Feature suggestions for iOS version

## 📚 References

- [Stull (2011) Wet-Bulb Temperature Formula](https://journals.ametsoc.org/view/journals/apme/50/11/jamc-d-11-0143.1.xml)
- [NOAA Heat Index](https://www.weather.gov/safety/heat-index)
- [WHO Heat and Health Guidelines](https://www.who.int/news-room/fact-sheets/detail/climate-change-heat-and-health)
- [Open-Meteo Weather API](https://open-meteo.com/en/docs)

## 📄 License

MIT License - Feel free to use and modify for your needs.

---

**Built with ❤️ for heat safety awareness**

*Inspired by Apple TV's "Extrapolations" and the very real science of heat stress*