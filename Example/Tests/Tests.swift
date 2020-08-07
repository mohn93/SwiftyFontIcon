// https://github.com/Quick/Quick

import Quick
import Nimble
import SwiftyFontIcon
import InstantMock
import UIKit

extension CGFloat :MockUsable {
    
    public static var anyValue: MockUsable {
        0
    }
    
    public func equal(to value: MockUsable?) -> Bool {
        guard let value = value as? CGFloat else { return false }
        return self == value
    }
    
}

class SwfFontIconSpec: QuickSpec {
    override func spec() {
        
        describe("UI image view") {
            it("gets new Localized Icon") {
                let icon = FontIcon(name: "icon")
                expect(icon.localized().localizable) == icon.localized().localizable
            }
        }
        
        describe("font icon class") {
            it("gets new Localized Icon") {
                SwfIcon.instance.loadAllSync()
                let icon = FontIcon(name: "icon")
                expect(icon.localized().localizable) == icon.localized().localizable
            }
            
            it("gets new localized and the layout is rtl empty UIImage") {
                SwfIcon.instance.loadAllSync()
                let directionProvider = DirectionProviderMock()
                directionProvider.it.stub().call(directionProvider.isRtl()).andReturn(true)
                let icon:UIImage = .icon(FontIcon(name: "icon").localized(), directionProvider: directionProvider)
                expect(icon.isEqual(UIImage())) == true
            }
            it("gets new localized and the layout is not rtl empty UIImage") {
                SwfIcon.instance.loadAllSync()
                let directionProvider = DirectionProviderMock()
                directionProvider.it.stub().call(directionProvider.isRtl()).andReturn(false)
                let icon:UIImage = .icon(FontIcon(name: "icon").localized(), directionProvider: directionProvider)
                expect(icon.isEqual(UIImage())) == true
            }
            
            it("gets new UIImage from fa icons") {
                SwfIcon.instance.loadAllSync()
                let icon:UIImage = .icon(FAFontIcons.faAd)
                expect(icon.isEqual(UIImage())) != true
            }
            
            it("gets new UIImage from gm icons") {
                
                SwfIcon.instance.loadAllSync()
                
                let icon:UIImage = .icon(MDFontIcon.ac_Unit)
                expect(icon.isEqual(UIImage())) != true
            }
        }
        
        describe("font loading") {
            
            it("loads fonts successfully") {
                let mockDelegate = SwfDelegateMock()
                
                SwfIcon.instance.delegate = mockDelegate
                
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("gm"))
                )
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("fa"))
                )
                
                SwfIcon.instance.loadAllSync()
                
                mockDelegate.verify()
            }
            
//            it("loads fonts async successfully") {
//                let mockDelegate = SwfDelegateMock()
//
//                SwfIcon.instance.delegate = mockDelegate
//
//                mockDelegate.expect().call(
//                    mockDelegate.onFontLoaded(fontName: Arg.eq("gm"))
//                )
//                mockDelegate.expect().call(
//                    mockDelegate.onFontLoaded(fontName: Arg.eq("fa"))
//                )
//                
//                SwfIcon.instance.loadAllAsync()
//                waitUntil(timeout: 1) { (done) in
//                    mockDelegate.verify()
//                    done()
//                }
//            }
            it("loads specific fonts async successfully") {
                let mockDelegate = SwfDelegateMock()
                
                SwfIcon.instance.delegate = mockDelegate
                
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("gm"))
                )
                mockDelegate.reject().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("fa"))
                )
                
                SwfIcon.instance.loadAllAsync(["gm"])
                waitUntil(timeout: 1) { (done) in
                    mockDelegate.verify()
                    done()
                }
            }
            
            it("loads specific fonts successfully") {
                let mockDelegate = SwfDelegateMock()
                
                SwfIcon.instance.delegate = mockDelegate
                
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("gm"))
                )
                mockDelegate.reject().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("fa"))
                )
                
                SwfIcon.instance.loadAllSync(["gm"])
                mockDelegate.verify()
            }
            
            it("loads fonts with custom one successfully") {
                let mockDelegate = SwfDelegateMock()
                
                SwfIcon.instance.delegate = mockDelegate
                
                let mockFontLoader = FontLoaderMock()
                mockFontLoader.it.stub().call( mockFontLoader.loadFontFromFile(Arg.any(), isCustom: Arg.any())).andReturn(true)
                
                SwfIcon.instance.addCustomFont("cs", fontFileName: "Test Font", fontName: "Font", fontIconMap: ["":""],fontLoader:mockFontLoader)
                
                mockFontLoader.it.expect().call(
                    mockFontLoader.loadFontFromFile(Arg.any(), isCustom: Arg.any())
                )
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("gm"))
                )
                
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("fa"))
                )
                mockDelegate.expect().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("cs"))
                )
                
                SwfIcon.instance.loadAllSync()
                
                mockDelegate.verify()
            }
            
            it("fails loading fonts") {
                let mockDelegate = SwfDelegateMock()
                
                SwfIcon.instance.delegate = mockDelegate
                
                let mockFontLoader = FontLoaderMock()
                mockFontLoader.it.stub().call( mockFontLoader.loadFontFromFile(Arg.any(), isCustom: Arg.any())).andReturn(false)
                SwfIcon.instance.addCustomFont("cs", fontFileName: "Test Font", fontName: "Font", fontIconMap: ["":""],fontLoader:mockFontLoader)
                
                mockFontLoader.it.reject().call(
                    mockFontLoader.loadFontFromFile(Arg.any(), isCustom: Arg.any())
                )
                
                mockDelegate.reject().call(
                    mockDelegate.onFontLoaded(fontName: Arg.eq("cs"))
                )
                
                SwfIcon.instance.loadAllSync()
                
                mockDelegate.verify()
            }
        }
    }
}

// MARK: SwfDelegateMock class inherits from `Mock` and adopts the `SwfIconDelegate` protocol
class SwfDelegateMock: Mock, SwfIconDelegate {
    func onFontLoaded(fontName:String){
        super.call(fontName)
    }
}

// MARK: FontLoaderMock class inherits from `FontLoader` and adopts the `MockDelegate` protocol
class FontLoaderMock: FontLoader, MockDelegate {
    
    // create `Mock` delegate instance
    private let mock = Mock()
    
    var mustSucced = true
    
    // conform to the `MockDelegate` protocol, by providing the `Mock` instance
    var it: Mock {
        return mock
    }
    
    override func loadFontFromFile(_ fontFileName: String, isCustom: Bool) -> Bool{
        return mock.call(fontFileName,isCustom)!
    }
    

    override func getFont(name: String, size: CGFloat) -> UIFont? {
        return mock.call(name,size)
    }
}

// MARK: DirectionProviderMock class inherits from `DirectionProviderMock` and adopts the `MockDelegate` protocol
class DirectionProviderMock: DirectionProvider, MockDelegate {
    
    // create `Mock` delegate instance
    private let mock = Mock()
    
    var mustSucced = true
    
    // conform to the `MockDelegate` protocol, by providing the `Mock` instance
    var it: Mock {
        return mock
    }
    
    override func isRtl() -> Bool {
        return mock.call()!
        
    }
}
