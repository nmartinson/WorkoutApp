//
//  AccelerometerFilter.swift
//  WorkoutApp
//
//  Created by Nick on 11/7/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import CoreMotion

class AccelerometerFilter
{
	static let kAccelerometerMinStep = 0.02
    static let kAccelerometerNoiseAttenuation = 3.0
    var filterConstant = 0.0
    
    init(rate:Double, cutOffFreq:Double)
    {
        let dt = 1.0/rate
        let RC = 1.0/cutOffFreq
        filterConstant = dt/(dt + RC)
    }
    
    func clamp(v: Double, min: Double, max: Double) -> Double
    {
        if(v > max) {
        	return max
        } else if(v < min) {
        	return min
        } else {
        	return v
        }
    }
    
    func norm(x: Double, y: Double, z: Double) -> Double
    {
        return sqrt(x * x + y * y + z * z)
    }
    
    func lowPass(accel: CMAccelerometerData) -> (Double, Double, Double)
    {
		let xRaw = accel.acceleration.x
        let yRaw = accel.acceleration.y
        let zRaw = accel.acceleration.z
        
        let x = xRaw * filterConstant + xRaw * (1.0 - filterConstant)
        let y = yRaw * filterConstant + yRaw * (1.0 - filterConstant)
        let z = zRaw * filterConstant + zRaw * (1.0 - filterConstant)

		return (x, y, z)
    }
}