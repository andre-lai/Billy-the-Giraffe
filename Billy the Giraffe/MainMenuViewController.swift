//
//  MainMenuViewController.swift
//  Billy the Giraffe
//
//  Created by Andre Lai on 3/30/17.
//  Copyright © 2017 Andre Lai. All rights reserved.
//

import UIKit
import AVFoundation


class MainMenuViewController: UIViewController {
    
    //create audio player for background music
    var backgroundMusic = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up user defaults
        if (UserDefaults.standard.object(forKey: "Music") == nil) {
            UserDefaults.standard.set(true, forKey: "Music")
        }
        if (UserDefaults.standard.object(forKey: "Character") == nil) {
            UserDefaults.standard.set(1, forKey: "Character")
        }
            
        
        //load background image
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        background.image = UIImage(named: "background")
        
        //change the content mode:
        background.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(background)
        self.view.sendSubview(toBack: background)
        
        //begin playing theme music
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath:
                Bundle.main.path(forResource: "MainTheme", ofType: "caf")!))
            backgroundMusic.numberOfLoops = -1
            backgroundMusic.prepareToPlay()
            if (!backgroundMusic.isPlaying && UserDefaults.standard.bool(forKey: "Music")) {
                backgroundMusic.play()
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!backgroundMusic.isPlaying && UserDefaults.standard.bool(forKey: "Music")) {
            backgroundMusic.play()
        } else if (backgroundMusic.isPlaying && !UserDefaults.standard.bool(forKey: "Music")) {
            backgroundMusic.stop()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func userPressedPlayButton(_ sender: UIButton) {
        //performSegue(withIdentifier: "toGameSceneSegue", sender: nil)
    }
    
    
    @IBAction func userPressedStatsButton(_ sender: UIButton) {
        //performSegue(withIdentifier: "toStatsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameSceneSegue" {
            backgroundMusic.stop()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
