import UIKit

extension UIColor {
    public static func color(hex: String, alpha:CGFloat? = 1.0) -> UIColor {
        var hexInt: UInt32 = 0
        
        let scanner: Scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let hexint = Int(hexInt)
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
    
    public static func random() -> UIColor {
        let r = CGFloat(arc4random_uniform(255))
        let g = CGFloat(arc4random_uniform(255))
        let b = CGFloat(arc4random_uniform(255))
        
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).cgColor as AnyObject
    }
}

extension Int {
    func rand() -> Int {
        return Int((arc4random_uniform(UInt32(self))))
    }
}
