User: I was somewhat inspired to pursue this project after watching the Apple TV show Extrapolation which showed the imagined impacts of climate change in the near future. I think it was probably pretty highly overestimated such impacts, but one cool thing that stuck out to me was the use throughout the show of wet bulb temperature as a way for people to understand how dangerous outside temperatures were and possible precautions they should take. Is that reasonable? Is wet bulb useful? Would it hypothetically be more useful for human safety in a climate more impacted by global warming? Is it more useful than basic temperature in those respects? Or even possibly a “one simple” number to understand safe or dangerous conditions? Basically, I had the idea to create a widget for a phone screen or desktop to show wet bulb temperature and some color coded safety guidance at a glance. Would that be useful or am I over hyping it?
Claude: Great question, and I think your intuition is mostly sound—wet bulb temperature (WBT) is genuinely more physiologically meaningful than dry bulb for assessing heat danger, but it’s not quite the “one simple number” holy grail. Let me break down where it shines and where it falls short.

**Why WBT is useful:**

The human body’s primary cooling mechanism is sweat evaporation. WBT directly captures the atmosphere’s capacity to accept that evaporation—it integrates temperature *and* humidity into a single metric. A dry 40°C (104°F) is survivable; a humid 35°C WBT is theoretically lethal for sustained exposure regardless of fitness, shade, or hydration, because you physically cannot shed metabolic heat.

So yes, in a warming + wetter climate (especially coastal/tropical regions), WBT becomes increasingly relevant. The show wasn’t wrong to feature it—it’s the metric climate scientists actually use when modeling future habitability thresholds.

**Where it gets complicated:**

1. **Solar radiation and wind matter a lot.** WBT ignores whether you’re in shade or direct sun, and whether there’s airflow. The military and OSHA actually use **Wet Bulb Globe Temperature (WBGT)**, which adds a black globe thermometer (radiant heat) and dry bulb, weighted roughly 70% WBT, 20% globe, 10% dry bulb. More accurate for outdoor work, but harder to calculate from standard weather data.
1. **Thresholds are activity-dependent.** The famous ~35°C WBT lethality limit assumes a resting human. If you’re exerting yourself, dangerous thresholds drop significantly—maybe 28-32°C WBT depending on intensity. Your widget would need to account for this or at least caveat it.
1. **Acclimatization varies.** Someone adapted to Gulf humidity handles conditions differently than someone visiting from Denver.

**Is it better than basic temperature?**

Absolutely, for heat safety specifically. Temp alone is nearly useless without humidity context. A simple WBT widget would be a meaningful upgrade over just showing “95°F” and leaving users to guess if that’s dangerous.

**Would your widget be useful?**

I think yes, with some design nuance:

- Color-coded bands (green/yellow/orange/red) tied to WBT ranges + activity level guidance (rest vs. light activity vs. exertion)
- Maybe a simple flag like “evaporative cooling impaired” when WBT crosses ~28°C
- Acknowledge it’s not WBGT—works best for shade/indoor contexts or as a conservative outdoor estimate

You’re not overhyping it. It’s a genuinely underutilized metric for public communication. The main risk is false precision—people treating it as definitive when individual factors still matter. But as a quick glance “should I be more careful today?” indicator, it’s solid.

Want to dig into the formula options and API approach for pulling the data?​​​​​​​​​​​​​​​​