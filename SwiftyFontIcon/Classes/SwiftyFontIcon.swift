//
//  SwiftyFontIcon.swift
//  Nimble
//
//  Created by Mohaned Benmesken on 7/23/20.
//

import Foundation

import UIKit
import CoreText
import Dispatch

open class DirectionProvider {
    public init(){}
    open func isRtl()->Bool{
        let locale = NSLocale.autoupdatingCurrent
        let lang = locale.languageCode
        let direction = NSLocale.characterDirection(forLanguage: lang!)
        return direction == NSLocale.LanguageDirection.rightToLeft
    }
}

extension UIImage {
    public static func icon(_ icon: FontIcon, size: CGFloat = 24,directionProvider:DirectionProvider = DirectionProvider()) -> UIImage {
        let image = SwfIcon.instance.getUIImage(icon.name, iconSize: size, imageSize: CGSize(width: size, height: size), renderingMode: .alwaysTemplate)
        if icon.localizable {
            if directionProvider.isRtl(){
                if let cgImage = image.cgImage {
                    return UIImage(cgImage: cgImage, scale: 1.0, orientation: .downMirrored)
                } else {
                    return image
                }
            }else{
                return image
            }
        }else{
            return image
        }
    }
}

extension NSMutableAttributedString {
    public static func attributedIcon(_ icon: FontIcon, size: CGFloat = 24) -> NSMutableAttributedString? {
        let attr = SwfIcon.instance.getNSMutableAttributedString(icon.name, fontSize: size)
        return attr
    }
}

public protocol SwfIconDelegate{
    func onFontLoaded(fontName:String )
}

open class SwfIcon {
    
    public static let instance = SwfIcon()
    
    public var delegate:SwfIconDelegate?
    public var generalFontLoader:FontLoader = FontLoader()
    
    fileprivate let load_queue = DispatchQueue(label: "com.swficon.font.load.queue", attributes: [])
    
    fileprivate lazy  var fontsMap :[String: IconFont] = [
        "fa": FontAwesomeIconFont(),
        "gm": GoogleMaterialIconFont()
    ]
    
    fileprivate init() { }
    
    open func addCustomFont(_ prefix: String,
                            fontFileName: String,
                            fontName: String,
                            fontIconMap: [String: String],
                            fontLoader:FontLoader = FontLoader()) {
        
        fontsMap[prefix] = CustomIconFont(fontFileName: fontFileName,
                                          fontName: fontName,
                                          fontMap: fontIconMap,
                                          fontLoader: fontLoader)
    }
    
    open func loadAllAsync() {
        self.load_queue.async(execute: {
            self.loadAllSync([String](self.fontsMap.keys))
        })
    }
    
    open func loadAllAsync(_ fontNames:[String]) {
        self.load_queue.async(execute: {
            self.loadAllSync(fontNames)
        })
    }
    
    open func loadAllSync() {
        self.loadAllSync([String](fontsMap.keys))
    }
    
    open func loadAllSync(_ fontNames:[String]) {
        for fontName in fontNames {
            if let font = fontsMap[fontName] {
                font.loadFontIfNecessary()
                if font.fontLoaded {
                    delegate?.onFontLoaded(fontName: fontName)
                }
            }
        }
    }
    
    open func getNSMutableAttributedString(_ iconName: String, fontSize: CGFloat) -> NSMutableAttributedString? {
        for fontPrefix in fontsMap.keys {
            if iconName.hasPrefix(fontPrefix) {
                let iconFont = fontsMap[fontPrefix]!
                if let iconValue = iconFont.getIconValue(iconName) {
                    let iconUnicodeValue = iconValue.substring(to: iconValue.index(iconValue.startIndex, offsetBy: 1))
                    if let uiFont = iconFont.getUIFont(fontSize) {
                        let attrs = [NSAttributedString.Key.font : uiFont]
                        return NSMutableAttributedString(string:iconUnicodeValue, attributes:attrs)
                    }
                }
            }
        }
        return nil
    }
    
