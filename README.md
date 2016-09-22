# KUITagLabel
> TagLabel support for Dynimc height

![alt tag](ScreenShot/Sample.png)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

#### CocoaPods
KUITagLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KUITagLabel"
```

## Usage

#### KUITagLabel
```Swift 
import KUITagLabel

let config = KUITagConfig(titleColor: UIColor.magentaColor(),
                          titleFont: UIFont.boldSystemFontOfSize(15.0),
                          ...)
                          
tagLabel.add(KUITag(title: "#테스트", config: config))
tagLabel.add(KUITag(title: "#테스트1", config: config))
tagLabel.refresh()
        

```

## Authors

Taeun Kim (kofktu), <kofktu@gmail.com>

## Requirements

- iOS 8.0+
- Xcode 8.0
- Swift 2.3

## License

KUIActionSheet is available under the ```MIT``` license. See the ```LICENSE``` file for more info.
