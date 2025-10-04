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
<img width="1179" height="2556" alt="simulator_screenshot_1903BE4C-7BA8-4118-809E-EE8672938601" src="https://github.com/user-attachments/assets/3b6d7ac1-355b-4131-b1a2-6c1c38e775c1" />


<img width="1179" height="2556" alt="simulator_screenshot_FB2F49FA-0C83-476B-A38D-A65C9143C3CC" src="https://github.com/user-attachments/assets/6dbb2fe8-90ee-466b-a07a-f43a4732a862" />
