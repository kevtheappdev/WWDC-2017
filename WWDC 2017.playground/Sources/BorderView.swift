import Foundation
import UIKit

public class BorderView : UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1.0

    }
    
    
  
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
