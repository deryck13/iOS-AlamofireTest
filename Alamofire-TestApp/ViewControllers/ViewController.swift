//
//  ViewController.swift
//  Alamofire-TestApp
//
//  Created by Yck on 01/01/18.
//  Copyright © 2018 Yck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    let network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func onStopButtonPress(_ sender: UIButton) {
        network.stopDownload()
    }
    
    @IBAction func onStartButtonPress(_ sender: UIButton) {
        
        if network.savedData == nil {
            
            network.downloadImageFromURL(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3d/LARGE_elevation.jpg")!) { response in
                let image2 = UIImage(data: response)
                
                DispatchQueue.main.async {
                    self.image.image = image2
                }
            }
        } else {
            
            network.resumeDownload() { response in
                let image2 = UIImage(data: response)
                
                DispatchQueue.main.async {
                    self.image.image = image2
                }
            }
        }
    }

}

