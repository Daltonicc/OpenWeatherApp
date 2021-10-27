//
//  OCRViewController.swift
//  05Week_Class
//
//  Created by 박근보 on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON

class OCRViewController: UIViewController {

    @IBOutlet weak var opticalImageView: UIImageView!
    @IBOutlet weak var changedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func changeButtonClicked(_ sender: UIButton) {
   
        guard let text = changedTextView.text else { return }
        OCRAPIManager.shared.fetchtextData(image: opticalImageView.image!) { code, json in
            
            switch code {
            case 200:
                print(json)
                
                for i in 0..<json["result"].count {
                    let answer = json["result"][i]["recognition_words"][0].stringValue
                    
                    self.changedTextView.text += "\n"
                    self.changedTextView.text += answer
                }
                
            case 400:
                print(json)
            
            default:
                print("ERROR")
            }
        }
        
    }
    
    
}
