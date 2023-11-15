//
//  RiverObject.swift
//  River Info
//
//  Created by Douglas Judy on 10/20/23.
//

import Foundation
import SwiftUI


struct RiverData: Decodable {
    let time: String
    let level: Double
    let temp: Double
}

@MainActor class RiverObj: ObservableObject {
    
    @Published var time: String = "none"
    @Published var temp: Double = 0.0
    @Published var level: Double = 0.0
    
    
    
    
    func loadRiverData() async {
            do {
                let url = URL(string: "http://23.239.17.146:8080/test")!
                let (data, _) = try  await URLSession.shared.data(from: url)
                print(data)
                let riverData = try JSONDecoder().decode(RiverData.self, from: data)
                
                temp = riverData.temp
                time = riverData.time
                level = riverData.level
                
                print(riverData)
                print(String(level))
            } catch {
                temp = 1.1
                level = 1.1
                time = "time"
                print("didn't reach url")
                
            }
        }
    
    func loadData(completion: @escaping (RiverData) -> Void) async {
        
        do {
            var tryAgain = true
            
            let url = URL(string: "http://23.239.17.146:8080/test")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, res, err)  in
                guard let data = data else {
                    print("no data")
                    print(err.debugDescription)
                    
                    return
                    
                }
                
                do {
                    let json = try JSONDecoder().decode(RiverData.self, from: data)
                    
                    print(json)
                    
                    completion(json)
                } catch {
                    print("didnt work")
                }
                
            } )
            task.resume()
        }
    }


}
