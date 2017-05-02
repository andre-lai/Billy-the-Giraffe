//
//  charactersViewController.swift
//  Billy the Giraffe
//
//  Created by Andre Lai on 4/28/17.
//  Copyright © 2017 Andre Lai. All rights reserved.
//

import UIKit

class charactersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        
        view.sendSubview(toBack: blurEffectView)
        
        //manage images
        imageView1.image = UIImage(named: "giraffe1")
        imageView2.image = UIImage(named: "giraffe2")
        imageView3.image = UIImage(named: "giraffe3")
        imageView4.image = UIImage(named: "giraffe4")
        
        //manage initial character selection
        if (UserDefaults.standard.integer(forKey: "Character") == 1) {
            label2.isHidden = true
            label3.isHidden = true
            label4.isHidden = true
        } else if (UserDefaults.standard.integer(forKey: "Character") == 2) {
            label1.isHidden = true
            label3.isHidden = true
            label4.isHidden = true
        } else if (UserDefaults.standard.integer(forKey: "Character") == 3) {
            label1.isHidden = true
            label2.isHidden = true
            label4.isHidden = true
        } else if (UserDefaults.standard.integer(forKey: "Character") == 4) {
            label1.isHidden = true
            label2.isHidden = true
            label3.isHidden = true
        }

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBAction func button1(_ sender: UIButton) {
        UserDefaults.standard.set(1, forKey: "Character")
        label1.isHidden = false
        label2.isHidden = true
        label3.isHidden = true
        label4.isHidden = true
    }
    
    @IBAction func button2(_ sender: UIButton) {
        UserDefaults.standard.set(2, forKey: "Character")
        label1.isHidden = true
        label2.isHidden = false
        label3.isHidden = true
        label4.isHidden = true
    }
    
    @IBAction func button3(_ sender: UIButton) {
        UserDefaults.standard.set(3, forKey: "Character")
        label1.isHidden = true
        label2.isHidden = true
        label3.isHidden = false
        label4.isHidden = true
    }
    
    @IBAction func button4(_ sender: UIButton) {
        UserDefaults.standard.set(4, forKey: "Character")
        label1.isHidden = true
        label2.isHidden = true
        label3.isHidden = true
        label4.isHidden = false
    }
}
