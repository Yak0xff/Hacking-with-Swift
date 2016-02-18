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
        case 0 :    example01()
        default: break
        }
    }
    
    
    
    //Using existing UILabel, stopwatch
    func example01() {
        let example01Label = MagicTimerLabel(frame: labelFrame, label: nil, type: .StopWatch)
        example01Label.textAlignment = .Center
        example01Label.font = UIFont.boldSystemFontOfSize(60)
        example01Label.textColor = UIColor.yellowColor()
        self.view.addSubview(example01Label)
        example01Label.backgroundColor = UIColor.redColor()
        
        example01Label.start()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.configureTitle()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

