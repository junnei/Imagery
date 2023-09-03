//
//  DataManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation

class DataManager : ObservableObject {
    static let shared = DataManager()
    private init() {}
    
    @Published var dataList = [Data]()
    @Published var pressed: Bool = false
    @Published var isLoading: Bool = false
    
    
    func resetData() {
        if let url = URL(string: "http://15.164.95.147:5000/api/reset") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
            }
        }
    }
    
    func loadData(_ command: String) async {
        /* http://15.164.95.147:5000/api/play */
        var url = URL(string: "http://127.0.0.1:5000/api/play")
        
        if (command != "") {
            if (command == "a" || command == "b" || command == "c") {
                let command_query = URLQueryItem(name: "command", value: command)
                url!.append(queryItems: [command_query])
            } else {
                let command_query = URLQueryItem(name: "ownStory", value: command)
                url!.append(queryItems: [command_query])
            }
        }
        
        var requestURL = URLRequest(url: url!)
        requestURL.httpMethod = "POST"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        await URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let userResponse = try? JSONDecoder().decode(Data.self, from: data)
                    DispatchQueue.main.async {
                        if (self.dataList.count == 0) {
                            GameManager.shared.healthState = .normal
                        }
                        else {
                            if (self.dataList.last!.state == "fail") {
                                GameManager.shared.healthState = .fail
                            }
                            else if (self.dataList.last!.state == "success") {
                                GameManager.shared.healthState = .success
                            }
                            else {
                                if (userResponse!.hp == self.dataList.last!.hp) {
                                    GameManager.shared.healthState = .normal
                                }
                                else if (userResponse!.hp < self.dataList.last!.hp) {
                                    GameManager.shared.healthState = .drop
                                }
                                else {
                                    GameManager.shared.healthState = .heal
                                }
                            }
                        }
                        self.dataList.append(userResponse!)
                        self.pressed = false
                        self.isLoading = false
                        print(userResponse?.content)
                        print(userResponse?.dall)
                        print(userResponse?.hp.description)
                        print(userResponse?.state)
                        print(userResponse?.choices["a"])
                        print(userResponse?.choices["b"])
                        print(userResponse?.choices["c"])
                        
                    }
                    /*
                    DispatchQueue.main.async {
                        if let userResponse = userResponse{
                            self.itemData = userResponse
                        } else {
                            print("Decoding Error")
                        }
                    }*/
                }
            }
        }.resume()
    }
    
}
