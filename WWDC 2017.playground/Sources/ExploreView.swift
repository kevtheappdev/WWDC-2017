import Foundation
import UIKit

public class ExploreView : UIView {
    var backButton : UIButton
    var statusLabel : UILabel
    var titleLabel : UILabel
    let indicatorView = UIView(frame: CGRect(x: 0, y: -100, width: 20, height: 100))
    var questions = ["How many moons does {p} have", "How big is is {p}", "How long is a day on {p}", "How long is a year on {p}", "How strong is the gravity on {p}"]
    var answers : [String] = []
    var planetName : String
    var questionIndex = 0
    var positionIndex = 0
    var questionLabels : [UILabel] = []
    var answerView : InfoCard!
    var portHole : PortHole
    var questionBox : UIView
    var questionInBox : UILabel?
    var questionlastPoint : CGPoint?
    var selectedQuestionLastPoint : CGPoint?
   

    
    public init(frame: CGRect, planet: Planets){
        
        
        questionBox = BorderView(frame: CGRect(x: 400, y: 150, width: 300, height: 100))


        
        self.portHole  = PortHole(point: CGPoint(x: 400, y: 400), width: 400, planet: planet)
        self.portHole.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
        
        planetName = planet.rawValue
        
        titleLabel = UILabel(frame: CGRect(x: frame.size.width/2 - 300, y: 75, width: 600, height: 100))
        
        statusLabel = UILabel(frame: CGRect(x: frame.size.width/2 - 300, y: 20, width: 600, height: 100))
        statusLabel.textAlignment = .center
        
        backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 75, height: 70))
        backButton.setImage(UIImage(named: "back-button")!, for: .normal)
        
        super.init(frame: frame)
        
        
            addSubview(questionBox)
        
        self.backgroundColor = UIColor(patternImage: UIImage(named: planet.rawValue + "-Background")!)
        //self.backgroundColor = UIColor.black
        self.addSubview(backButton)
        
        titleLabel.text = "Drag a question in to the box below to learn more!"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        self.addSubview(titleLabel)
        
        statusLabel.text = planet.rawValue
        statusLabel.font = UIFont.systemFont(ofSize: 48)
        statusLabel.textColor = UIColor.white
        self.addSubview(statusLabel)
        
        indicatorView.backgroundColor = UIColor.white
        self.addSubview(indicatorView)
        
        backButton.addTarget(self, action: #selector(ExploreView.back), for: .touchDown)
        


    
        
        addSubview(portHole)
        
        populateQuestions()
        populateAnswers()
        //displayQuestions()
        dropQuestions()
        
        //dropItems()
   
    }
    

    
    
    private func populateAnswers(){
        let url = Bundle.main.url(forResource: "Planets", withExtension: "json")
        let data = try! Data(contentsOf: url!)

        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)

            if let dictionary = object as? [String : AnyObject] {

                let planets = (dictionary["Planets"] as! [AnyObject])[0] as! [String : AnyObject]

                let currentPlanet = planets[self.planetName] as! [String : AnyObject]
                
                
                
                let moons = currentPlanet["Moons"] as! String
                let moonsComp = Int(moons)!
                if moonsComp > 0 {
                    answers.append("\(planetName) has a grand total of \(moonsComp)!")
                } else {
                    answers.append("\(planetName) does not have any Moons")
                }
                

                
                let diameter = currentPlanet["Diameter"] as! String
                                answers.append("\(planetName) has a diamter of \(diameter)")

                
                
                let day = currentPlanet["Rotation"] as! String
                answers.append("On \(planetName), the day is \(day) long")

                
                let year = currentPlanet["Orbit"] as! String
                answers.append("On \(planetName), the year is \(year)!")
                
                
                let mass = currentPlanet["Mass"] as! String
                var massString  = "of Earth's!"
                if mass.range(of: "%") == nil {
                    massString = "times Earth's!"
                }
                
                answers.append("\(planetName)'s Gravity is \(mass) \(massString)")

                
            }
        } catch {
            print("Failed to load data")
        }

    }
    


    public func questionDragged(sender: Any?){
        let recognizer = sender as! UIPanGestureRecognizer
        let center = CGPoint(x: self.questionBox.center.x , y: self.questionBox.center.y)
        
        if recognizer.state == .began {
            if let view = recognizer.view {
                if view.center != center {
                    questionlastPoint = view.center
                }
            }
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self)
            if let view = recognizer.view {
                view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            }
        
        } else if recognizer.state == .ended {
            if let view = recognizer.view {
                if questionBox.frame.contains(view.center) {
                    
                    
                    if questionInBox != nil {
                        UIView.animate(withDuration: 0.4, animations: {() in
                            self.questionInBox?.center = self.selectedQuestionLastPoint!
                        })
                    }
                    
                    selectedQuestionLastPoint = questionlastPoint
                        
                    
                    
                    questionInBox = view as? UILabel
                    UIView.animate(withDuration: 0.4, animations: {() in
                        self.questionInBox?.center = center
                    })
                    
               
                    
                    pickedQuestion(atIndex: questionInBox!.tag)
                    //pickedQuestion(atIndex: 0)
                    
                } else {
                    if questionInBox?.tag == view.tag {
                        view.center = selectedQuestionLastPoint!
                    } else {
                        view.center = questionlastPoint!
                    }
                }
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self)
        
   
    }
    
    private func pickedQuestion(atIndex index: Int){
        
        let newAnswerLabel = InfoCard(frame: CGRect(x: 400, y: 10000, width: 300, height: 100), answer: answers[index])
        newAnswerLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/Double(3)))
        insertSubview(newAnswerLabel, at: 0)
        
        UIView.animate(withDuration: 0.2, animations: {() in
            self.answerView?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/Double(3)))
            if self.answerView != nil {
                self.answerView?.frame = CGRect(origin: CGPoint(x: (self.answerView?.frame.origin.x)!, y: 1000), size: (self.answerView?.frame.size)!)
            }
        }, completion: {(done) in
            self.answerView?.removeFromSuperview()
            self.answerView = newAnswerLabel
            UIView.animate(withDuration: 0.5, animations: {() in
                self.answerView.transform = CGAffineTransform.identity
                self.answerView.frame = CGRect(origin: CGPoint(x: self.answerView.frame.origin.x, y: 300), size: self.answerView.frame.size)

            })
        })
    }
    
    private func dropQuestions() {
        var y = 150
        var tag = 0
        for question in questions {
            let questionlabel = UILabel(frame: CGRect(x: 50, y: y, width: 300, height: 100))
            questionlabel.isUserInteractionEnabled = true
            let panRecogniezer = UIPanGestureRecognizer(target: self, action: #selector(ExploreView.questionDragged(sender:)))
            questionlabel.addGestureRecognizer(panRecogniezer)
            questionlabel.tag = tag;
            y += 75
            tag += 1
            questionlabel.adjustsFontSizeToFitWidth = false
            questionlabel.numberOfLines = 2
            questionlabel.text = question
            questionlabel.textAlignment = .center
            questionlabel.textColor = UIColor.white
            questionlabel.font = UIFont.systemFont(ofSize: 25)
            self.questionLabels.append(questionlabel)
            self.addSubview(questionlabel)
            
        }
        

    }
    
    


    
    private func populateQuestions(){
        var qIndex = 0
        for question in questions {
            var comps  = question.components(separatedBy: " ")
            var cIndex = 0
            for comp in comps {
                if comp == "{p}" {
                    comps[cIndex] = planetName
                }
                
                cIndex += 1
            }
            
            var newString = ""
            for comp in comps {
                newString += comp + " "
            }
            newString += "?"
            
            questions[qIndex] = newString
            
            qIndex += 1
        }
    }
    

    
    public func back(){
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.75, options: [], animations: {() in
            self.center = CGPoint(x: self.center.x, y: -1000)
        }, completion: {(done) in
            if done {
                self.removeFromSuperview()
            }
        })
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

