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
    
    func loadData(_ command: String) async {
        /* http://15.164.95.147:5000/hello */
        var url = URL(string: "http://127.0.0.1:5000/api/play")
        
        if (command != "") {
            let command_query = URLQueryItem(name: "command", value: "a")
            url!.append(queryItems: [command_query])
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
