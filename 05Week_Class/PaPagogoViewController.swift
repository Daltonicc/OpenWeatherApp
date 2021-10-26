//
//  PaPagogoViewController.swift
//  05Week_Class
//
//  Created by 박근보 on 2021/10/26.
//

import UIKit
import Alamofire
import SwiftyJSON

class PaPagogoViewController: UIViewController {

    @IBOutlet weak var sourceTextView: UITextView!
    @IBOutlet weak var targetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        targetTextView.textColor = .black
        
    }
    

    @IBAction func translateButtonClicked(_ sender: UIButton) {
        
        let url2 = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "FBAeES11vzmYievJ_ocV",
            "X-Naver-Client-Secret": "DLjCcp4V3M"
        ]
        
        let parameters = [
            "source": "ko",
            "target": "en",
            "text": sourceTextView.text!
        ]
        
        AF.request(url2, method: .post, parameters: parameters ,headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                //확인 필요
                let text = json["message"]["result"]["translatedText"].stringValue
                self.targetTextView.text! = text
                
            case .failure(let error):
                print(error)
            }
        }

    }
    

}

