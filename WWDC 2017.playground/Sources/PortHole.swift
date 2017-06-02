import Foundation
import UIKit

public class PortHole : UIView {
    var portHoleContent : UIImageView
    
    public init(point: CGPoint, width: CGFloat,  planet: Planets){
        portHoleContent = UIImageView(frame: CGRect(x: 50, y: 50, width: width - 100, height: width - 100))
        portHoleContent.image = UIImage(named: planet.rawValue + "-Real.jpeg")
        
        super.init(frame: CGRect(origin: point, size: CGSize(width: width, height: width)))
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = frame.size.width/2
        portHoleContent.layer.cornerRadius = portHoleContent.frame.size.width/2
        portHoleContent.layer.masksToBounds = true
        
        addSubview(portHoleContent)
        addRivets()
    }
    
    
    
    
    
    private func addRivets(){
        let twoPi = 2 * M_PI
        let angle = twoPi/8
        let radius = (portHoleContent.bounds.width + 50) / 2

        
        for i in 0..<8 {
            let rivet = CALayer()
            rivet.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            rivet.backgroundColor = UIColor.white.cgColor
            rivet.shadowOffset = CGSize(width: 5.0, height: 5.0)
            rivet.shadowColor = UIColor.black.cgColor
            rivet.shadowRadius = 10.0
            rivet.shadowOpacity = 1.0
            rivet.cornerRadius = rivet.bounds.width/2
            
            let point = calculateCoordinate(hypot: Double(radius), theta: angle * Double(i))
            
            rivet.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            rivet.position = point
            
            layer.addSublayer(rivet)
        }
        
    }
    
    private func calculateCoordinate(hypot: Double, theta: Double) -> CGPoint
    {
        let center = self.portHoleContent.center
        
        let dX = sin(theta) * hypot
        let dY = cos(theta) * hypot
        
        let x = center.x + CGFloat(dX)
        let y = center.y + CGFloat(dY)
        
        return CGPoint(x: x, y: y)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
