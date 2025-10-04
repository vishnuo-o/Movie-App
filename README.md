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

<p>
<img width="1179" height="2556" alt="simulator_screenshot_85E1744D-34A7-4439-BD77-F3E028FC9D18" src="https://github.com/user-attachments/assets/44a2a32e-dd28-4b9d-a386-bd50389bb78b" />
<img width="1179" height="2556" alt="simulator_screenshot_B7C845E2-0FEB-4FC5-BEE6-40F1539B80BA" src="https://github.com/user-attachments/assets/fbdf2155-135e-4729-ae63-e69dad23d095" />
</p>
