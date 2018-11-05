JYSlideSegmentController
========================

![pods](https://img.shields.io/cocoapods/v/JYSlideSegmentController.svg)
![platforms](https://img.shields.io/badge/platforms-iOS-orange.svg)
![language](https://img.shields.io/badge/languages-ObjC-orange.svg)
![total-downloads](https://img.shields.io/cocoapods/dt/JYSlideSegmentController.svg?label=Total%20Downloads&colorB=28B9FE)
![app-using](https://img.shields.io/cocoapods/at/JYSlideSegmentController.svg?label=app-using&colorB=28B9FE)
![license](https://img.shields.io/cocoapods/l/JYSlideSegmentController.svg)


JYSlideSegmentController is a view controllers container, just like the UITabBarController, with smooth gesture.

### Demo

<img src="./demo.gif" width="320">

### Installation with CocoaPods

Podfile

```ruby
platform :ios, '8.0'
pod "JYSlideSegmentController"
```

## License

JYSlideSegmentController is available under the MIT license. See the LICENSE file for more info.

## ChangeLog

2.0.3

- Fix selectedIndex KVO bug

2.0.2

-  fix indicator layout

2.0.1

- fix bug of start index

2.0.0 

- refract slide view to collection view;
- update logic of indicator and animation;
- add slideViewMovingProgress:fromIndex:toIndex: delegate method

1.3.7

- Fix crash & logic of handling orientation notification
