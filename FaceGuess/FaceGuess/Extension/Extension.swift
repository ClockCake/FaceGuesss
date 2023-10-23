//
//  Extension.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/20.
//

import UIKit

extension UIColor {
    static func colorWithHexString(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // 生成随机颜色
     static func randomColor(alpha: CGFloat = 1.0) -> UIColor {
         let red = CGFloat.random(in: 0...1)
         let green = CGFloat.random(in: 0...1)
         let blue = CGFloat.random(in: 0...1)
         
         return UIColor(red: red, green: green, blue: blue, alpha: alpha)
     }
}

extension UILabel {
    static func labelLayout(text:String?, font:UIFont, textColor:UIColor, ali:NSTextAlignment, isPriority:Bool, tag:Int) -> UILabel{
        let lab = UILabel()
    //    富文本
        if (text != nil) {
            let  dic = [NSAttributedString.Key.kern : 0.0]
            let attributedString  = NSMutableAttributedString.init(string: text ?? "", attributes: dic)
            let paragraphStyle = NSMutableParagraphStyle.init()
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: text?.count ?? 0))
            lab.attributedText = attributedString
        }
        lab.textColor = textColor
        lab.font = font
        lab.textAlignment = ali
        lab.backgroundColor = .clear
        if isPriority == true {
    //        宽度
            lab.setContentCompressionResistancePriority(.required, for: .horizontal)
            lab.setContentHuggingPriority(.required, for: .horizontal)
    //        高度
            lab.setContentCompressionResistancePriority(.required, for: .vertical)
            lab.setContentHuggingPriority(.required, for: .vertical)

        }
        lab.tag = tag
        return lab
        
    }
}
