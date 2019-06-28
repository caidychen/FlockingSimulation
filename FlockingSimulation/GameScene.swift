//
//  GameScene.swift
//  FlockingSimulation
//
//  Created by KD Chen on 28/6/19.
//  Copyright © 2019 Quest Payment Systems. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private let frameRate: Double = 60.0
    private var lastUpdateTimeInterval: CFTimeInterval = 0
    private var boids: [Boid] = []
    private var lastUpdateTime: CFTimeInterval = 0  // Time when update() was last called
    override func didMove(to view: SKView) {
        backgroundColor = .black
        reset()
    }
    
    private func reset() {
        boids.removeAll()
        children.forEach{$0.removeFromParent()}
        for _ in 0..<100 {
            let boid = Boid(imageNamed:"boid.png")
            boid.size = CGSize(width: boidSize, height: boidSize)
            boid.position = CGPoint(
                x: CGFloat(arc4random_uniform(UInt32(frame.width))),
                y: CGFloat((arc4random_uniform(UInt32(frame.height))))
            )
            addChild(boid)
            boids.append(boid)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        reset()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        var delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if delta > 1 {
            delta = 1.0 / frameRate
            lastUpdateTime = currentTime
        }
        updateSynced(delta)
        
    }
    
    private func updateSynced(_ delta: TimeInterval) {
        boids.forEach{
            $0.checkEdges(bounds: frame.size)
            $0.flock(boids: boids)
            $0.update()
        }
    }
}
