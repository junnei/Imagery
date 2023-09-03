//
//  DataManager.swift
//  Imagery
//
//  Created by Jun on 2023/09/01.
//

import Foundation
import SwiftUI

/* http://15.164.95.147:5000/api/play */
let baseURL = "http://15.164.95.147:5000/"
let localURL = "http://127.0.0.1:5000/"

class DataManager : ObservableObject {
    static let shared = DataManager()
    private init() {}
    
    @Published var dataList = [Item]()
    @Published var pressed: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var randomSubject: String = "로딩 중..."
    @Published var subjectList = [String]()
    
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
    
    
    
    func getSubject() {
        if let url = URL(string: baseURL + "api/getSubject") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let userResponse = try? JSONDecoder().decode(String.self, from: data)
                        DispatchQueue.main.async {
                            self.randomSubject = userResponse ?? "다크 페이트: 죽음의 예언"
                        }
                    }
                }
            }.resume()
        }
    }
    
    func loadSpeech(_ audioURL: URL) async {
        
        guard let audioData = try? Data(contentsOf: audioURL) else {
            print("Failed to load audio data")
            return
        }
        print(audioURL)
        var url = URL(string: baseURL + "api/whisper")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: url!)
        print(request)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let boundaryPrefix = "—\(boundary)\r\n"
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"inputAudio.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)

        body.append(boundaryPrefix.data(using: .utf8)!)
        
        request.httpBody = body
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("URLSession")
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("NOT error")
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let userResponse = try? JSONDecoder().decode(String.self, from: data)
                    print("YES")
                    DispatchQueue.main.async {
                        print(userResponse!)
                        self.subjectList.append(userResponse!)
                    }
                }
            }
            print("The END")
        }.resume()
    }
    
    func loadSummary(_ command: String) async {
        var url = URL(string: baseURL + "api/get_summary")
        
        let command_query = URLQueryItem(name: "ownStory", value: command)
        url!.append(queryItems: [command_query])
        
        
        var requestURL = URLRequest(url: url!)
        requestURL.httpMethod = "POST"
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let userResponse = try? JSONDecoder().decode(String.self, from: data)
                    DispatchQueue.main.async {
                        self.subjectList.append(userResponse!)
                    }
                }
            }
        }.resume()
    }
    
    func loadData(_ command: String) async {
        var url = URL(string: baseURL + "api/play")
        
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
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let userResponse = try? JSONDecoder().decode(Item.self, from: data)
                    DispatchQueue.main.async {
                        if (self.dataList.count == 0) {
                            GameManager.shared.healthState = .normal
                        }
                        else {
                            if (self.dataList.last!.state == "fail") {
                                GameManager.shared.healthState = .fail
                                GameManager.shared.background = Color.OasisColors.badEnding
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(.easeOut(duration: 0.5)) {
                                        GameManager.shared.background = Color.OasisColors.darkGreen
                                    }
                                }
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
                                    GameManager.shared.background = Color.OasisColors.error
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            GameManager.shared.background = Color.OasisColors.darkGreen
                                        }
                                    }
                                }
                                else {
                                    GameManager.shared.healthState = .heal
                                    GameManager.shared.background = Color.OasisColors.success
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeOut(duration: 0.5)) {
                                            GameManager.shared.background = Color.OasisColors.darkGreen
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        self.dataList.append(userResponse!)
                        self.pressed = false
                        self.isLoading = false
                        print(self.dataList.description)
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
