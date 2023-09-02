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
    
    @Published var itemData = [Instruction]()
    
    func loadData() {
        /* http://15.164.95.147:5000/hello */
        guard let url = URL(string: "http://127.0.0.1:5000/hello") else {
            fatalError("Invalid URL")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let userResponse = try? JSONDecoder().decode([Instruction].self, from: data)
                    DispatchQueue.main.async {
                        if let userResponse = userResponse{
                            self.itemData = userResponse
                        } else {
                            print("Decoding Error")
                        }
                    }
                }
            }
        }.resume()
    }
    
}
