//
//  ViewController.swift
//  HackingWithSwift-02
//
//  Created by Robin on 2/18/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton! 
    
    var countries = [String]()
    var score = 0
    var correntAnswer = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGrayColor().CGColor
        button2.layer.borderColor = UIColor.lightGrayColor().CGColor
        button3.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        askQuestion(nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(countries) as! [String]
        
        button1.setBackgroundImage(UIImage(named: countries[0]), forState: .Normal)
        button2.setBackgroundImage(UIImage(named: countries[1]), forState: .Normal)
        button3.setBackgroundImage(UIImage(named: countries[2]), forState: .Normal)
        
        correntAnswer = GKRandomSource.sharedRandom().nextIntWithUpperBound(3)
        title = countries[correntAnswer].uppercaseString
    }
    
    
    @IBAction func buttonTapped(sender: AnyObject) {
        
        var title: String
        
        if (sender.tag == correntAnswer){
            title = "Corrent"
            score += 1
        }else{
            title = "Wrong"
            score -= 1
        }
        
        let alertController = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .Default, handler: askQuestion))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

