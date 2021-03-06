//
//  VisionViewController.swift
//  05Week_Class
//
//  Created by 박근보 on 2021/10/27.
//

import UIKit

class VisionViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        VisionAPIManager.shared.fetchFaceData(image: postImageView.image!) { code, json in
            print(json)
        }
        
    }
    
    
}
