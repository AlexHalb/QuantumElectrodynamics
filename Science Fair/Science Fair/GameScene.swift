//
//  GameScene.swift
//  Science Fair
//
//  Created by Alex H on 2/13/20.
//  Copyright © 2020 Holy Spirit High School. All rights reserved.
//

import SpriteKit //Handles particles and motion.

class GameScene: SKScene { //Scene where all events take place
    override func sceneDidLoad() { //When the scene loads...
        checkUpdates() //Set the variables to their proper settings
    }
    //The particles
    private var photon1 : SKSpriteNode?
    private var photon2 : SKSpriteNode?
    private var electron1 : SKSpriteNode?
    private var electron2 : SKSpriteNode?
    override func didMove(to view: SKView) { //On startup...
        //Setting up the particles
        self.photon1 = self.childNode(withName: "photon1") as? SKSpriteNode
        self.photon2 = self.childNode(withName: "photon2") as? SKSpriteNode
        self.electron1 = self.childNode(withName: "electron1") as? SKSpriteNode
        self.electron2 = self.childNode(withName: "electron2") as? SKSpriteNode
        let settingsTimer = Timer(timeInterval: 0.5, target: self, selector: #selector(checkUpdates), userInfo: nil, repeats: true) //A timer to check for updates regularly
        RunLoop.current.add(settingsTimer, forMode: .default) //Starts settings timer
        let pausedTimer = Timer(timeInterval: 0.1, target: self, selector: #selector(checkPaused), userInfo: nil, repeats: true) //A timer to check if paused. Checks more regularly than other timer
        RunLoop.current.add(pausedTimer, forMode: .default) //Starts above timer
    }
    func electronWaveFunction(x:Double, a:Double, c:Double)->Double{ //Generates a function that determines the likelihood of the electron going certain places
        //This is a function that creates a bell shape where the electron is currently located and a dip where the other electron is located. This means the electron is more likely to stay close to where it is and is less likely to go near the other electron.
        let e = 2.72 //Some constants
        let g = 4.5
        let b = 700.0
        let d = 100.0
        //This part creates a bell shape where the electron is
        let firstBellNumerator = (x-a)*(x-a)
        let firstBellExponent = 0-firstBellNumerator/b
        let firstBell = pow(e, firstBellExponent)
        //This part creates a dip in probability where the other electron is
        var secondBell = 0.0
        if exclusion { //If exclusion is enabled...
            let secondBellNumerator = (x-c)*(x-c) //Create a dip in porbability where the other electron is
            let secondBellExponent = 0-secondBellNumerator/d
            secondBell = pow(e, secondBellExponent)
            //If exclusion is not enabled, the above code will do nothing. It will not affect the probability
        }
        return firstBell-(5*secondBell)+g //Adding the parts together. It also uses one of the constants above.
    }
    func photonWaveFunction(x:Double)->Double{ //The same as the above function, but for the photons
        //Since photons have no mass and travel at the speed of light, they have equal probability to go anywhere
        return 1/700.0
    }
    func electronCalculation(){ //Deciding where the electron will go and moving it there
        //Setting up variables
        var array1x = Array<Double>() //Probabilities for electron 1, x axis
        var array1y = Array<Double>() //Electron 2, y axis
        var array2x = Array<Double>() //And so on
        var array2y = Array<Double>()
        let electron1x = Double(electron1?.position.x ?? 0.0) //These are variables that make the positions of the electrons easier to access
        let electron1y = Double(electron1?.position.y ?? 0.0)
        let electron2x = Double(electron2?.position.x ?? 0.0)
        let electron2y = Double(electron2?.position.y ?? 0.0)
        for i in 0...799 { //Getting probability for x axis for first electron
            array1x.append(electronWaveFunction(x: Double(i), a: electron1x, c: electron2x)*Double.random(in: 0.5...1.5)) //Adds wave function with randomness to probability array
        }
        for i in 0...599 {//y axis, first electron
            array1y.append(electronWaveFunction(x: Double(i), a: electron1y, c: electron2y)*Double.random(in: 0.5...1.5))
        }
        for i in 0...799 {//x axis, second electron
            array2x.append(electronWaveFunction(x: Double(i), a: electron2x, c: electron1x)*Double.random(in: 0.5...1.5))
        }
        for i in 0...599 {//y axis, second electron
            array2y.append(electronWaveFunction(x: Double(i), a: electron2y, c: electron1y)*Double.random(in: 0.5...1.5))
        }
        if let (maxIndex, _) = array1x.enumerated().max(by: { $0.element < $1.element }) { //Determining where electron 1 will go on the x axis based on the probability functions gathered above
            let x = shrink(Double(maxIndex)) //Rounding the number to improve performance
            electron1?.run(SKAction.moveTo(x: CGFloat(x)-400, duration: 1/20)) //Moving it there
        }
        if let (maxIndex, _) = array1y.enumerated().max(by: { $0.element < $1.element }) { //Electron 1, y axis
            let y = shrink(Double(maxIndex))
            electron1?.run(SKAction.moveTo(y: CGFloat(y)-300, duration: 1/20))
        }
        if let (maxIndex, _) = array2x.enumerated().max(by: { $0.element < $1.element }) { //Electron 2, x axis
            let x = shrink(Double(maxIndex))
            electron2?.run(SKAction.moveTo(x: CGFloat(x)-400, duration: 1/20))
        }
        if let (maxIndex, _) = array2y.enumerated().max(by: { $0.element < $1.element }) { //Electron 2, y axis
            let y = shrink(Double(maxIndex))
            electron2?.run(SKAction.moveTo(y: CGFloat(y)-300, duration: 1/20))
        }
    }
    func photonCalculation(){ //Deciding whre the photon will go and moving it there
        var array1x = Array<Double>() //Probabilities for photon 1, x axis
        var array1y = Array<Double>() //Photon 1, y axis
        var array2x = Array<Double>() //And so on
        var array2y = Array<Double>()
        for i in 0...799 { //Getting all probabilities for the first photon, x axis
            array1x.append(photonWaveFunction(x: Double(i))*Double.random(in: 0.5...1.5)) //Adds wave function with some randomness sprinkled in to array of probabilities
        }
        for i in 0...599 { //Photon 1, y axis
            array1y.append(photonWaveFunction(x: Double(i))*Double.random(in: 0.5...1.5))
        }
        for i in 0...799 { //Photon 2, x axis
            array2x.append(photonWaveFunction(x: Double(i))*Double.random(in: 0.5...1.5))
        }
        for i in 0...599 { //Photon 2, y axis
            array2y.append(photonWaveFunction(x: Double(i))*Double.random(in: 0.5...1.5))
        }
        if let (maxIndex, _) = array1x.enumerated().max(by: { $0.element < $1.element }) { //Choosing where photon 1 will go on the x axis based on array if wave fucntion
            let x = shrink(Double(maxIndex)) //Rounding to improve performance
            photon1?.run(SKAction.moveTo(x: CGFloat(x)-400, duration: 1/20)) //Moving the photon
        }
        if let (maxIndex, _) = array1y.enumerated().max(by: { $0.element < $1.element }) { //Photon 1, y axis
            let y = shrink(Double(maxIndex))
            photon1?.run(SKAction.moveTo(y: CGFloat(y)-300, duration: 1/20))
        }
        if let (maxIndex, _) = array2x.enumerated().max(by: { $0.element < $1.element }) { //Photon 2, x axis
            let x = shrink(Double(maxIndex))
            photon2?.run(SKAction.moveTo(x: CGFloat(x)-400, duration: 1/20))
        }
        if let (maxIndex, _) = array2y.enumerated().max(by: { $0.element < $1.element }) { //Photon 2, y axis
            let y = shrink(Double(maxIndex))
            photon2?.run(SKAction.moveTo(y: CGFloat(y)-300, duration: 1/20))
        }
    }
    var electron1photon : Bool = false //Whether the first electron has absorbed a photon
    var electron2photon : Bool = false //Whether the second electron has absorbed a photon
    func absorptionCalculation(){ //Determining whether the electrons absorb photons
        if let p1 = photon1?.position, let p2 = photon2?.position, let e1 = electron1?.position, let e2 = electron2?.position { //Making shorter names for each position for easier access. Also makes sure the program won't crash.
            if (CGPointDistance(from: p1, to: e1)<5){ //If photon 1 and electron 1 are at the same location
                photon1?.isHidden = true //Photon 1 is absorbed
                electron1photon = true //Electron 1 has absorbed a photon
            }
            if (CGPointDistance(from: p2, to: e1)<5){ //Photon 2, electron 1
                photon2?.isHidden = true
                electron1photon = true
            }
            if (CGPointDistance(from: p1, to: e2)<5){ //Photon 1, electron 2
                photon1?.isHidden = true
                electron2photon = true
            }
            if (CGPointDistance(from: p2, to: e2)<5){ //Photon 2, electron 2
                photon2?.isHidden = true
                electron2photon = true
            }
        }
    }
    func emissionCalculation(){ //Determines whether the electrons emit any photons absorbed
        switch Array(0...249).randomElement() { //Chooses a random number from 1 to 250
        case 0 : //If the number is 1
            if (electron1photon && photon1?.isHidden ?? false) { //Checking that electron 1 has absorbed photon 1
                electron1photon = false //The electron emits the photon
                photon1?.isHidden = false //The photon has been emitted
            }
        case 1 : //If 2
            if (electron1photon && photon2?.isHidden ?? false) { //Electron 1, photon 2
            electron1photon = false
            photon2?.isHidden = false
        }
        case 2 : //If 3
            if (electron2photon && photon1?.isHidden ?? false) { //Electron 2, photon 1
            electron2photon = false
            photon1?.isHidden = false
        }
        case 3 : //If 4
            if (electron2photon && photon2?.isHidden ?? false) { //Electron 2, photon 2
            electron2photon = false
            photon2?.isHidden = false
        }
        default : return //If the number is not one of those, do nothing
        }
    }
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat { //A helper function that finds distances
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y) //Distance formula without the square root
    }
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat { //A helper function that finds distances
        return sqrt(CGPointDistanceSquared(from: from, to: to)) //Uses the square root of the above function
    }
    func shrink(_ d:Double)->Double { //Rounds numbers to improve performance
        let x = Int(d) //Making the input an integer
        return Double((x/5)*5) //The way integer division works in Swift allows for easy rounding.
    }
    override func update(_ currentTime: TimeInterval) { //Each frame, run the following...
        if !simulationPaused { //If not paused...
            electronCalculation() //Move the electrons
            photonCalculation() //Move the photons
            if absorption { //If absorption enabled in settings...
                absorptionCalculation() //Absorb photons
            }
            if emission { //If emission enabled in settings...
             emissionCalculation() //Emit photons
            }
        }
    }
    @objc func checkUpdates(){ //Checking to see if settings has updated
        emission = UserDefaults.standard.bool(forKey: "emission") //Checking emission setting
        absorption = UserDefaults.standard.bool(forKey: "absorption") //Absorption setting
        exclusion = UserDefaults.standard.bool(forKey: "exclusion") //And so on
    }
    @objc func checkPaused(){ //Checks to see if paused
        simulationPaused = UserDefaults.standard.bool(forKey: "paused")
    }
    //Settings storage
    var emission : Bool = true
    var absorption : Bool = true
    var exclusion : Bool = true
    var simulationPaused : Bool = true
}
