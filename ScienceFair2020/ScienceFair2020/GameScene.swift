//
//  GameScene.swift
//  ScienceFair2020
//
//  Created by Alex Halbesleben on 10/21/19.
//  Copyright © 2019 Alex Halbesleben. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var photon : SKShapeNode?
    private var electron : SKShapeNode?
    override func didMove(to view: SKView) {
        photon = self.childNode(withName: "photon") as? SKShapeNode
        electron = self.childNode(withName: "electron") as? SKShapeNode
    }
    func touchDown(atPoint pos : CGPoint) {
    }
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    func wavefunction(_ x:CGFloat)->CGFloat{
        let function = ((sin(x)*cos(x)*tan(x))/(0.75))
        let amplitude = function*function
        return amplitude
    }
    func wavefunctiony(_ x:CGFloat)->CGFloat{
        let function = ((sin(x)*cos(x)*tan(x))/(0.75))
        let amplitude = function*function
        return amplitude
    }
    func clock(x:CGFloat, y:CGFloat)->CGFloat{
        var finalX : CGFloat = 0.0
        var finalY : CGFloat = 0.0
        for i in -1...1 {
            for j in -1...1 {
                let dist = CGPointDistance(from: electron!.position, to: CGPoint(x: x+CGFloat(i), y: y+(CGFloat(j))))
                let t : CGFloat = 1.0/60.0
                let m : CGFloat = 9.10938e-28
                let action = (m*dist*dist)/(t*6.62607015e-34*2)
                let amplitude : CGFloat = 1/sqrt(600*800/100)
                let wind = action.truncatingRemainder(dividingBy: 1)
                let degrees = wind*360
                let cx = amplitude * cos(degrees)
                let cy = amplitude * sin(degrees)
                finalX += cx
                finalY += cy
            }
        }
        return finalX*finalX+finalY*finalY
    }
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    override func update(_ currentTime: TimeInterval) {
        var array: [CGFloat] = []
        for i in 1...40 {
            let randomArray = [0.8,0.85,0.9,0.95,1.1,1.15,1.2,1.25]
            let wf = wavefunction(CGFloat(i))*CGFloat(randomArray.randomElement()!)
            array.append(wf)
        }
        if let (maxIndex, _) = array.enumerated().max(by: { $0.element < $1.element }) {
            photon?.run(SKAction.moveTo(x: CGFloat(maxIndex*20)-400, duration: 1/20))
        }
        var arrayy: [CGFloat] = []
        for i in 1...30 {
            let randomArray = [0.8,0.85,0.9,0.95,1.1,1.15,1.2,1.25]
            let wf = wavefunction(CGFloat(i))*CGFloat(randomArray.randomElement()!)
            arrayy.append(wf)
        }
        if let (maxIndex, _) = arrayy.enumerated().max(by: { $0.element < $1.element }) {
            photon?.run(SKAction.moveTo(y: CGFloat(maxIndex*20)-300, duration: 1/20))
        }
        var array2 : [CGFloat] = []
        for i in 1...40 {
            for j in 1...30 {
                let randomArray : [CGFloat] = [0.9,0.95,1,1.05,1.1]
                array2.append(clock(x: CGFloat(i), y: CGFloat(j))*randomArray.randomElement()!)
            }
        }
        if let (maxIndex, _) = array2.enumerated().max(by: { $0.element < $1.element }) {
            let x = maxIndex/60
            let y = Double(maxIndex).truncatingRemainder(dividingBy: 60.0)
            electron?.run(SKAction.moveTo(x: CGFloat(x*10)-400, duration: 1/20))
            electron?.run(SKAction.moveTo(y: CGFloat(y*10)-300, duration: 1/20))
        }
        if (CGPointDistance(from: electron!.position, to: photon!.position) < 75) {
            photon?.isHidden = true
        }
        if (photon!.isHidden) {
            if (Array(0...49).randomElement() == 0){
                photon?.isHidden = false
            }
        }
    }
}
