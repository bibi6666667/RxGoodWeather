//
//  ViewController.swift
//  GoodWeather
//
//  Created by Bibi on 2022/12/28.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temeratureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { [weak self] city in
                if let city = city {
                    if city.isEmpty {
                        self?.displayWeather(nil)
                    } else {
                        self?.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
    }

    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            self.temeratureLabel.text = "\(weather.temp) ℃"
            self.humidityLabel.text = "\(weather.humidity) %"
        } else {
            self.temeratureLabel.text = "🌡"
            self.humidityLabel.text = "💦"
        }
    }

    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded)// 도시 이름에 띄어쓰기가 있는 경우, 띄어쓰기를 %로 인코딩한다
              else {
            return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        // resource를 만들면 URLSessionExtension을 사용할 수 있다.
        URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance) // UI작업 시 DispatchQueue.main.async 대신 사용하는 Rx기능
            .catchErrorJustReturn(WeatherResult.empty) // 도시 키워드가 잘못되어 응답이 실패하면, 대신 빈 Weather 객체를 반환한다
            .subscribe(onNext: { result in
                let weather = result.main
                self.displayWeather(weather)
            }).disposed(by: disposeBag)
        
    }

}

