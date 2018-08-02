# Dogs

This App displays images of Dogs based on their breed. The user can search for a particular breed and images for that breed will be displayed. This app uses 'https://dog.ceo/dog-api/' to get the list of breeds as well as thier images.

## Environment 

- Xcode: 9.4.1
- iOS Target: 11.4
- Language: Swift 4.1
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

 - The app tries to follow typical MVVM pattern. I preferred to go with MVVM to show that i am interested in new trends of programming, and i am always trying to learn new things. 
 - Although, one of the nice to haves was to limit 3rd party dependencies, I have used 'SwiftyJSON' to parse JSON files as doing so manually would me writing a lot of boiler plate code.

## What to add

- A detailed view for viewing images in full screen when tapped
- Dynamic cell sizes so that app looks more or less similar on all devices
- Read the list of dogs from the API
