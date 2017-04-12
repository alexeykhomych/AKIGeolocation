# IDPRootViewGettable
  
This is simple protocol and UIViewController extension which allow reducing code duplication when you use custom root view for UIViewController.

So instead of writing
```swift
let mView = self.view as? RootView
myView.titleLabel.text = "Some awesome text"
```

you write
```swift
self.rootView?.titleLabel.text = "Some awesome text"
```

## Requirements

iOS 9+.
Swift 3.0.

## Dependency

[IDPCastable](https://github.com/idapgroup/IDPCastable)

## Example

To run the example project, clone the repo, and run pod install from the Tests/iOS directory first.

## Installation

IDPRootViewGettable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "IDPRootViewGettable"
```

IDPRootViewGettable is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "idapgroup/IDPRootViewGettable"
```

## Author

Artem Chabannyi, artem.chabanniy@idapgroup.com

## License

IDPRootViewGettable is available under the New BSD license. See the LICENSE file for more info.
