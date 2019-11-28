//
//  main.swift
//  hms-seconds
//
//  Created by Gene De Lisa on 11/27/19.
//  Copyright © 2019 Gene De Lisa. All rights reserved.
//

import Foundation

struct HMS2Seconds {
    var hms: String
    var isVerbose = false
    
    func hmsToSeconds() -> Int {
        
        if isVerbose {
            print("parsing hms input: \(hms)")
        }
        
        let componentArray = hms.split(separator: ":")
        if componentArray.count != 3 {
            print("Error: \(hms) is invalid. Must have 3 components: hours, minutes, and seconds.")
            exit(EXIT_FAILURE)
        }
        guard let h = Int(componentArray[0]),
            let m = Int(componentArray[1]),
            let s = Int(componentArray[2]) else {
                print("Error \(hms) is invalid")
                exit(EXIT_FAILURE)
        }
        
        if isVerbose {
            print("h \(h) m \(m) s \(s)")
        }
        
        let ms = m * 60
        let hs = h * 60 * 60
        let totalSeconds = s + ms  + hs
        return totalSeconds
    }
}

let ap = TSCArgumentParser()
ap.crack()

exit(EXIT_SUCCESS)


/*
 if CommandLine.argc > 1 {
 let hms = CommandLine.arguments[1]
 } else {
 print("specify input. hh:mm:ss")
 exit(EXIT_FAILURE)
 }
 */
