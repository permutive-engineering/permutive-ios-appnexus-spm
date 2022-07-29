//
//  ElapsedTimer.swift
//  permutive-ios
//
//  Created by Christopher Gibson on 28/04/2020.
//  Copyright © 2020 Permutive. All rights reserved.
//

import Foundation

class ElapsedTimer {
    private(set) var startTime: DispatchTime

    init() {
        startTime = DispatchTime.now()
    }

    func start() {
        startTime = DispatchTime.now()
    }

    var duration: TimeInterval {
        let nanoTime = DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds
        return TimeInterval(Double(nanoTime) / 1000000000)
    }
}

func measure(_ block: () throws -> Void) rethrows -> TimeInterval {
    let timer = ElapsedTimer()
    try block()
    return timer.duration
}

func measure(_ function: @autoclosure () throws -> Void) rethrows -> TimeInterval {
    let timer = ElapsedTimer()
    try function()
    return timer.duration
}
