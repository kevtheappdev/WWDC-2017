import Foundation
import UIKit

public class MainWindow : UIScrollView {
    var ipad = false
    
    public var isIpad : Bool {
        get {
            return ipad
        }
        
        set(value) {
            changeScrollView(isIpad: value)
            ipad = value
        }
    }
    
    
    private func changeScrollView(isIpad: Bool){
        if isIpad {
            self.frame = CGRect(x: 0, y: 0, width: 512, height: 512)
        } else {
            self.frame = CGRect(x: 0, y: 0, width: 800, height: 800)
        }
        setNeedsDisplay()
    }
    
   public init(){
        let main = MainView()
        super.init(frame: main.frame)
        contentSize = CGSize(width: 800, height: 800)
        addSubview(main)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

