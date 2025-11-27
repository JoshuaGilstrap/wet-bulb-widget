# Weather API Research

## Selected API: OpenWeatherMap

### Why OpenWeatherMap?
- **Free Tier**: 60 calls/minute, 1,000,000 calls/month
- **No Credit Card**: Required for free tier
- **Good Documentation**: Comprehensive API docs
- **Reliable Data**: Temperature and humidity included
- **Global Coverage**: Works worldwide
- **Easy Setup**: Simple REST API

### API Details
**Endpoint**: `https://api.openweathermap.org/data/2.5/weather`

**Required Parameters**:
- `lat`: Latitude
- `lon`: Longitude
- `appid`: API key
- `units`: "metric" for Celsius

**Response Data** (relevant fields):
```json
{
  "name": "City Name",
  "main": {
    "temp": 25.5,
    "humidity": 65,
    "feels_like": 26.2
  },
  "weather": [
    {
      "description": "clear sky"
    }
  ]
}
```

### Getting an API Key
1. Go to: https://openweathermap.org/api
2. Sign up for free account
3. Navigate to API keys section
4. Copy your API key
5. Note: New keys may take 1-2 hours to activate

### Alternative APIs Considered

**WeatherAPI.com**
- Free tier: 1M calls/month
- Similar data quality
- Backup option if OpenWeatherMap has issues

**National Weather Service (NWS)**
- Completely free, no key needed
- US only
- Good for US-based testing

**Open-Meteo**
- Completely free, no API key
- Good data quality
- Excellent free option!
- URL: https://open-meteo.com/

## Recommendation for PoC
Use **Open-Meteo** for immediate testing (no API key needed), with OpenWeatherMap as the production option.

### Open-Meteo Implementation
**Endpoint**: `https://api.open-meteo.com/v1/forecast`

**Parameters**:
- `latitude`: Latitude
- `longitude`: Longitude
- `current`: "temperature_2m,relative_humidity_2m"
- `temperature_unit`: "celsius" or "fahrenheit"

**No API key required!** Perfect for proof of concept.
