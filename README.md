# Movie App

## Tech Stack

- Language - Swift
- Framework - Swift UI
- Architecture - MVVM 
- Concurrency - Modern async / await 
- Local storage - Core data
- Minimum Target - 16.0 (In Swift UI is highly recommended to have atleast 16.0)


## Architectural Overview

    MovieApp/
    ├── Core/
    │   ├── Network/
    │   ├── Persistence/
    │   └── Extensions/
    ├── Models/
    ├── Services/
    ├── ViewModels/
    ├── Views/
    │   ├── MovieList/
    │   ├── MovieDetail/
    │   └── Components/
    └── App/



## Addional Features

- Pagination support added
- Orientation support added
- Dark mode support added
- Basic iPad Support added
- Pull to refresh added
- Debounce for search added
- Automatic retry Mechanism implemented on API call failure


## Area of Improvements

- Caching mechanism for images 
- Prefetch mechanism in listing
- Repository pattern for local database / offline handling
- KeyChain to store the API keys
- Split view Support for iPad
- Localization / Accessability support
- Reduce the unintended re-renders in Swift UI to improves performance 


NOTE: 
- Used Web view to load the video since youtube video not supported in AVPlayer

## Screen Shots

<p align="center">
  <img src="https://github.com/user-attachments/assets/44a2a32e-dd28-4b9d-a386-bd50389bb78b" width="45%" />
  <img src="https://github.com/user-attachments/assets/fbdf2155-135e-4729-ae63-e69dad23d095" width="45%" />
</p>
