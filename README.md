# Location Tracker App

A simple Flutter application to get the user's current location and show it on Google Maps with a marker.  
The app also supports **Dark/Light mode switching** using Provider state management.

## Features

- Get current location (lat/lng)
- Show location on Google Map
- Light / Dark theme toggle
- Provider state management
- Material 3 UI
- Clean architecture (MVVM)

## Project Structure

lib/
│
├─ viewmodels/
│ ├─ location_viewmodel.dart
│ └─ theme_viewmodel.dart
│
├─ views/
│ └─ home_view.dart
│
└─ main.dart

## Tech Stack

- **Flutter**
- **Provider**
- **Google Maps**
- **Material 3**

## Future Improvements

- Draw route polyline inside the app
- Live location updates
- Location history tracking
- Custom map styles

## How My Experience Helped

I previously worked on UI development, state management, and basic REST API usage in Flutter projects. That experience helped me in:

### ✔ Separating UI and Logic

I used MVVM:

- `ViewModels` handle location fetching and theme switching
- `Views` only render UI

This made the code easier to maintain.

### ✔ Using Provider for State Management

I already had experience using Provider in previous projects. So managing location updates and theme mode was simple using `ChangeNotifier`.

### ✔ Understanding Permissions & Maps

I had worked with mobile permissions (camera/storage) before. So implementing location permissions, error handling, and fallback UI felt natural.

### ✔ Time-Efficient Approach

Instead of spending time on drawing polylines and enabling Google Directions API (which requires billing), I used the Google Maps URL scheme. This helped build a working app faster while still showing navigation professionally.

---

## Conclusion

This project strengthened my understanding of:

- Location APIs
- App permissions
- Map navigation
- State management with Provider
- Clean structure using MVVM

The app can be extended in the future to draw routes inside the app using Google Directions API and polyline decoding, but for now it provides a lightweight and user-friendly navigation experience.

## Author

- Muthuraman S
- Flutter Developer
- Coimbatore, India
