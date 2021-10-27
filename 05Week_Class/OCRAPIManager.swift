//
//  OCRAPIManager.swift
//  05Week_Class
//
//  Created by 박근보 on 2021/10/27.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class OCRAPIManager {
    
    static let shared = OCRAPIManager()
    
    func fetchtextData(image: UIImage, result: @escaping (Int, JSON) -> () ) {
        
        let header: HTTPHeaders = [
            "Authorization": APIKey.KAKAO,
            "Content-Type": "multipart/form-data"
        ]
        
        //UIImage를 바이너리 타입으로 변환해줘야 함!. 이미지 그대로 넣어줄 수 없음.
        guard let imageData = image.pngData() else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image", fileName: "image")
        }, to: EndPoint.opticalURL, headers: header)
            .validate(statusCode: 200...500).responseJSON { response in
                
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
