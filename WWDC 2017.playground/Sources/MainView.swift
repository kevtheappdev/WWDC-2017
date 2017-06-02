import Foundation
import UIKit
import AVFoundation

public class MainView : UIView, AVAudioPlayerDelegate{
    var navBar : PlanetScroller
    var titleLabel : UILabel
    var planetImageView : UIImageView
    var exploreButton : UIButton
    var currentPlanet : Planets
    var audioPlayer : AVAudioPlayer!
    
    public init(){
        let frame =  CGRect(x: 0, y: 0, width: 800, height: 800)
        
        exploreButton = UIButton(type: .custom)
        exploreButton.frame = CGRect(x: 0, y: 0, width: 200, height: 75)
        exploreButton.setImage(UIImage(named: "Mercury-Button"), for: .normal)

        
        currentPlanet = .Mercury
        navBar = PlanetScroller(frame: CGRect(x: 0, y: frame.size.height - 200, width: 750, height: 200))
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        titleLabel.textAlignment = .center

        planetImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 600, height: 400))
        planetImageView.contentMode = .scaleAspectFit
        planetImageView.image = UIImage(named: "Mercury-1")
        super.init(frame: frame)
        
        exploreButton.addTarget(self, action: #selector(MainView.explorePlanet), for: .touchDown)
        self.addSubview(exploreButton)

        navBar.addTarget(self, action: #selector(MainView.planetChanged), for: .valueChanged)
        
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0;
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        titleLabel.text = "Mercury"
        self.addSubview(navBar)
        self.addSubview(titleLabel)
        self.addSubview(planetImageView)
        
        displayStars()
        loadSound()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MainView.playSound), userInfo: nil, repeats: false)
        }
    
    
    func playSound(){
        self.audioPlayer.play()

    }
    
    func loadSound(){
        let path = Bundle.main.path(forResource: "WWDC", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
        } catch {
            print("failed to play")
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playSound()
    }
    
    
    
    func displayStars(){
        for _ in 0...18 {
            let x = arc4random_uniform(UInt32(frame.size.width)-UInt32(100))
            let y = arc4random_uniform(UInt32(frame.size.height)-UInt32(200))
        
            let star = UIView(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: 10, height: 10))
            star.backgroundColor = UIColor.white
            star.tag = 1
            star.layer.cornerRadius = 10
                       let upDown = arc4random_uniform(2)
            if upDown == 1 {
                 star.alpha = 0.3
                twinkleUp(star: star)
            } else {
                star.alpha = 1
                twinkleDown(star: star)
            }
            
     
            self.insertSubview(star, belowSubview: self.exploreButton)
        }
    }
    
    func twinkleUp(star: UIView){
        UIView.animate(withDuration: 10, delay: 3, options: [], animations: {() in
            star.alpha = 1
            }, completion: {(done) in
                if done {
                    self.twinkleDown(star: star)
                }
              
                
        })
    }
    
    
    func twinkleDown(star: UIView){
        UIView.animate(withDuration: 10, animations: {() in
            star.alpha = 0.3
        }, completion: {(done) in
            if done {
                self.twinkleUp(star: star)
            }
        })
    }
    
    
    func explorePlanet(){
        let exploreView = ExploreView(frame: self.frame, planet: currentPlanet)
        exploreView.center = CGPoint(x: bounds.midX, y: -self.frame.size.height)
        self.addSubview(exploreView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {() in
            exploreView.center = self.center
        }, completion: {(done) in
        })

    }
    
    func planetChanged(){
        let planet = navBar.currentPlanet
        currentPlanet = (planet?.type)!
        exploreButton.setImage(UIImage(named:planet!.type.rawValue + "-Button"), for: .normal)
        planetImageView.image = UIImage(named: planet!.type.rawValue + "-1")
        titleLabel.text = planet?.type.rawValue
        
        for view in subviews {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
        
        displayStars()
    }
    
    override public func layoutSubviews() {
        
        exploreButton.center = CGPoint(x: bounds.midX, y: 125 + planetImageView.frame.size.height)
        titleLabel.center = CGPoint(x: bounds.midX, y: 20)
        planetImageView.center = CGPoint(x: 800/2, y: 250)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
