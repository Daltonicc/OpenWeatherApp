//
//  TranslatedAPIManager.swift
//  05Week_Class
//
//  Created by 박근보 on 2021/10/27.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranslatedAPIManager {
    
    static let shared = TranslatedAPIManager()
    
    //타입 별칭 부여
    typealias CompletionHandler = (Int, JSON) -> ()
    
    //탈출 클로저 구현
    func fetchTranslateData(text: String, result: @escaping (Int, JSON) -> () ) {
        
        let url2 = EndPoint.translatedURL
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.NAVER_ID,
            "X-Naver-Client-Secret": APIKey.NAVER_SECRET
        ]
        
        //소스텍스트 뷰를 받아올 수 없으므로 매개변수로 활용!
        let parameters = [
            "source": "ko",
            "target": "en",
            "text": text // sourceTextView.text 불가능.
        ]
        
        //1. status code 넣어주면 상세하게 뭐 때문에 오류인지 확인 가능
        //2. 상태 코드 분기
        AF.request(url2, method: .post, parameters: parameters ,headers: header).validate(statusCode: 200...500).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                let code = response.response?.statusCode ?? 500
                
                result(code, json)

                
            case .failure(let error):
                print(error)
            }
        }

    }
    
}
