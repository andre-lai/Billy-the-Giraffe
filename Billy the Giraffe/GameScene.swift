//
//  GameScene.swift
//  Billy the Giraffe
//
//  Created by Andre Lai on 3/30/17.
//  Copyright © 2017 Andre Lai. All rights reserved.
//

import SpriteKit
import GameplayKit

//set up physics
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Giraffe   : UInt32 = 0b1       // 1
    static let Scarf     : UInt32 = 0b10      // 2
    static let Floor     : UInt32 = 0b11      // 3
    static let Lion      : UInt32 = 0b100     // 4
    static let IceCream  : UInt32 = 0b101     // 5
}

//random number generator
func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

//vector multiplication function
func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    //giraffe object
    var giraffe = SKSpriteNode(imageNamed: "giraffe")
    
    //floor object
    let floor = SKSpriteNode(imageNamed: "floor")
    
    //pause button
    let pauseButton = SKSpriteNode(imageNamed: "pause")
    
    //continue button
    var continueButton: SKSpriteNode? = nil
    
    //lives image
    var livesImage = SKSpriteNode(imageNamed: "lives4")
    
    //player current score
    var score = 0
    
    //score label
    var scoreValueLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    
    //pause label
    var pauseLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
    
    //additional text in pause state
    var pauseLabel2 = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
    
    //player current number of lives
    var lives = 4
    
    //cloud image
    var cloud = SKSpriteNode(imageNamed: "cloud")
    
    //number of scaves caught
    var numScarves = 0
    
    //easter egg taps
    var numFloorTaps = 0
    var numCloudTaps = 0
    var numGiraffeTaps = 0
    
    override func didMove(to view: SKView) {
        
        //*** basic game scene setup ***//
        //add music
        if (UserDefaults.standard.bool(forKey: "Music")) {
            let backgroundMusic = SKAudioNode(fileNamed: "GamePlayTheme.caf")
            backgroundMusic.autoplayLooped = true
            addChild(backgroundMusic)
        }
        
        //background color
        self.backgroundColor = SKColor(red: 100/255.0, green: 179/255.0,
                                       blue: 223/255.0, alpha: 1)
        
        //add physics
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
        
        //app state observer
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(GameScene.appMovedToBackground),
                                       name: NSNotification.Name.UIApplicationWillResignActive,
                                       object: nil)
        //set-up auto pause feature
        UserDefaults.standard.set(true, forKey: "Auto-Pause")
        
        
        //*** game sprites and objects setup ***//

        //add giraffe intially centered at the bottom
        let giraffeName = "giraffe" + String(UserDefaults.standard.integer(forKey: "Character"))
        let texturedGiraffe = SKTexture(imageNamed: giraffeName)
        giraffe = SKSpriteNode(texture: texturedGiraffe)
        giraffe.position = CGPoint(x: size.width * 0.5, y: size.height * 0.22)
        giraffe.zPosition = 1
        //set up physics of giraffe
        giraffe.physicsBody = SKPhysicsBody(texture: texturedGiraffe,
                      size: CGSize(width: giraffe.size.width,
                                   height: giraffe.size.height))
        giraffe.physicsBody?.affectedByGravity = false
        giraffe.physicsBody?.isDynamic = false
        giraffe.physicsBody?.categoryBitMask = PhysicsCategory.Giraffe
        giraffe.physicsBody?.contactTestBitMask = PhysicsCategory.Scarf
        giraffe.physicsBody?.contactTestBitMask = PhysicsCategory.Lion
        giraffe.physicsBody?.contactTestBitMask = PhysicsCategory.IceCream
        giraffe.physicsBody?.collisionBitMask = PhysicsCategory.None
        addChild(giraffe)
        
        //add floor to the bottom of the game scene
        floor.position = CGPoint(x: size.width * 0.5, y: size.height * 0.06)
        floor.zPosition = -1
        //set up physics of the floor
        floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.isDynamic = false
        floor.physicsBody?.categoryBitMask = PhysicsCategory.Floor
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Scarf
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.Lion
        floor.physicsBody?.contactTestBitMask = PhysicsCategory.IceCream
        floor.physicsBody?.collisionBitMask = PhysicsCategory.None
        addChild(floor)
        
        //add lives image
        livesImage.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
        //set up physics of the lives
        livesImage.physicsBody = SKPhysicsBody(rectangleOf: livesImage.size)
        livesImage.physicsBody?.affectedByGravity = false
        livesImage.physicsBody?.isDynamic = false
        addChild(livesImage)
        
        //create and add "Your Score Was" label
        let scoreLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        scoreLabel.text = "Score:"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x: size.width * 0.1, y: size.height * 0.9)
        addChild(scoreLabel)
        
        //create and add score value label
        score = 0
        scoreValueLabel.text = String(score)
        scoreValueLabel.fontSize = 50
        scoreValueLabel.fontColor = SKColor.black
        scoreValueLabel.position = CGPoint(x: size.width * 0.1, y: size.height * 0.84)
        addChild(scoreValueLabel)
        
        //add the pause button
        pauseButton.position = CGPoint(x: size.width * 0.1, y: size.height * 0.05)
        pauseButton.zPosition = 3
        pauseButton.physicsBody?.affectedByGravity = false
        pauseButton.physicsBody?.isDynamic = false
        addChild(pauseButton)
        
        //add the pause label
        pauseLabel.text = "Paused"
        pauseLabel.fontSize = 40
        pauseLabel.fontColor = SKColor.black
        pauseLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        pauseLabel.zPosition = 3
        
        //add the pause label (2nd line)
        pauseLabel2.text = "Touch Anywhere to Continue"
        pauseLabel2.fontSize = 25
        pauseLabel2.fontColor = SKColor.black
        pauseLabel2.position = CGPoint(x: size.width * 0.5, y: size.height * 0.45)
        pauseLabel2.zPosition = 3
        
        //add the continue button
        continueButton = SKSpriteNode(color: UIColor.clear,size:
            CGSize(width: size.width, height: size.height))
        continueButton?.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        continueButton?.zPosition = -2
        continueButton?.physicsBody?.affectedByGravity = false
        continueButton?.physicsBody?.isDynamic = false

        //repeatadly add cloud background images
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addCloud),
                SKAction.wait(forDuration: TimeInterval(45))
                ])
        ))
        
        //randomly add plane to background
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addPlane),
                SKAction.wait(forDuration: TimeInterval(planeFrequency()))
                ])
        ))

        //repeatadly add scarf objects to the scene
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addScarf),
                SKAction.wait(forDuration: TimeInterval(scarfFrequency()))
                ])
        ))
        
        //repeatadly add lion objects to the scene
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.wait(forDuration:
                TimeInterval(lionFrequency())),
                               SKAction.run(addLion)
                ])
        ))
        
        //repeatadly add ice cream objects to the scene
        run(SKAction.repeatForever(
            SKAction.sequence([SKAction.wait(forDuration:
                TimeInterval(iceCreamFrequency())),
                               SKAction.run(addIceCream)
                ])
        ))
        
    }
    
    //**** ADDING REPEATED OBJECTS (CLOUDS, PLANES, SCARVES, ETC) ****//
    
    func addCloud() {
        //set physics of clouds
        cloud.physicsBody?.affectedByGravity = false
        cloud.physicsBody?.isDynamic = false
        
        // Position the scarf slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        let yPos = random(min: size.height * 0.5, max: size.height * 0.7)
        cloud.position = CGPoint(x: 10, y: yPos)
        cloud.zPosition = -1
        
        //add background cloud
        addChild(cloud)
        
        let actionMove = SKAction.move(to: CGPoint(x: size.width + 100,
                                                   y: cloud.position.y), duration: 40)
        let actionMoveDone = SKAction.removeFromParent()
        cloud.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func addPlane() {
        let planeNum = ceil(random(min: 0, max: 4))
        let planeImage = "plane" + planeNum.description
        let plane = SKSpriteNode(imageNamed: planeImage)
        
        plane.position = CGPoint(x: size.width + 100, y: size.height * 0.8)
        plane.zPosition = -1
        
        addChild(plane)
        
        let actionMove = SKAction.move(to: CGPoint(x: -200, y: plane.position.y),
                                       duration: 5)
        let actionMoveDone = SKAction.removeFromParent()
        plane.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    //add the scarf to the scene at a random x-coordinate
    func addScarf() {
        let scarfNum = ceil(random(min: 0, max: 4))
        let scarfImage = "scarf" + scarfNum.description
        
        //scarf sprite object
        let scarf = SKSpriteNode(imageNamed: scarfImage)
        
        //set up the physics of the scarf
        //approximate the scarf as a circular body
        scarf.physicsBody = SKPhysicsBody(circleOfRadius: scarf.size.width/2)
        //scarf is affected by gravity
        scarf.physicsBody?.affectedByGravity = true
        //physics engine WILL control scarf movement
        scarf.physicsBody?.isDynamic = true
        //scarf does not rotate under forces
        scarf.physicsBody?.allowsRotation = false
        //set the scarf as a scarf category
        scarf.physicsBody?.categoryBitMask = PhysicsCategory.Scarf
        //will notify contact delegate when scarf is in contact
        scarf.physicsBody?.contactTestBitMask = PhysicsCategory.Giraffe
        scarf.physicsBody?.contactTestBitMask = PhysicsCategory.Floor
        //there are no coliision objects
        scarf.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Determine where to spawn the scarf along the X axis
        let actualX = random(min: scarf.size.width/2,
                             max: size.width - scarf.size.width/2)
        
        // Position the scarf slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        scarf.position = CGPoint(x: actualX, y: size.height + scarf.size.height/2)
        scarf.zPosition = 2
        
        // Add the scarf to the scene
        addChild(scarf)
    }

    func addLion() {
        //lion object
        let texturedLion = SKTexture(imageNamed: "lion")
        let lion = SKSpriteNode(texture: texturedLion)
        
        //set up physics of lion
        lion.physicsBody = SKPhysicsBody(texture: texturedLion,
                                            size: CGSize(width: lion.size.width,
                                                         height: lion.size.height))
        lion.physicsBody?.affectedByGravity = true
        lion.physicsBody?.isDynamic = true
        lion.physicsBody?.categoryBitMask = PhysicsCategory.Lion
        lion.physicsBody?.contactTestBitMask = PhysicsCategory.Giraffe
        lion.physicsBody?.contactTestBitMask = PhysicsCategory.Floor
        lion.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Determine where to spawn the lion along the X axis
        let actualX = random(min: lion.size.width/2,
                             max: size.width - lion.size.width/2)
        
        // Position the scarf slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        lion.position = CGPoint(x: actualX, y: size.height + lion.size.height/2)
        lion.zPosition = 2
        
        //add the lion
        addChild(lion)
    }
    
    func addIceCream() {
        //lion object
        let texturedIceCream = SKTexture(imageNamed: "iceCream")
        let iceCream = SKSpriteNode(texture: texturedIceCream)
        
        //set up physics of lion
        iceCream.physicsBody = SKPhysicsBody(texture: texturedIceCream,
                                         size: CGSize(width: iceCream.size.width,
                                                      height: iceCream.size.height))
        iceCream.physicsBody?.affectedByGravity = true
        iceCream.physicsBody?.isDynamic = true
        iceCream.physicsBody?.categoryBitMask = PhysicsCategory.IceCream
        iceCream.physicsBody?.contactTestBitMask = PhysicsCategory.Giraffe
        iceCream.physicsBody?.contactTestBitMask = PhysicsCategory.Floor
        iceCream.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Determine where to spawn the lion along the X axis
        let actualX = random(min: iceCream.size.width/2,
                             max: size.width - iceCream.size.width/2)
        
        // Position the scarf slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        iceCream.position = CGPoint(x: actualX, y: size.height + iceCream.size.height/2)
        iceCream.zPosition = 2
        
        //add the lion
        addChild(iceCream)
    }
    
    //**** MANAGING FREQUENCIES OF REPEATED ITEMS ****//
    
    //deterines the frequency of planes in the background
    func planeFrequency() -> CGFloat {
        return random(min: 15, max: 25)
    }
    
    //deterines the frequency of scarves falling
    func scarfFrequency() -> CGFloat {
        return random(min: 0.5, max: 1.2)
    }
    
    //deterines the frequency of scarves falling
    func lionFrequency() -> CGFloat {
        return random(min: 10, max: 15)
    }
    
    func iceCreamFrequency() -> CGFloat {
        return random(min: 10, max: 25)
    }
    
    //**** MANAGE CONTACT BETWEEN OBJECTS ****//
    
    //set up contact delegate method
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        //sort the contact bodies by increasing category bit
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        //determine what bodies have contacted
        if ((firstBody.categoryBitMask == 2) &&
            (secondBody.categoryBitMask == 3)) {
            if let scarf = firstBody.node as? SKSpriteNode {
                scarfDidReachFloor(scarf: scarf)
            }
        } else if ((firstBody.categoryBitMask == 1) &&
            (secondBody.categoryBitMask == 2)) {
            if let scarf = secondBody.node as? SKSpriteNode {
                scarfContactedGiraffe(scarf: scarf)
            }
        } else if ((firstBody.categoryBitMask == 1) &&
            (secondBody.categoryBitMask == 4)) {
            if let lion = secondBody.node as? SKSpriteNode {
                lionContactedGiraffe(lion: lion)
            }
        } else if ((firstBody.categoryBitMask == 1) &&
            (secondBody.categoryBitMask == 5)) {
            if let iceCream = secondBody.node as? SKSpriteNode {
                iceCreamContactedGiraffe(iceCream: iceCream)
            }
        } else if ((firstBody.categoryBitMask == 3) &&
            (secondBody.categoryBitMask == 4)) {
            if let lion = secondBody.node as? SKSpriteNode {
                lionDidReachFloor(lion: lion)
            }
        } else if ((firstBody.categoryBitMask == 3) &&
            (secondBody.categoryBitMask == 5)) {
            if let iceCream = secondBody.node as? SKSpriteNode {
                iceCreamDidReachFloor(iceCream: iceCream)
            }
        }
    }
    
    func scarfDidReachFloor(scarf: SKSpriteNode) {
        scarf.removeFromParent()
        lives -= 1
        updateLivesImage()
    }
    
    func lionDidReachFloor(lion: SKSpriteNode) {
        lion.removeFromParent()
    }
    
    func iceCreamDidReachFloor(iceCream: SKSpriteNode) {
        let x = iceCream.position.x
        let y = iceCream.position.y
        iceCream.removeFromParent()
        
        //add the dropped ice cream image
        let dropped = SKSpriteNode(imageNamed: "droppedIceCream")
        dropped.physicsBody?.affectedByGravity = false
        dropped.physicsBody?.isDynamic = false
        dropped.position = CGPoint(x: x, y: y - 80)
        dropped.zPosition = 0
        run(SKAction.sequence([SKAction.run{self.addChild(dropped)},
                               SKAction.wait(forDuration:
                                    TimeInterval(5)),
                               SKAction.run{dropped.removeFromParent()}
                               ]))
    }
    
    func scarfContactedGiraffe(scarf: SKSpriteNode) {
        scarf.removeFromParent()
        score += 1
        numScarves += 1
        let dy = -1.0 * Double(score) * (1.0/4.0) - 1.0
        physicsWorld.gravity = CGVector(dx: 0 , dy: dy)
        updateScoreLabel()
    }
    
    func lionContactedGiraffe(lion: SKSpriteNode) {
        lion.removeFromParent()
        lives -= 2
        updateLivesImage()
        
        let label = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        label.text = "-2 lives"
        label.fontSize = 40
        label.fontColor = UIColor.red
        label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        label.zPosition = 2
        
        addChild(label)
        
        let actionMove = SKAction.move(to: CGPoint(x: size.width * 0.55, y: size.height*0.7),
                                       duration: 1)
        let actionMoveDone = SKAction.removeFromParent()
        label.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func iceCreamContactedGiraffe(iceCream: SKSpriteNode) {
        iceCream.removeFromParent()
        score += 5
        updateScoreLabel()
        
        let label = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        label.text = "+5"
        label.fontSize = 60
        label.fontColor = UIColor.black
        label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.55)
        label.zPosition = 2
        
        addChild(label)
        
        let actionMove = SKAction.move(to: CGPoint(x: size.width * 0.55, y: size.height*0.7),
                                       duration: 1)
        let actionMoveDone = SKAction.removeFromParent()
        label.run(SKAction.sequence([actionMove, actionMoveDone]))
    }

    //**** UPDATE FUNCTIONS FOR LIVES AND SCORE ****//
    
    func updateLivesImage() {
        livesImage.removeFromParent()
        let name: String = "lives" + String(lives)
        livesImage = SKSpriteNode(imageNamed: name)
        livesImage.position = CGPoint(x: size.width * 0.8, y: size.height * 0.9)
        livesImage.zPosition = 0
        //set up physics of the lives image
        livesImage.physicsBody = SKPhysicsBody(rectangleOf: livesImage.size)
        livesImage.physicsBody?.affectedByGravity = false
        livesImage.physicsBody?.isDynamic = false
        addChild(livesImage)
        
        //control game state and transition to gameOverScene
        if (lives <= 0) {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, score: score, numScarves: numScarves)
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func updateScoreLabel() {
        scoreValueLabel.text = String(score)
    }
    
    //**** CONTROL USER TOUCH INPUT ****//
    
    //Control movement of Giraffe
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            //determine how much to move giraffe sprite
            let pointFrom = touch.previousLocation(in: self)
            let pointTo = touch.location(in: self)
            let amount = pointTo.x - pointFrom.x
            
            //move the giraffe sprite
            if (giraffe.position.x + amount > size.width) {
                giraffe.position.x = size.width
            } else if( giraffe.position.x + amount < 0) {
                giraffe.position.x = 0
            } else {
                giraffe.position.x += amount
            }
        }
    }
    
    //user pressed pause button
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            
            // Check if the location of the touch is within the button's bounds
            if (scene?.view?.isPaused == false && pauseButton.contains(location)) {
                UserDefaults.standard.set(false, forKey: "Auto-Pause")
                pauseGame()
            } else if ((continueButton?.contains(location))! && scene?.view?.isPaused == true) {
                pauseLabel.removeFromParent()
                pauseLabel2.removeFromParent()
                print("game continued")
                //resume the game scene
                scene?.view?.isPaused = false
                UserDefaults.standard.set(true, forKey: "Auto-Pause")
            } else if (floor.contains(location) && numCloudTaps == 0 && numGiraffeTaps == 0) {
                numFloorTaps += 1
                print("numFloorTaps" + String(numFloorTaps))
            } else if (cloud.contains(location) && numFloorTaps == 5 && numGiraffeTaps == 0) {
                numCloudTaps += 1
                print("numCloudTaps" + String(numCloudTaps))
            } else if (giraffe.contains(location) && numFloorTaps == 5 && numCloudTaps == 2) {
                numGiraffeTaps += 1
                print("numGiraffeTaps" + String(numGiraffeTaps))
                
                //change giraffe character if correct tap sequence (easter egg)
                if (numGiraffeTaps == 4) {
                    giraffe.removeFromParent()
                    giraffe = SKSpriteNode(imageNamed: "Spaceship")
                    //set-up spaceship
                    giraffe.position = CGPoint(x: size.width * 0.5, y: size.height * 0.2)
                    giraffe.zPosition = 1
                    //set up physics of spaceship
                    giraffe.physicsBody = SKPhysicsBody(rectangleOf: giraffe.size)
                    giraffe.physicsBody?.affectedByGravity = false
                    giraffe.physicsBody?.isDynamic = false
                    giraffe.physicsBody?.categoryBitMask = PhysicsCategory.Giraffe
                    giraffe.physicsBody?.contactTestBitMask = PhysicsCategory.Scarf
                    giraffe.physicsBody?.collisionBitMask = PhysicsCategory.None
                    addChild(giraffe)
                }
            }
        }
    }
    
    //**** MANAGE GAME PAUSE AND AUTO-PAUSE ****//
    
    //app moved to the background (auto-pause)
    func appMovedToBackground() {
        print("app moved to background")
        if (UserDefaults.standard.bool(forKey: "Auto-Pause")) {
            UserDefaults.standard.set(false, forKey: "Auto-Pause")
            pauseGame()
        }
    }
    
    func pauseGame() {
        run( SKAction.sequence([SKAction.run{self.addChild(self.pauseLabel)},
                                SKAction.run{self.addChild(self.pauseLabel2)},
                                SKAction.run{self.scene?.view?.isPaused = true}
            ])
        )
        print("game paused")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
