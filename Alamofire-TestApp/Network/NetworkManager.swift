//
//  NetworkManager.swift
//  Alamofire-TestApp
//
//  Created by Yck on 01/01/18.
//  Copyright © 2018 Yck. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {

    let workQueue = DispatchQueue(label: Network.dispatchWorkerQueueName)
    
    var savedData: Data?
    var downloadRequest: DownloadRequest?
 
    func downloadImageFromURL(url: URL, completionHandler:@escaping(_ response: Data) -> Void) {
        
//        Alamofire.request(url)
//            .validate(statusCode: 200..<300)
//            .downloadProgress() { progress in
//                print("Progress: \(progress.fractionCompleted * 100)")
//            }
//            .responseData(queue: workQueue) { response in
//
//                switch response.result {
//                case .success(let data):
//                    completionHandler(data)
//
//                case .failure(let error):
//                    print("error downloading image:", error)
//                    break
//                }
//            }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
            let fileURL = documentsURL.appendingPathComponent("image.png")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        self.downloadRequest = Alamofire.download(url, to: destination)
            .validate(statusCode: 200..<300)
            .downloadProgress() { progress in
                
                print("Progress: \(progress.fractionCompleted * 100)")
            }
            .responseData(queue: workQueue) { response in
                
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                    
                case .failure(let error):
                    print("error downloading image:", error)
                    self.savedData = response.resumeData
                    
                    break
                }
        }
    }
    
    func resumeDownload(completionHandler:@escaping(_ response: Data) -> Void) {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
            let fileURL = documentsURL.appendingPathComponent("image.png")
            
            return (fileURL, [.createIntermediateDirectories])
        }
        
        self.downloadRequest = Alamofire.download(resumingWith: self.savedData!, to: destination)
            .validate(statusCode: 200..<300)
            .downloadProgress() { progress in
                print("Progress resumes: \(progress.fractionCompleted * 100)")
            }
            .responseData(queue: workQueue) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                    
                case .failure(let error):
                    print("error downloading image:", error)
                    self.savedData = response.resumeData
                    
                    break
                }
        }
        
    }
    
    func stopDownload() {
        self.downloadRequest?.cancel()
    }

}