    open func getUIImage(_ iconName: String, iconSize: CGFloat, iconColour: UIColor = UIColor.black, imageSize: CGSize, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.natural
        style.baseWritingDirection = NSWritingDirection.natural
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0);
        let attString = getNSMutableAttributedString(iconName, fontSize: iconSize)
        if attString != nil {
            attString?.addAttributes([NSAttributedString.Key.foregroundColor: iconColour, NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, attString!.length))
            // get the target bounding rect in order to center the icon within the UIImage:
            let ctx = NSStringDrawingContext()
            let boundingRect = attString!.boundingRect(with: CGSize(width: iconSize, height: iconSize),
                                                       options: [NSStringDrawingOptions.usesDeviceMetrics,NSStringDrawingOptions.usesFontLeading ,NSStringDrawingOptions.usesLineFragmentOrigin],
                                                       context: ctx)
            let rectToDrawIn = CGRect(
                x: imageSize.width / 2 - boundingRect.width/2,
                y: 0,
                width: imageSize.width,
                height: imageSize.height)
            
            attString!.draw(with: rectToDrawIn,options: [.usesLineFragmentOrigin,.usesFontLeading],context: ctx)
            
            var iconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if((iconImage?.responds(to: #selector(UIImage.withRenderingMode(_:)))) != nil){
                iconImage = iconImage?.withRenderingMode(renderingMode)
            }
            return iconImage!
        } else {
            return UIImage()
        }
    }
}

private class FontAwesomeIconFont: IconFont {
    
    fileprivate let fontMap = FONT_AWESOME_ICON_MAPS
    fileprivate let fontFileName = "fontawesome"
    fileprivate let fontName = "FontAwesome"
    var fontLoadAttemted: Bool = false
    var fontLoaded: Bool = false
    var fontLoader:FontLoader = FontLoader()
    
    func loadFontIfNecessary() {
        if (!self.fontLoadAttemted) {
            self.fontLoadAttemted = true
            self.fontLoaded = fontLoader.loadFontFromFile(fontFileName, isCustom: false)
        }
    }
    
    func getUIFont(_ fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoaded) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(_ iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private class GoogleMaterialIconFont: IconFont {
    
    fileprivate let fontMap = GOOGLE_MARTERIAL_ICON_MAPS
    fileprivate let fontFileName = "gmdicons"
    fileprivate let fontName = "Material Icons"
    var fontLoadAttemted: Bool = false
    var fontLoaded: Bool = false
    var fontLoader:FontLoader = FontLoader()
    
    func loadFontIfNecessary() {
        if (!self.fontLoadAttemted) {
            self.fontLoadAttemted = true
            self.fontLoaded = fontLoader.loadFontFromFile(fontFileName, isCustom: false)
        }
    }
    
    
    func getUIFont(_ fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoaded) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(_ iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private class CustomIconFont: IconFont {
    
    fileprivate let fontFileName: String
    fileprivate let fontName: String
    fileprivate let fontMap: [String: String]
    var fontLoadAttemted: Bool = false
    var fontLoaded: Bool = false
    fileprivate let fontLoader:FontLoader
    
    init(fontFileName: String,
         fontName: String,
         fontMap: [String: String],
         fontLoader:FontLoader = FontLoader()) {
        self.fontFileName = fontFileName
        self.fontName = fontName
        self.fontMap = fontMap
        self.fontLoader = fontLoader
    }
    
    func loadFontIfNecessary() {
        if (!self.fontLoadAttemted) {
            self.fontLoadAttemted = true
            self.fontLoaded = fontLoader.loadFontFromFile(self.fontFileName, isCustom: true)
        }
    }
    
    func getUIFont(_ fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoaded) {
            return fontLoader.getFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(_ iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

open class FontLoader {
    public init(){}
    open func getFont(name:String,size:CGFloat)->UIFont?{
        return UIFont(name: name, size: size)
    }
    open  func loadFontFromFile(_ fontFileName: String, isCustom: Bool) -> Bool{
        let bundle = Bundle(for: SwfIcon.self)
        var fontURL: URL?
        let identifier = bundle.bundleIdentifier
        
        if isCustom {
            fontURL = Bundle.main.url(forResource: fontFileName, withExtension: "ttf")
        } else if identifier?.hasPrefix("org.cocoapods") == true {
            // If this framework is added using CocoaPods and it's not a custom font, resources is placed under a subdirectory
            fontURL = bundle.url(forResource: fontFileName, withExtension: "ttf", subdirectory: "SwiftyFontIcon.bundle")
        } else {
            fontURL = bundle.url(forResource: fontFileName, withExtension: "ttf")
        }
        
        if fontURL != nil {
            let data = try! Data(contentsOf: fontURL!)
            let provider = CGDataProvider(data: data as CFData)
            let font = CGFont(provider!)
            
            if (!CTFontManagerRegisterGraphicsFont(font!, nil)) {
                NSLog("Failed to load font \(fontFileName)");
                return false
            } else {
                return true
            }
        } else {
            NSLog("Failed to load font \(fontFileName) because the file \(fontFileName) is not available");
            return false
        }
    }
}

private protocol IconFont {
    var fontLoadAttemted: Bool { get set }
    var fontLoaded: Bool { get set }
    
    func loadFontIfNecessary()
    func getUIFont(_ fontSize: CGFloat) -> UIFont?
    func getIconValue(_ iconName: String) -> String?
}
