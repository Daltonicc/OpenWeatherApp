//
//  ViewController.swift
//  05Week_Class
//
//  Created by 박근보 on 2021/10/25.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit
import SwiftUI
import Kingfisher

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var happyLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        labelSetting(label: currentTempLabel)
        labelSetting(label: windSpeedLabel)
        labelSetting(label: humidityLabel)
        labelSetting(label: happyLabel)
        weatherImageSetting()
        
        getCurrentWeather()
        renewBarButtonSetting()
        getCoordinte(CLLocation(latitude: 37.513803, longitude: 126.941529))
        
//        mapView.delegate = self
        locationManager.delegate = self
        
    }

    func getCurrentWeather() {
        
        //리퀘스트하고 유효성검사하고 JSON으로 응답한다!(요걸 SwiftyJSON 라이브러리가 도와줌)
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
                
                //네트워크 통신 성공
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //캘빈 온도라서 결과값에 -273.15도 해줘야함
                let currentTemp = json["main"]["temp"].doubleValue - 273.15
                let windSpeed = json["wind"]["spped"].doubleValue
                let humidity = json["main"]["humidity"].doubleValue
                let icon = json["weather"][0]["icon"].stringValue
                
                let imageurl = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
                self.weatherImageView.kf.setImage(with: imageurl)
                
                //대괄호에 감싸져있는애 값 가져오기
                let id = json["weather"][0]["main"].stringValue
                
                print(id)
                self.currentTempLabel.text = " 지금은 \(Int(currentTemp))℃ 입니다   "
                self.windSpeedLabel.text = " \(Int(windSpeed))m/s의 바람이 불어요   "
                self.humidityLabel.text = " \(Int(humidity))% 만큼 습해요   "
                
                //네트워크 통신 실패
            case .failure(let error):
                print(error)
            
            }
        }
        
    }
    
    func weatherImageSetting() {
        
        weatherImageView.backgroundColor = .white
        weatherImageView.layer.borderColor = UIColor.black.cgColor
        weatherImageView.layer.borderWidth = 1
        weatherImageView.layer.cornerRadius = 10
        
    }
    
    func labelSetting(label: UILabel) {
        
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 10
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        
        dateLabel.text = "10월 26일"
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        
        locationLabel.font = UIFont.systemFont(ofSize: 20)
        
        happyLabel.text = " 오늘도 행복한 하루 보내세요  "
    }
    
    func getCoordinte(_ coordinate: CLLocation) {
      let geoCoder = CLGeocoder()
      
      geoCoder.reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) in
        if let address: [CLPlacemark] = placemarks {
          guard let city: String = address.last?.administrativeArea else { return }
          guard let gu: String = address.last?.locality else { return }
          
          self.locationLabel.text = "\(city), \(gu)"
        }
      })
    }
    
    func renewBarButtonSetting() {
        
        let renewBarButton = UIBarButtonItem(title: "갱신", style: .plain, target: self, action: #selector(renewButtonAction))
        renewBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = renewBarButton
        
    }
    
    @objc func renewButtonAction() {
        
        let alert = UIAlertController(title: "위치 권한을 허용해주세요!", message: "권한을 허용하지 않으면 접근하실 수 없습니다.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "허용", style: .default) { _ in
            
            guard let settingurl = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingurl)
            
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    //9. iOS 버전에 따른 분기 처리와 iOS 위치 서비스 확인
    func checkUserLocationServicesAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
        authorizationStatus = locationManager.authorizationStatus // iOS14 이상에만 사용 가능
        } else {
        authorizationStatus = CLLocationManager.authorizationStatus() // iOS 14미만
        }
        
        //iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            //권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요!")
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() // 위치 접근 시작! -> didUpdateLocations 실행
            
        case .restricted, .denied:
            print("DENIED, 설정으로 유도")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            print("ALWAYS")
        @unknown default:
            print("DEFAULT")
        }
        
        if #available(iOS 14.0, *) {
            //정확도 체크: 정확도 감소가 되어 있을경우, 1시간 4번 , 미리 알림 , 배터리 오래 쓸 수 있음. 워치8
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .fullAccuracy:
                print("FULL")
            case .reducedAccuracy:
                print("REDUCE")
            @unknown default:
                print("DEFAULT")
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            
            
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
//            mapView.setRegion(region, animated: true)
            
            locationManager.startUpdatingLocation()
        } else {
            print("Cannot find location")
        }
    }
    
    //5. 위치 접근이 실패했을 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //6. iOS14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    //7. iOS14 미만: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
}

extension ViewController: MKMapViewDelegate {
    
    
}

//맵뷰가 없는 상태에서는 위치권한 설정을 활성화 시킬 수 없나?
//커스텀위치의 좌표를 받아서 구체적인 지명을 넣어주려 했으나 실패.
//날짜와 시간정보는 서버통신할 필요없이 값을 내부적으로 받아올 수 있을꺼 같은데 추후 확인 필요.
