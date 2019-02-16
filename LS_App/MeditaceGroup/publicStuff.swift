//
//  publicStuff.swift
//  LS_App
//
//  Created by Boocha on 16.02.19.
//  Copyright © 2019 Boocha. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


public func checkInternet() -> Bool{
    let internetManager = NetworkReachabilityManager()

    if internetManager!.isReachable{
        return true
    }else{
        return false
    }
}

public func checkSoundFiles(id: Int) -> Bool{
    //check, jestli se v dokumentech nacházejí oba soubory pro hudbu i slovo
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent("\(id)_slovo.mp3"), let pathComponent2 = url.appendingPathComponent("\(id)_hudba.mp3") {
        let filePath = pathComponent.path
        let filePath2 = pathComponent2.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath), fileManager.fileExists(atPath: filePath2) {
            print("Mám sound file pro meditaci ID: ", id)
            return true
        } else {
            print("Nemám sound file pro meditaci ID: ", id)
            return false
        }
    }else{
        print("Nemám url při hledání sound files.")
        return false
    }
}
