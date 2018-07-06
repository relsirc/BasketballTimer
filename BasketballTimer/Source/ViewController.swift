//
//  ViewController.swift
//  BasketballTimer
//
//  Created by Crisler on 7/6/18.
//  Copyright © 2018 Crisler. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var setTimeButton: UIButton!
    
    var timer = Timer()
    var timeFinish = 0 //seconds
    var timeRemaining = 0
    var isTimerRunning = false
    var audioPlayer: AVAudioPlayer?
    var setMins = 0
    var setSecs = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func setUpUI() {
        timeLeftLabel.isUserInteractionEnabled = true
        timeLeftLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapTimeLeft)))
        startButton.makeCircular()
        startButton.addBorder(width: 3, color: .black)
        stopButton.makeCircular()
        stopButton.addBorder(width: 3, color: .black)
    }
    
    // MARK: - Selector functions
    @objc fileprivate func tapTimeLeft(recognizer: UITapGestureRecognizer) {
        if isTimerRunning {
            pauseTimer()        }
        else {
            startTimer()
        }
    }
    
    @objc fileprivate func timerRunning() {
        
        if timeRemaining == 0 {
            pauseTimer()
            return
        }
        
        timeRemaining = timeRemaining - 1
        let timeRemainingMins = timeRemaining / 60
        let timeRemainingSecs = (timeRemaining % 60)
        timeLeftLabel.text = String(format: "%02d:%02d", timeRemainingMins, timeRemainingSecs)
        
        if timeRemaining == 0 {
            timer.invalidate()
            playBuzzerSound()
        }
    }
    
    fileprivate func playBuzzerSound() {
        guard let url = Bundle.main.url(forResource: "buzzer", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func pauseTimer() {
        timer.invalidate()
        isTimerRunning = false
        startButton.setTitle("START", for: .normal)
    }
    
    fileprivate func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        startButton.setTitle("PAUSE", for: .normal)
    }
    
    fileprivate func setTimer() {
        timeFinish = (setMins * 60 ) + setSecs
        timeRemaining = timeFinish
        timeLeftLabel.text = String(format: "%02d:%02d", setMins, setSecs)
    }

    // MARK: IBActions
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if isTimerRunning {
            pauseTimer()
        }
        else {
            startTimer()
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        timer.invalidate()
        timeRemaining = 420
        timeFinish = 420
        timeLeftLabel.text = "07:00"
        startButton.setTitle("START", for: .normal)
    }
    
    @IBAction func setTimeButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "TIMER", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 20, y: 20, width: 240, height: 140))
        pickerFrame.delegate = self
        alert.isModalInPopover = true
        alert.view.addSubview(pickerFrame)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.setTimer()
            
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        // add height constaint to view otherwise it looks crap
        let heightConstraint = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 260)
        alert.view.addConstraint(heightConstraint)
        
        // this code is only on ipad, shows the alert in the center
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format: "%02d", row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            let minute = row
            setMins = row
            print("minute: \(minute)")
        }else{
            let second = row
            setSecs = row
            print("second: \(second)")
        }
    }
}

