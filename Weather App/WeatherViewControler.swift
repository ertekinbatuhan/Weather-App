//
//  ViewController.swift
//  Weather App
//
//  Created by Batuhan Berk Ertekin on 7.12.2023.
//

import UIKit

class WeatherViewControler: UIViewController {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentTempValue: UILabel!
    @IBOutlet weak var feelsValue: UILabel!
    @IBOutlet weak var windSpeedValue: UILabel!
    
    let apiKey = "e210c2f8346604939fdadc0e17c3be14"
    
    var searchWord: String? {
           didSet {
               loadWeather()
           }
       }
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.delegate = self
        loadWeather()
        
    }
 
        func loadWeather() {
            
            guard let searchWord = searchWord, !searchWord.isEmpty else {
                       return
                   }
            
                  let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(searchWord)&appid=\(apiKey)")
                  let session = URLSession.shared
                  let task = session.dataTask(with: url!) { data , response , error in
                      
                      if error != nil {
                          print(error?.localizedDescription)
                      } else {
                          
                          if data != nil {
                              
                              do {
                                  let jsonResponse = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
                                  
                                  
                                  DispatchQueue.main.async {
                                      if let main = jsonResponse!["main"] as? [String : Any] {
                                          if let temp = main["temp"] as? Double {
                                              
                                              self.currentTempValue.text = String(Int(temp-272.15 )) + "°"
                                              
                                              print(temp-272.15)
                                          }
                                          
                                          
                                          if let feels = main["feels_like"] as? Double {
                                              
                                              self.feelsValue.text = String(Int(feels-272.15)) + "°"
                                              
                                          }
                                          
                                          if let wind = jsonResponse!["wind"] as? [String : Any] {
                                              
                                              
                                              if let speed = wind["speed"] as? Double {
                                                  self.windSpeedValue.text = String(Int(speed))
                                              }
                                              
                                          }
                                          
                                          if let countryName = jsonResponse?["name"] as? String {
                                              
                                              self.countryName.text = countryName
                                          }
                                      }
                                  }
                                  
                              }catch {
                                  
                              }
                          }
                      }
                      
                  }
            task.resume()
        }
    }

extension WeatherViewControler : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchWord = searchText
        
    }
    
    
}

