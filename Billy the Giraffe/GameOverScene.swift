//
//  GameOverScene.swift
//  Billy the Giraffe
//
//  Created by Andre Lai on 4/13/17.
//  Copyright © 2017 Andre Lai. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    //play again button
    let playAgain = SKSpriteNode(imageNamed: "playAgain")
    
    init(size: CGSize, score: Int, numScarves: Int) {
        super.init(size: size)
        
        //set the background
        //backgroundColor = SKColor.white
        let background = SKSpriteNode(imageNamed: "gameOver")
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        background.zPosition = -1
        addChild(background)
        
        //update high score
        if (score > UserDefaults.standard.integer(forKey: "highScore")) {
            UserDefaults.standard.set(score, forKey: "highScore")
        }
        
        //create and add "Game Over" label
        let label = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        label.text = "Game Over"
        label.fontSize = 50
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.76)
        addChild(label)
        
        //create and add "Your Score Was" label
        let scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoreLabel.text = "Your Score Was:"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.66)
        addChild(scoreLabel)
        
        //create and add score value label
        let scoreValueLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        scoreValueLabel.text = String(score)
        scoreValueLabel.fontSize = 40
        scoreValueLabel.fontColor = SKColor.black
        scoreValueLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.60)
        addChild(scoreValueLabel)
        
        //create and add current high score label
        let highScoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        highScoreLabel.text = "Current High Score:"
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.black
        highScoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.50)
        addChild(highScoreLabel)
        
        //create and add current high score label
        let highScoreValue = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        highScoreValue.text = String(UserDefaults.standard.integer(forKey: "highScore"))
        highScoreValue.fontSize = 40
        highScoreValue.fontColor = SKColor.black
        highScoreValue.position = CGPoint(x: size.width * 0.5, y: size.height * 0.44)
        addChild(highScoreValue)
        
        //add play again button
        playAgain.position = CGPoint(x: size.width * 0.33, y: size.height * 0.25)
        addChild(playAgain)
        
        //change game stats
        let newNumScarves = numScarves + UserDefaults.standard.integer(forKey: "numScarves")
        UserDefaults.standard.set(newNumScarves, forKey: "numScarves")
        
        let newNumGames = 1 + UserDefaults.standard.integer(forKey: "numGames")
        UserDefaults.standard.set(newNumGames, forKey: "numGames")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //user pressed pause button
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            
            // Check if the location of the touch is within the button's bounds
            if (playAgain.contains(location)) {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }

}

