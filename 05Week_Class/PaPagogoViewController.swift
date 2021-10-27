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
    
    var translateText: String = "" {
        didSet {
            targetTextView.text = translateText
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        targetTextView.textColor = .black
        
    }
    

    @IBAction func translateButtonClicked(_ sender: UIButton) {
        
        
        //옵셔널 해제 방법 1. 옵셔널 바인딩(guard와 차이점. if let 안의 상수 value는 해당 중괄호 안에서만 사용가능
//        if let value = sourceTextView.text {
//            TranslatedAPIManager.shared.fetchTranslateData(text: value, result: <#T##(String) -> ()#>)
//        }
        
        //2. guard 구문( 상수 text는 아래에서 언제든 사용가능)(탈출 클로저 흐름 파악하기. 복습 필요)
        guard let text = sourceTextView.text else { return }
        TranslatedAPIManager.shared.fetchTranslateData(text: text) { code, json in
            
            switch code {
            case 200:
                print(json)
//                self.targetTextView.text 요렇게도 가능
                self.translateText = json["message"]["result"]["translatedText"].stringValue
            case 400:
                print(json)
                self.translateText = json["errorMessage"].stringValue
            default:
                print("ERROR")
            }
        }
            
    }

    
    

}

