# Dogs

This App displays images of Dogs based on their breed. The user can search for a particular breed and images for that breed will be displayed. This app uses 'https://dog.ceo/dog-api/' to get the list of breeds as well as thier images.

## Environment 

- Xcode: 9.4.1
- iOS Target: 11.4
- Language: Swift 4.1.2
- Cocoapods: 1.5.3

## Installation Instructions

To install Cocoapods (in case they are not present) run the following:

- `sudo gem install cocoapods` or
- `brew install cocoapods`

To build the project:

- Run `pod install` in the project directory
- Open workspace reviews.xcworkspace
- Run in simulator

## Assumptions

The app assumes that the list of dog breeds will not change and therefore has preloaded them into its file system. The user can only search for breeds that are already included in this list of dog breeds.

## Technical choices

 The app tries to follow typical MVVM pattern. I preferred to go with MVVM to show that i am interested in new trends of programming, and i am always trying to learn new things. 
 
 ### Notable features
  - Preloaded list of breeds that are displayed when the user taps the search bar. Typing in the search bar filters the list. I decided to do this because a typical user, like myself, may not know what breeds to search for. Moreover, it also avoids making API calls on invalid endpoints.
  - Extending on the previous point, a free text search cannot be done. Whenever a user asks to search for a string (without tapping one of the recommended completions), the first result of the filtered results is searched for instead. If there are no filtered results, then no search is done.
  - Images are dynamically loaded and cached

## What to add

- Make image detail view zoomable. FIX: not resizing in when orientation is changed.
- Dynamic cell sizes so that app looks more or less similar on all devices
- Read the list of dogs from the API
- Add 'Nice to haves'

### Nice to have
 - Although, one of the nice to haves was to limit 3rd party dependencies, I have used 'SwiftyJSON' to parse JSON files as doing so manually would me writing a lot of boiler plate code. ✅
 - iPhone X support ✅
 - Accessibility support
