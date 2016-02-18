//
//  MagicTimerLabel.swift
//  MagicTimer
//
//  Created by Robin on 2/17/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit
import Foundation

/**
 The TimerLabel Type  Enum
 
 - StopWatch: 秒表
 - Timer:     计时器
 */
public enum MagicTimerLabelType {
    case StopWatch
    case Timer
}

/**
 *  The TimerLabel   Delegate
 */
protocol MagicTimerLabelDelegate {
    func finishCountDownTimer(timerLabel: MagicTimerLabel, countTime: NSTimeInterval)
    func countingTimeTo(timerLabel: MagicTimerLabel, toTime: NSTimeInterval, timerType: MagicTimerLabelType)
    func customTextToDisplay(timerLabel: MagicTimerLabel,atTime: NSTimeInterval) -> String
}

 class MagicTimerLabel: UILabel {
    
//    private let kDefaultTimeFormat = "HH:mm:ss"
    private let kHourFormatReplace = "!!!*"
    private let kDefaultFireIntervalNormal = 0.1
    private let kDefaultFireIntervalHighUse = 0.01
    
    
 /// The Delegate finish of count down label
    var delegate: MagicTimerLabelDelegate?
    
 /// Time format wish to display in label
    var timeFormat: String? = "HH:mm:ss" {
        didSet {
            if let _ = timeFormat {
                self.dateFormatter.dateFormat = timeFormat
            }
            
            self.updateLabel()
        }
    }
    
 /// Target label object, default self if you do not initWithLabel nor set
    var timeLabel: UILabel?
    
 /// Used for replace text in range
    var textRange: NSRange?
    
 /// Used for replace text in range text attribute
    var attributedDictionaryForTextInRange: [String : AnyObject]?
    
 /// Type to choose from stopwatch or timer
    var timerType: MagicTimerLabelType = .StopWatch
    
 /// is the Timer Running?
    private(set) var counting: Bool = false
    
 /// Do you want to reset the Timer after countdown?
    var resetTimerAfterFinish: Bool = true
    
 /// Do you want the timer to count beyond the HH limit from 0-23. e.g. 25:23:12(HH:mm:ss)
    var shouldCountBeyondHHLimit: Bool = true {
        didSet {
            self.updateLabel()
        }
    }
    
    
    //Private variables
    private var timeUserValue: NSTimeInterval = 0
    private var startCountDate: NSDate?
    private var pausedTime: NSDate?
    private var date1970 = NSDate(timeIntervalSince1970: 0)
    private var timeToCountOff: NSDate?
    private var timer: NSTimer?
    
    private var dateFormatter: NSDateFormatter{
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_GB")
        formatter.timeZone = NSTimeZone(name: "GMT")
        formatter.dateFormat = self.timeFormat
        
        return formatter
    }
    
    
     init(frame: CGRect, label: UILabel? = nil, type: MagicTimerLabelType? = .StopWatch) {
        super.init(frame: frame)
        timeLabel = label == nil ? self : label
        timerType = type!
    }
    
    deinit{
        if timer != nil {
            timer!.invalidate()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStopWatchTime(time: NSTimeInterval) {
        timeUserValue = (time < 0) ? 0 : time
        if timeUserValue > 0 {
            startCountDate = NSDate().dateByAddingTimeInterval(-timeUserValue)
            pausedTime = NSDate()
            self.updateLabel()
        }
    }
    
    func setCountDownTime(time: NSTimeInterval) {
        timeUserValue = (time < 0) ? 0 : time
        timeToCountOff = date1970.dateByAddingTimeInterval(timeUserValue)
        self.updateLabel()
    }
    
    func setCountDownToDate(date: NSDate) {
        let timeLeft = date.timeIntervalSinceDate(NSDate())
        if timeLeft > 0 {
            timeUserValue = timeLeft
            timeToCountOff = date1970.dateByAddingTimeInterval(timeLeft)
        } else {
            timeUserValue = 0
            timeToCountOff = date1970.dateByAddingTimeInterval(0)
        }
        self.updateLabel()
    }
    
    func addTimeCountedByTime(timeToAdd: NSTimeInterval) {
        if timerType == .Timer {
            self.setCountDownTime(timeToAdd + timeUserValue)
        } else if timerType == .StopWatch {
            let newStartDate = startCountDate!.dateByAddingTimeInterval(-timeToAdd)
            if NSDate().timeIntervalSinceDate(newStartDate) <= 0 {
                startCountDate = NSDate()
            } else {
                startCountDate = newStartDate
            }
        }
        self.updateLabel()
    }
    
    func getTimeCounted() -> NSTimeInterval {
        if (startCountDate == nil) {
            return 0
        }
        var countedTime = NSDate().timeIntervalSinceDate(startCountDate!)
        if pausedTime != nil {
            let pauseCountedTime = NSDate().timeIntervalSinceDate(pausedTime!)
            countedTime -= pauseCountedTime
        }
        return countedTime
    }
    
    func getTimeRemaining() -> NSTimeInterval {
        if timerType == .Timer {
            return timeUserValue - self.getTimeCounted()
        }
        return 0
    }
    
    func getCountDownTime() -> NSTimeInterval {
        if timerType == .Timer {
            return timeUserValue
        }
        return 0
    }
    
    func start() {
        if (timer != nil) {
            timer!.invalidate()
            timer = nil
        }
        if self.timeFormat!.rangeOfString("SS") != nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(kDefaultFireIntervalHighUse, target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(kDefaultFireIntervalNormal, target: self, selector: Selector("updateLabel"), userInfo: nil, repeats: true)
        }
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        if startCountDate == nil {
            startCountDate = NSDate()
            if self.timerType == .StopWatch && timeUserValue > 0 {
                startCountDate = startCountDate!.dateByAddingTimeInterval(-timeUserValue)
            }
        }
        if pausedTime != nil {
            let countedTime = pausedTime!.timeIntervalSinceDate(startCountDate!)
            startCountDate = NSDate().dateByAddingTimeInterval(-countedTime)
            pausedTime = nil
        }
        counting = true
        timer!.fire()
    }
    
//    func startWithEndingBlock(end: (NSTimeInterval) -> Void) {
//        self.endedBlock = end
//        self.start()
//    }
    
    func pause() {
        if counting {
            timer!.invalidate()
            timer = nil
            counting = false
            pausedTime = NSDate()
        }
    }
    
    func reset() {
        pausedTime = nil
        timeUserValue = (self.timerType == .StopWatch) ? 0 : timeUserValue
        startCountDate = (self.counting) ? NSDate() : nil
        self.updateLabel()
    }
    
    //MARK: -Private Methods
    private func setup() {
        date1970 = NSDate(timeIntervalSince1970: 0)
        updateLabel()
    }
    
     func updateLabel() {
        let timeDiff = NSDate().timeIntervalSinceDate(startCountDate!)
        var timeToShow = NSDate()
        var timerEnded = false
        
        if timerType == .StopWatch {
            if counting {
                timeToShow = date1970.dateByAddingTimeInterval(timeDiff)
            } else {
                timeToShow = date1970.dateByAddingTimeInterval((startCountDate == nil) ? 0 : timeDiff)
            }
            if let _ = delegate {
                delegate!.countingTimeTo(self, toTime: timeDiff, timerType: timerType)
            }
        } else {
            if counting {
               if let _ = delegate {
                let timeLeft = timeUserValue - timeDiff
                delegate!.countingTimeTo(self, toTime: timeLeft, timerType: timerType)
                }
                if timeDiff >= timeUserValue {
                    self.pause()
                    timeToShow = date1970.dateByAddingTimeInterval(0)
                    startCountDate = nil
                    timerEnded = true
                } else {
                    timeToShow = timeToCountOff!.dateByAddingTimeInterval((timeDiff * -1))
                }
            } else {
                timeToShow = timeToCountOff!
            }
        }
        if let _ = delegate {
            let atTime = (timerType == .StopWatch) ? timeDiff : ((timeUserValue - timeDiff) < 0 ? 0 : (timeUserValue - timeDiff))
            let customtext = delegate!.customTextToDisplay(self, atTime: atTime)
            if !customtext.isEmpty {
                timeLabel!.text = customtext
            } else {
                timeLabel!.text = dateFormatter.stringFromDate(timeToShow)
            }
        } else {
            if shouldCountBeyondHHLimit {
                let originalTimeFormat = timeFormat
                var beyondFormat = timeFormat!.stringByReplacingOccurrencesOfString("HH", withString: kHourFormatReplace)
                beyondFormat = beyondFormat.stringByReplacingOccurrencesOfString("H", withString: kHourFormatReplace)
                dateFormatter.dateFormat = beyondFormat
                let hours = (timerType == .StopWatch) ? (self.getTimeCounted() / 3600) : (self.getTimeRemaining() / 3600)
                let formmattedDate = self.dateFormatter.stringFromDate(timeToShow)
                let beyondedDate = formmattedDate.stringByReplacingOccurrencesOfString(kHourFormatReplace, withString: String(format: "%02d", hours))
                self.timeLabel!.text = beyondedDate
                self.dateFormatter.dateFormat = originalTimeFormat
            } else {
                if self.textRange!.length > 0 {
                    if attributedDictionaryForTextInRange != nil {
                        let attrTextInRange = NSAttributedString(string: self.dateFormatter.stringFromDate(timeToShow), attributes: self.attributedDictionaryForTextInRange)
                        var attributedString: NSMutableAttributedString
                        attributedString = NSMutableAttributedString(string: self.text!)
                        attributedString.replaceCharactersInRange(self.textRange!, withAttributedString: attrTextInRange)
                        timeLabel!.attributedText = attributedString
                    } else {
                        let labelText = (self.text! as NSString).stringByReplacingCharactersInRange(textRange!, withString: self.dateFormatter.stringFromDate(timeToShow))
                        timeLabel!.text = labelText
                    }
                } else {
                    self.timeLabel!.text = self.dateFormatter.stringFromDate(timeToShow)
                }
            }
        }
        if timerEnded {
//            if _delegate.respondsToSelector("timerLabel:finshedCountDownTimerWithTime:") {
//                _delegate.timerLabel(self, finshedCountDownTimerWithTime: timeUserValue)
//            }
//            if _endedBlock != nil {
//                _endedBlock(timeUserValue)
//            }
            if resetTimerAfterFinish {
                self.reset()
            }
        }
    }
    
    
}