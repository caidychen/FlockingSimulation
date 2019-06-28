//
//  Boid.swift
//  FlockingSimulation
//
//  Created by CHEN KAIDI on 28/6/19.
//  Copyright © 2019 Quest Payment Systems. All rights reserved.
//

import SpriteKit

let boidSize: CGFloat = 15

class Boid: SKSpriteNode {
    
    private var velocity: CGVector = CGVector.random2D(length: 10)
    private var acceleration: CGVector = CGVector.init()
    private let perceptionRadius: CGFloat = 50

    private let maxSpeed: CGFloat = 5
    private let maxForce: CGFloat = 0.5
    func update() {
        position = position + velocity
        velocity = velocity + acceleration
        zRotation = velocity.angle - CGFloat(Double.pi/2)
        acceleration *= 0
    }
    
    func flock(boids: [Boid]) {
        
        let alignment = align(boids: boids)
        let cohe = cohesion(boids: boids)
        let separate = separation(boids: boids)
        
        acceleration += separate
        acceleration += alignment
        acceleration += cohe
    }
    
    func checkEdges(bounds: CGSize) {
        if position.x > bounds.width {
            position.x = 1
        } else if (position.x < 0) {
            position.x = bounds.width - 1
        }
        if position.y > bounds.height {
            position.y = 1
        } else if (position.y < 0) {
            position.y = bounds.height - 1
        }
    }
    
    private func align(boids: [Boid]) -> CGVector{
        
        var steering = CGVector()
        let localBoids = boids.filter{
            position.distanceTo($0.position) < perceptionRadius && $0 != self
        }
        localBoids.forEach { (boid) in
            steering += boid.velocity
        }
        if localBoids.count > 0 {
            steering /= CGFloat(localBoids.count)
            steering = steering.normalized() * maxSpeed
            steering -= velocity
            if steering.length() > maxForce {
                steering = steering.normalized() * maxForce
            }
        }
        return steering
    }
    
    private func cohesion(boids: [Boid]) -> CGVector{
        
        var steering = CGVector()
        let localBoids = boids.filter{
            position.distanceTo($0.position) < perceptionRadius && $0 != self
        }
        localBoids.forEach { (boid) in
            steering += CGVector(point: boid.position)
        }
        if localBoids.count > 0 {
            steering /= CGFloat(localBoids.count)
            steering -= CGVector(point: position)
            steering = steering.normalized() * maxSpeed
            steering -= velocity
            if steering.length() > maxForce {
                steering = steering.normalized() * maxForce
            }
        }
        return steering
    }
    
    private func separation(boids: [Boid]) -> CGVector{
        
        var steering = CGVector()
        let localBoids = boids.filter{
            position.distanceTo($0.position) < perceptionRadius && $0 != self
        }
        localBoids.forEach { (boid) in
            var diff = position - boid.position
            diff /= position.distanceTo(boid.position)
            steering += CGVector(point: diff)
        }
        if localBoids.count > 0 {
            steering /= CGFloat(localBoids.count)
            steering = steering.normalized() * maxSpeed
            steering -= velocity
            if steering.length() > maxForce {
                steering = steering.normalized() * maxForce
            }
            
        }
        return steering
    }
}
