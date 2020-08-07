//
//  FontIcon.swift
//  SwiftyFontIcon
//
//  Created by Mohaned Benmesken on 7/26/20.
//

import Foundation
public struct FontIcon {
    
    public let name:String
    public var localizable:Bool = false
    
    public  init(name:String,localizable:Bool = false) {
        self.name = name
        self.localizable = localizable
    }
    
    public func localized() -> FontIcon {
        FontIcon(name: name,localizable: true)
    }
    
}
