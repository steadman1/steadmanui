# steadmanui

## Installation
Follow the instructions at Adding Package Dependencies to Your App to find out how to install the Swift package. Use the link of this GitHub repo as the URL (https://github.com/steadman1/steadmanui).

# Usage

## New Navigation Bar - Example

```swift
// navigation items with dynamic image (from -> unselected; to -> selected)
let navigationItems = [
    NavigationItem(name: "View One",
                   from: Image(systemName: "image_path"),
                   to: Image(systemName: "image_path.fill")),
    NavigationItem(name: "View Two",
                   from: Image(systemName: "..."),
                   to: Image(systemName: "...")),
    ...
]
// OR
// navigation items with constant image
let navigationItems = [
    NavigationItem(name: "View One",
                   icon: Image("..."),
    NavigationItem(name: "View Two",
                   icon: Image("...)),
    ...
]

CustomNavigationBar(items: navigationItems) {
    ViewOne()
    ViewTwo()
    ...
}
```

