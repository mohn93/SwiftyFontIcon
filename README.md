# SwiftyFontIcon

[![CI Status](https://travis-ci.org/mohn93/SwiftyFontIcon.svg?branch=master)](https://travis-ci.org/mohn93/SwiftyFontIcon)
[![Version](https://img.shields.io/cocoapods/v/SwiftyFontIcon.svg?style=flat)](https://cocoapods.org/pods/SwiftyFontIcon)
[![License](https://img.shields.io/cocoapods/l/SwiftyFontIcon.svg?style=flat)](https://cocoapods.org/pods/SwiftyFontIcon)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyFontIcon.svg?style=flat)](https://cocoapods.org/pods/SwiftyFontIcon)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftyFontIcon is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyFontIcon'
```

## Usage

+ Initialize SwfIcon before you use it:

  - (Recommend)In your AppDelegate, add line
  ```swift
  import SwiftyFontIcon
  .............
  SwfIcon.instance.loadAllAsync()
  ```
  OR
  - Before you use the icon, initialize it in sync way:
  ```swift
  import SwiftyFontIcon

  .............
  SwfIcon.instance.loadAllSync()
  //Now you can start using it
  SwfIcon.instance.getUIImage(......)
  ```
  YOU ONLY NEED TO DO THE INITIALIZATION ONCE AFTER YOUR APP STARTS
  
+ Get iconic string or generate an image from the icon:

  ```swift
  //Get NSAttributedString, the "gm-games" is the name of Google Material Design's "games" icon
  let iconicString = SwfIcon.instance.getNSMutableAttributedString("gm-games", fontSize: 10)
  //Set it to label, to button, or whatever place you like
  label.attributedText = iconicString
  
  //Get UIImage, "fa-heart" is the "Heart" icon from FontAwesome
  let iconicImage = SwfIcon.instance.getUIImage("fa-heart", iconSize: 100, iconColour: UIColor.blueColor(), imageSize:   CGSizeMake(200, 200))
  //Set it to UIImageView
  imgView.image = iconicImage
  // OR
  imgView.image = .icon(FAFontIcon.faHeart)

  ```

    OR If you wanna more readable and clean way:

  ```swift
  //FAFontIcon is a class that i generated contains predefined static FontIcon Objects
  imgView.image = .icon(FAFontIcon.faHeart, size: 100)
  // OR
  imgView.image = .icon(FontIcon(name: "fa-ad"), size: 100)
  // And for the color it changes based on image view tintColor
  imgView.tintColor = .blue

  ```

## Icon Name Mapping

The built-in icons are from 
+ [Google Material Design Icons](https://www.google.com/design/icons/)
  - All the Google Material Icons are prefixed with "**gm-**" following with the real icon names from the above link. For example, ["gm-account_balance_wallet"](https://www.google.com/design/icons/#ic_account_balance_wallet) is the name for "account_balance_wallet" icon.
+ [FontAwesome](http://fortawesome.github.io/Font-Awesome/icons/)
  - All the FontAwesome Icons are prefixed with "**fa-**" following with the icon name of FontAwesome. For example, ["fa-dashcube"](http://fortawesome.github.io/Font-Awesome/icon/dashcube/) is the name for "dashcube" icon of FontAwesome.

And just give SwfIcon the icon name you want to render and SwfIcon will handle everything else for you.

## Add Your Own Icon Fonts
Let's say you have your own icon font(which can reduce the app size compare to including the resource images for different sizes) you want to be displayed in your iOS project, you only need to:
```swift
//BEFORE you call SwfIcon init

//The font name prefix you want to use. For example, if you set it to "custom" and SwfIcon see an icon name start with "custom-", then it will know it's a custom font.
let customFontPrefix = "custom"

//Copy the ttf font file into your project and give SwfIcon the font file name (WITHOUT the ".ttf" extension)
let fontFileName = "custom_font" //Then SwfIcon will try to load the font from "custom_font.ttf" file

//The Font File Name, the fontName of your font. (The font name after you install the ttf into your system)
let fontName = "Custom"

//The icon name/value mapping dict ([FONT_NAME: FONT_UNICODE_VALUE])
let iconNameValueMappingDict = ["custom-1":"\u{f000}",...]

//Add custom font to SwfIcon
SwfIcon.instance.addCustomFont(prefix: customFontPrefix, fontFileName: fontFileName, fontName: fontName, fontIconMap: iconNameValueMappingDict)

//Then init SwfIcon
SwfIcon.instance.loadAllAsync() //Or Sync, depends on your needs
```

If you need to automate maping these things and create a strongly typed icons to use with `.icon(...)` syntax, you can take a look at this tool https://swiftyicongen.herokuapp.com

## How to use SwiftyIconGenerator to generate you oun custom font
* Open https://swiftyicongen.herokuapp.com, you'll be presented with list of pre-existing icons you can select from them or you can drag and drop you own SVG icon files.
* After that name the class of your icons, this should be a valid swift class name.
* Then click on download, you will recieve a zip file that contains three files:
  * `config.json`
  * `{class_name}_icons.swift`
  * `{class_name}.ttf`
* Take all of these files and copy them into your project target.
* Then call this method `setupIconFont()` befor you load fonts in your `AppDelegate.swift`.
* You are good to go now you can use your icons in your project like this `imgView.image = .icon({class_name}.myIcon, size: 100)`

## Requirements
iOS 10 or later.
Swift 4 

## Author

mohn93, mohn93@gmail.com

## License

SwiftyFontIcon is available under the MIT license. See the LICENSE file for more info.
