//
//  StatsViewController.swift
//  Billy the Giraffe
//
//  Created by Andre Lai on 3/31/17.
//  Copyright © 2017 Andre Lai. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    var exit = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor.blue
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(blurEffectView) 
        
        view.sendSubview(toBack: blurEffectView)
        
        //manage game stats
        numScarves.text = String(UserDefaults.standard.integer(forKey: "numScarves"))
        numGames.text = String(UserDefaults.standard.integer(forKey: "numGames"))
        highScore.text = String(UserDefaults.standard.integer(forKey: "highScore"))
        
        //manage music switch
        musicSwitch.isOn = UserDefaults.standard.bool(forKey: "Music")
        
        //manage game instructions button
        helpImage.image = UIImage(named: "helpImage")
        helpImage.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //manage text view
        aboutTextView.setContentOffset(CGPoint.zero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var numScarves: UILabel!
    @IBOutlet weak var numGames: UILabel!
    @IBOutlet weak var highScore: UILabel!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var helpImage: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var instructionsButton: UIButton!
    
    @IBAction func userTappedMusicSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "Music")
    }

    @IBAction func userPressedGameInstructions(_ sender: UIButton) {
        if (!exit) {
            helpImage.isHidden = false
            instructionsButton.setTitle("Close", for: .normal)
            exit = true
        } else if (exit) {
            helpImage.isHidden = true
            instructionsButton.setTitle("Game Instructions", for: .normal)
            exit = false
        }
        
        
    }
}
