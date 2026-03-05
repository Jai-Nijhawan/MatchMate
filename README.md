# MatchMate - Matrimonial Card Interface (iOS)

MatchMate is an iOS app that simulates a matrimonial app by displaying match cards. Users can accept or decline matches, with all decisions persisted locally for offline access.

## Demo 
https://github.com/user-attachments/assets/c43ae254-9e13-4af5-9212-dd8616044a5f

## Features

- **API Integration**: Fetches user data from JSONPlaceholder API
- **Match Cards**: Beautiful SwiftUI card design with profile images
- **Accept/Decline**: Users can accept or decline matches with one tap
- **Local Storage**: All data persisted using SwiftData
- **Offline Mode**: App works seamlessly offline with cached data
- **MVVM Architecture**: Clean separation of concerns

## Project Structure

```
MatchMate/
├── App/
│   └── MatchMateApp.swift
│
├── Core/
│   └── APIConstants.swift
│
├── Models/
│   ├── MatchProfile.swift
│   ├── MatchStatus.swift
│   └── UserModel.swift
│
├── ViewModels/
│   ├── MatchCardViewModel.swift
│   └── MatchListViewModel.swift
│
├── Views/
│   ├── ContentView.swift
│   ├── MatchCardView.swift
│   └── MatchListView.swift
│
├── Services/
│   ├── NetworkMonitor.swift
│   ├── NetworkService.swift
│   └── UserService.swift
│
└── Resources/
    └── Assets.xcassets
```

## Dependencies

- **SDWebImageSwiftUI**: For async image loading
- **SwiftData**: Local database persistence
- **Combine**: Reactive data flow

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

- **Models**: Data structures for API response and persistence
- **ViewModels**: Business logic and state management
- **Views**: SwiftUI views for UI rendering
- **Services**: Network and data layer abstraction

## Installation

1. Clone the repository
2. Open `MatchMate.xcodeproj` in Xcode
3. Add SDWebImageSwiftUI via Swift Package Manager:
   - `File → Add Package Dependencies`
   - Repository: `https://github.com/SDWebImage/SDWebImageSwiftUI`
4. Build and run

## API

The app fetches user data from:
- **Endpoint**: `https://jsonplaceholder.typicode.com/users`
- **Profile Images**: Generated using `https://i.pravatar.cc/300?u={id}`

## Data Flow

1. App launches → Check network connectivity
2. If online → Fetch users from API → Save to SwiftData → Display
3. If offline → Load from SwiftData cache → Display
4. User accepts/declines → Update SwiftData → Update UI

## Error Handling

All error messages are centralized in `MatchErrorMessage` enum for consistent error display across the app.

## License

This project is for demonstration purposes.
