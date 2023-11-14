import _Concurrency
import PlaygroundSupport
import SwiftUI

var aTemp: Double = 0.0


PlaygroundPage.current.needsIndefiniteExecution = true

struct RiverData: Decodable {
    let time: String
    let level: Double
    let temp: Double
}

func loadMessages() async {
        do {
            let url = URL(string: "http://23.239.17.146:8080/test")!
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            let riverData = try JSONDecoder().decode(RiverData.self, from: data)
            aTemp = riverData.temp
            print(riverData)
        } catch {
            let riverData = "no data"
            
        }
    }

func loadData(completion: @escaping (RiverData) -> Void) async {
    do {
        let url = URL(string: "http://23.239.17.146:8080/test")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, res, err)  in
            guard let data = data else {
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
Task {
    await loadData(){ (json) in
        aTemp = json.temp
        print (aTemp)
    }
    
}

