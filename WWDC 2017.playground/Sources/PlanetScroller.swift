import Foundation
import UIKit

public enum Planets : String {
    case Mercury = "Mercury"
    case Venus = "Venus"
    case Mars = "Mars"
    case Jupiter = "Jupiter"
    case Saturn = "Saturn"
    case Uranus = "Uranus"
    case Neptune = "Neptune"
    
    public static let allValues = [Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune]
    public static let planetColors = [#colorLiteral(red: 0.7174691558, green: 0.7176166177, blue: 0.7301144004, alpha: 1).cgColor, #colorLiteral(red: 0.92883569, green: 0.6890050769, blue: 0.1034137234, alpha: 1).cgColor, #colorLiteral(red: 0.9464589953, green: 0.5681663156, blue: 0.02741014957, alpha: 1).cgColor, #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1).cgColor, #colorLiteral(red: 0.8211937547, green: 0.6100826859, blue: 0.2474251091, alpha: 1).cgColor, #colorLiteral(red: 0.6223597527, green: 0.7641754746, blue: 0.78252846, alpha: 1).cgColor, #colorLiteral(red: 0.3493709266, green: 0.4712557793, blue: 0.8370745778, alpha: 1).cgColor]
}

public class Planet : CALayer {
    let label : CATextLayer
    let content : CALayer
    var selected = false
    var type : Planets
    var color : CGColor
    
    init(name: Planets, frame: CGRect) {
        
        label = CATextLayer()
        content = CALayer()
        type = name
        let index = Planets.allValues.index(of: name)!
        color = Planets.planetColors[index]
        
        super.init()
        self.frame = frame
        
  
        
        content.contents = UIImage(named: name.rawValue)!.cgImage
        content.position = CGPoint(x: bounds.midX, y: bounds.midY)
        content.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        content.bounds = CGRect(x: 0, y: 0, width:  frame.width, height: frame.height)
        content.contentsGravity =  kCAGravityResizeAspect
        content.shouldRasterize = false
     
        content.transform = CATransform3DMakeScale(0.5, 0.5, 1)
        
        
        self.addSublayer(content)
        
        let center  = CGPoint(x: 0, y: frame.height)
        label.position = center;
        label.alignmentMode = kCAAlignmentCenter
        label.anchorPoint = CGPoint(x: 0, y: 1)
        label.bounds = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        label.string = name.rawValue
        label.fontSize = 15
        label.foregroundColor = UIColor.white.cgColor
        self.addSublayer(label)
        
        
        
    }
    
    
    func setScale(scale: CGFloat) {
        content.contentsScale = scale
    }
    

    func setSelected(){
        if !selected {
            selected = true
            content.transform = CATransform3DMakeScale(0.75, 0.75, 1)
            label.fontSize = 25
            label.foregroundColor = color
        }
    }
    
    
    func setDeselected(){
        if selected {
            selected = false
            content.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            label.fontSize = 15
            label.foregroundColor = UIColor.white.cgColor
        }
    }
    
    
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



public class PlanetScroller : UIControl {
    
    private var planets : [Planet] = []
    private var indicator : CALayer
    private var planetOption : CGFloat
    public var currentPlanet : Planet!

    
    
    override public init(frame: CGRect){
        
        indicator = CALayer()

        
        //Divide up space equally between each planet
        let width = frame.size.width
        planetOption = width/7
        
        
        super.init(frame: frame)
        
        
   
        
        indicator.bounds = CGRect(x: 0, y: 0, width: planetOption, height: 20)
        indicator.anchorPoint = CGPoint(x: 0, y: 0)
        indicator.position = CGPoint(x: 0, y: 0)
        indicator.backgroundColor = Planets.planetColors[0]
        self.layer.addSublayer(indicator)
        
        
        for i in 0..<Planets.allValues.count {
            let planetName = Planets.allValues[i]
            let planet = Planet(name: planetName, frame:CGRect(x: 0, y: 0, width: planetOption, height: frame.size.height))
            planet.anchorPoint = CGPoint(x: 0, y: 0)
            planet.position = CGPoint(x: planetOption * CGFloat(i), y: 0)
            self.layer.addSublayer(planet)

            
            planet.setNeedsDisplay()
            planet.setScale(scale: self.contentScaleFactor)
            
            planets.append(planet)

        }
        
        
        select(planet: .Mercury)

 
    }
    
    
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let point = touch!.location(in: self)
        
        for planet in planets {
            if(planet.frame.contains(point)){
                select(planet: planet.type)
                self.indicator.backgroundColor = planet.color
                self.indicator.position = CGPoint(x: planet.position.x, y: 0)
                self.sendActions(for: .valueChanged)
            }
        }
        
        
    }
    
    
    
    
 
    
    func select(planet: Planets){
        
        for p in planets {
            if p.type == planet {
                p.setSelected()
                currentPlanet = p
            } else {
                p.setDeselected()
            }
        }
    }
    
    func select(planet: Planet){
        planet.setSelected()
        currentPlanet = planet
    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
    }
    
    
}
