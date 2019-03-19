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


public let mojeModra = UIColor(displayP3Red: 40/255, green: 100/255, blue: 150/255, alpha: 1)
public let mojeCervena = UIColor(displayP3Red: 195/255, green: 83/255, blue: 75/255, alpha: 1)


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
            print("Mám sound files pro meditaci ID: ", id)
            return true
        } else {
            return false
        }
    }else{
        print("Nemám url při hledání sound files.")
        return false
    }
}


public func deleteSoundFiles(id: Int) -> Bool{
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent("\(id)_slovo.mp3"), let pathComponent2 = url.appendingPathComponent("\(id)_hudba.mp3") {
        let filePath = pathComponent.path
        let filePath2 = pathComponent2.path
        let fileManager = FileManager.default
        
        do{
            try fileManager.removeItem(atPath: filePath)
            try fileManager.removeItem(atPath: filePath2)
            return true
        }catch{
            print(error)
            return false
        }

    }else{
        print("Nemám URL při mazání filu")
        return false
    }
}


public func cancelAllAlamofireRequests(){
    Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
        sessionDataTask.forEach { $0.cancel() }
        uploadData.forEach { $0.cancel() }
        downloadData.forEach { $0.cancel() }
    }
}
