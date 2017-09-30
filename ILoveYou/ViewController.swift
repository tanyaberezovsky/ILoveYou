//
//  ViewController.swift
//  ILoveYou
//
//  Created by Tania on 26/06/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//
/*
 
 summury: 
    In this app I'm working with:
 
        multithreads, custom framework and AVAudioPlayer
 */
import UIKit
import GoogleMobileAds
import FloatingHearts

enum icons: String{
    case play = "triangle.png"
    case stop = "square.png"
    
    static func getImageNameBy(number: Int)->String{
        if (number == 0){
            return icons.stop.rawValue
        } else {
            return icons.play.rawValue
        }
    }
}

struct mode {
   static let playing = 0
   static let notPlaying = 1
}

class ViewController: UIViewController {
    
    fileprivate struct HeartAttributes {
        static let heartSize: CGFloat = 36
        static let burstDelay: TimeInterval = 0.1
        static let burstSlowDelay: TimeInterval = 0.3
    }
    
    var burstTimer: Timer?
    var loopTimer: Timer?
    var stopTimer: Timer?
    

    @IBOutlet weak var bannerView: GADBannerView!

    @IBOutlet weak var buttonSlow: UIButton!
    @IBOutlet weak var buttonRegular: UIButton!
    var player: MyAudioPlayer?
    let heartRandomArray = (1...100).map{_ in arc4random_uniform(13)}
    let heartIntervalArray = (1...100).map{_ in arc4random_uniform(8)}
    var heartArrayIndex: Int = 0
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = MyAudioPlayer()
        initialize()
        initAd()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTheLove))
        view.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        longPressGesture.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressGesture)

        heartArrayIndex = 0
        
        scheduleHeartsAppearance()
        startTimerForHearts()
    }
    
    func startTimerForHearts() {
        print("\(heartIntervalArray[heartArrayIndex])")
        timer?.invalidate()
        let timerIntervalForResendingCode = TimeInterval(heartIntervalArray[heartArrayIndex] + 1)
        timer = Timer.scheduledTimer(timeInterval: timerIntervalForResendingCode,
                             target: self,
                             selector: #selector(scheduleHeartsAppearance),
                             userInfo: nil,
                             repeats: false)
    }
    
    func scheduleHeartsAppearance()  {
        print("scheduleHeartsAppearance")
        if (self.heartArrayIndex == self.heartRandomArray.count) {
            self.heartArrayIndex = 0
        }
        loopTimer = Timer.scheduledTimer(timeInterval: HeartAttributes.burstSlowDelay, target: self, selector: #selector(showTheLove), userInfo: nil, repeats: true)
        
        let stopTimerInterval = TimeInterval(Double(heartRandomArray[heartArrayIndex]) * Double(HeartAttributes.burstSlowDelay))
        print("stopTimerInterval ")
        stopTimer = Timer.scheduledTimer(timeInterval: stopTimerInterval, target: self, selector: #selector(stopLoopTimerLove), userInfo: nil, repeats: false)
        
        self.heartArrayIndex += 1
       
    }
    
    func stopLoopTimerLove(){
        loopTimer?.invalidate()
        stopTimer?.invalidate()
        timer?.invalidate()
        startTimerForHearts()
    }
    
    func didLongPress(_ longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            burstTimer = Timer.scheduledTimer(timeInterval: HeartAttributes.burstDelay, target: self, selector: #selector(showTheLove), userInfo: nil, repeats: true)
        case .ended, .cancelled:
            burstTimer?.invalidate()
        default:
            break
        }
    }
    
    func showTheLove(_ gesture: UITapGestureRecognizer?) {
        let heart = HeartView(frame: CGRect(x: 0, y: 0, width: HeartAttributes.heartSize, height: HeartAttributes.heartSize))
        view.addSubview(heart)
        let fountainX = HeartAttributes.heartSize / 2.0 + 20
        let fountainY = view.bounds.height - HeartAttributes.heartSize / 2.0 - 10
        heart.center = CGPoint(x: fountainX, y: fountainY)
                DispatchQueue.main.async() { [weak self] in
                      heart.animateInView((self?.view)!)
                }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop()
    }
    
    func initialize(){
        buttonSlow.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        buttonRegular.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        let color2 = UIColor(red: 67/255, green: 148/255, blue: 227/255, alpha: 1.0)
        let color1 = UIColor(red: 98/255, green: 216/255, blue: 202/255, alpha: 1.0)
        self.view.applyGradient(colours: [color1 , color2])
        self.buttonSlow.tag = mode.notPlaying
        self.buttonRegular.tag = mode.notPlaying
    }
    
    func initAd(){
        bannerView.adUnitID = Keys.adMob.unitID
        bannerView.rootViewController = self
        //request the ad
        bannerView.load(GADRequest())
    }
    
    @IBAction func buttonSlow(_ sender: UIButton) {
        buttonTouch(sender, secondButton: buttonRegular, fileName: "loveWordSlow")
    }
   
    @IBAction func buttonRegularTouch(_ sender: UIButton) {
        buttonTouch(sender, secondButton: buttonSlow, fileName: "loveWordVoiceRegular")
    }
    
    func buttonTouch(_ sender: UIButton, secondButton: UIButton, fileName: String) {
        if sender.tag == mode.playing{
            player?.stop()
        }else{
            player?.play(fileName)
        }
        sender.toggleImage()
        if secondButton.tag == mode.playing{
            secondButton.toggleImage()
        }
    }
}

extension UIButton{
    public func toggleImage(){
        self.tag.toggle()
        let imageName = icons.getImageNameBy(number: self.tag)
        self.setImage(UIImage(named: imageName), for: .normal)
    }
}

extension Int{
    /// Mutates a int:
    mutating func toggle() {
        self = self == mode.notPlaying ? mode.playing : mode.notPlaying
    }
}

