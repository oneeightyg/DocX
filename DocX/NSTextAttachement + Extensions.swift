//
//  NSTextAttachement + Extensions.swift
//  DocX
//
//  Created by Morten Bertz on 2021/03/23.
//  Copyright © 2021 telethon k.k. All rights reserved.
//

import Foundation
#if canImport(AppKit)
import Cocoa
#elseif canImport(UIKit)
import UIKit
#endif
import AEXML

extension NSTextAttachment{
    
    struct Size {
        let width:Int
        let height:Int
        
        var extentAttribute:AEXMLElement{
            return AEXMLElement(name: "wp:extent", value: nil, attributes: self.extentAttributes)
        }
        var extentAttributes:[String:String]{
            return ["cx":String(width), "cy":String(height)]
        }
    }
    
    @available(OSX 10.11, *)
    var imageData: Data?{
        if let imageData=self.image?.pngData{
            return imageData
        }
        else{
            return self.contents
        }
    }
    
    #if canImport(AppKit)
    var dataImageSize:CGSize{
        guard let data=self.contents,
              let image=NSImage(data: data)
        else {return .zero}
        return image.size
    }
    #else
    var dataImageSize:CGSize{
        guard let data=self.contents,
              let image=UIImage(data: data)
        else {return .zero}
        return image.size
    }
    
    #endif
    
    var extentInEMU:Size{
        let width:CGFloat
        let height:CGFloat
        if let image=image{
            width=image.size.width
            height=image.size.height
        }
        else{
            let dataImageSize=dataImageSize
            width=dataImageSize.width
            height=dataImageSize.height
        }
        
        let emuPerInch=CGFloat(914400)
        let dpi=CGFloat(72)
        let emuWidth=width/dpi*emuPerInch
        let emuHeight=height/dpi*emuPerInch
        return Size(width: Int(emuWidth), height: Int(emuHeight))
        
    }
    
    var extentAttributes:[AEXMLElement]{
        let size=self.extentInEMU
        let extent=size.extentAttribute
        let effectiveExtent=AEXMLElement(name: "wp:effectExtent", value: nil, attributes: ["l":"0", "t":"0","r":"0","b":"0"])
        return [extent,effectiveExtent]
    }
}
