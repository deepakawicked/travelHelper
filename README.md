# JourneyLog - Interactive Road Trip Planner 

A Processing-based interactive map application for planning road trips across Ontario and Quebec with attraction scheduling and route visualization.

## Features

- **Interactive Map Navigation** - Pan and zoom across Ontario/Quebec using MapTiler street tiles
- **Smart Attraction Filtering** - Filter destinations by category, budget, and star rating
- **Route Planning** - Automatically generates driving routes between cities and attractions using OSRM API
- **Calendar Scheduling** - Create timed events for attractions with visual calendar display
- **Real-time Route Visualization** - Animated road drawing with distance and duration info

## How It Works

1. **Select Start/End Cities** - Choose from major cities in Ontario and Quebec
2. **Filter Attractions** - Use category, budget ($-$$$), and star rating sliders to find places
3. **Click Attractions** - Select attractions on the map to view details
4. **Schedule Events** - Add attractions to your calendar with custom start times and durations
5. **Generate Route** - Click "Create Map!" to generate a driving route through all scheduled stops
6. **View Route Info** - Toggle route information showing total distance and travel time

## Technical Details

- **Tile System**: Uses Web Mercator projection with zoom levels 7-9
- **Map Tiles**: Cached locally in `tilestorage/` to reduce API calls
- **Routing**: OSRM (Open Source Routing Machine) API for road path generation
- **Coordinate Systems**: Converts between lat/lon, tile coordinates, and screen pixels
- **Performance**: Frame rate capped at 30fps, tile easing at 0.25 for smooth panning

## Controls

- **Mouse Drag** - Pan the map
- **Mouse Wheel** - Zoom in/out (limited at max zoom)
- **Click Markers** - Select attractions
- **GUI Sliders** - Filter attractions by preferences

## Data Files Required

- `city.txt` - City names and coordinates
- `attraction/` folder with:
  - `attraction name.txt`
  - `attraction rating.txt`
  - `attraction category.txt`
  - `attraction price.txt`
  - `attraction position.txt`

## Libraries Used

- G4P (GUI for Processing)
- Processing core libraries

## Notes

- Map bounds: 41.0°N to 47.5°N, -84.0°W to -70.0°W
- Requires internet connection for initial tile downloads
- MapTiler API key required (not included)

---

*Created as a school project for interactive mapping and route planning*
