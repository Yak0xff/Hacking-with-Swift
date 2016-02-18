//
//  DetailViewController.swift
//  MagicTimer
//
//  Created by Robin on 2/17/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var  labelFrame: CGRect {
        return CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 80)
    }

    var detailItem: AnyObject? {
        didSet {
            self.configureTitle()
        }
    }
    
    var timerIndex: Int = 0

    func configureTitle() {
        if let detail = self.detailItem {
            self.title = detail.description
        }
    }
    
    func configureView() {
        
        switch timerIndex {
        case 0 :   example00()
        case 1:     example01()
        case 2:    example02()
        default: break
        }
    }
    
    
    
    //Using existing UILabel, stopwatch
    func example00() {
        let example00Label = MagicTimerLabel(frame: labelFrame, label: nil, type: .StopWatch)
        example00Label.backgroundColor = UIColor.redColor()
        example00Label.textAlignment = .Center
        example00Label.font = UIFont.boldSystemFontOfSize(60)
        example00Label.textColor = UIColor.yellowColor()
        self.view.addSubview(example00Label)
        
        example00Label.start()
    }
    
    //Self as label, free styling just like usual
    func example01() {
        let example01Label = MagicTimerLabel(frame: labelFrame, label: nil, type: .StopWatch)
        example01Label.backgroundColor = UIColor.redColor()
        example01Label.textAlignment = .Center
        example01Label.font = UIFont.boldSystemFontOfSize(60)
        example01Label.textColor = UIColor.redColor()
        self.view.addSubview(example01Label)
        
        example01Label.start()
    }
    
    //Self as label, free styling just like usual
    func example02() {
        let example02Label = MagicTimerLabel(frame: labelFrame, label: nil, type: .Timer)
        example02Label.backgroundColor = UIColor.redColor()
        example02Label.textAlignment = .Center
        example02Label.font = UIFont.boldSystemFontOfSize(60)
        example02Label.textColor = UIColor.redColor()
        self.view.addSubview(example02Label)
        
        example02Label.setCountDownTime(30*60)
        
        example02Label.start()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.configureTitle()
        self.configureView()
    }

    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

