//
//  Factories.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension NSParagraphStyle {
    static var justifiedParagraphStyle: NSParagraphStyle {
        let paragraphStlye = NSMutableParagraphStyle()
        paragraphStlye.alignment = .justified
        return paragraphStlye
    }
}

extension NSShadow {
    static var titleTextShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 3.0
        return shadow
    }

    static var descriptionTextShadow: NSShadow {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 3.0
        
        return shadow
    }
}

extension NSAttributedString {
    convenience init(forTitleText text: String) {
        
        let titleAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont(name: "AvenirNext-Heavy", size: 30)!,
            .foregroundColor: UIColor.white,
            .shadow: NSShadow.titleTextShadow,
            .paragraphStyle: NSParagraphStyle.justifiedParagraphStyle
        ]

        self.init(string: text, attributes: titleAttributes)
    }
    
    convenience init(forDescription text: String) {
        let descriptionAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont(name: "AvenirNext-Medium", size: 16)!,
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.clear,
            .shadow: NSShadow.descriptionTextShadow,
            .paragraphStyle: NSParagraphStyle.justifiedParagraphStyle
        ]
        
        self.init(string: text, attributes: descriptionAttributes)
    }

    convenience init(string: String, fontSize size: CGFloat, color: UIColor?) {
        let attributes = [
            NSAttributedStringKey.foregroundColor: color ?? UIColor.black,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: size)
        ]
        self.init(string: string, attributes: attributes)
    }
}

extension UIColor {
    static var darkBlue: UIColor {
        return UIColor(red: 18.0/255.0, green: 86.0/255.0, blue: 136.0/255.0, alpha: 1)
    }

    static var lightBlue: UIColor {
        return UIColor(red: 0, green: 122.0/255.0, blue: 1, alpha: 1)
    }
}

extension UIImage {
    func makeCircularImage(with size: CGSize, withBorderWidth width: CGFloat) -> UIImage {
        // make a CGRect with the image's size
        
        let circleRect = CGRect(origin: .zero, size: size)

        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)
        
        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.width/2)
        
        // clip to the circle
        circle.addClip()

        UIColor.white.setFill()
        circle.fill()

        // draw the image in the circleRect *AFTER* the context is clipped
        draw(in: circleRect)

        // create a border (for white background pictures)
        if width > 0 {
            circle.lineWidth = width
            UIColor.white.setStroke()
            circle.stroke()
        }

        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()

        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext()

        return roundedImage ?? self
    }

    func corner(with radius: CGFloat) -> UIImage? {

        var modifiedImage: UIImage?
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
        
        draw(in: rect)
        
        modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return modifiedImage
    }
}

