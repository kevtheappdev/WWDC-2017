import Foundation
import UIKit

public class InfoCard : UIView {
    var answerLabel : UILabel!
    
    init(frame: CGRect, answer: String){
        
        super.init(frame: frame)
        
        
        answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        answerLabel.textColor = UIColor.white
        answerLabel.text = answer

        self.backgroundColor = UIColor.black
        self.layer.cornerRadius = 15
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1.0
        
        self.addSubview(answerLabel)
        self.displayStars()
    }

    
    func displayStars(){

        for _ in 0...36 {
           let x = arc4random_uniform(UInt32(frame.size.width - 10))
            let y = arc4random_uniform(UInt32(frame.size.height-10))
            

            
            
            let star = UIView(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 10, height: 10))
            if CGFloat(y) > (bounds.size.height/2 - 15) && CGFloat(y) < (bounds.size.height/2 + 15){
                star.isHidden = true;
            }
            
            star.backgroundColor = UIColor.white
            star.layer.cornerRadius = 10
            let upDown = arc4random_uniform(2)
            if upDown == 1 {
                star.alpha = 0.1
                twinkleUp(star: star)
            } else {
                star.alpha = 0.5
                twinkleDown(star: star)
            }
            
            
            self.insertSubview(star, belowSubview: self.answerLabel)
        }
    }
    
    func twinkleUp(star: UIView){
        UIView.animate(withDuration: 10, delay: 3, options: [], animations: {() in
            star.alpha = 0.5
        }, completion: {(done) in
            if done {
                self.twinkleDown(star: star)
            }
        })
    }
    
    
    func twinkleDown(star: UIView){
        UIView.animate(withDuration: 10, animations: {() in
            star.alpha = 0.1
        }, completion: {(done) in
            if done {
                self.twinkleUp(star: star)
            }
        })
    }

    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
