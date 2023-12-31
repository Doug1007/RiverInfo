//
//  ContentView.swift
//  River Info Watch App
//
//  Created by Douglas Judy on 10/18/23.
//

import SwiftUI





struct ContentView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var count = 0
    @State private var timeLast = Date().timeIntervalSince1970
    @StateObject var info: RiverObj =  RiverObj()
    
    var body: some View {
        VStack {
            Text("Fletcher, NC")
            Spacer()
            Image(systemName: "water.waves")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Spacer()
            Text(info.time)
            Text(String(info.temp) + "°F / " + String(info.level) + " ft.")
            
            Text("Clear")
            Text("Moderate")
            Text("Cloudy")
            Spacer()
            
        }
        .onReceive(timer) { time in
            if timeLast < time.timeIntervalSince1970 - 900 || count < 1 {
                timeLast = time.timeIntervalSince1970
                count += 1
                print(count)
                
                Task {
                    
                    await info.loadData() {(json) in
                        
                        // Format the date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let date = dateFormatter.date(from: json.time)
                        print (date!.description)
                        dateFormatter.timeStyle = .short
                        dateFormatter.dateStyle = .short
                        
                        DispatchQueue.main.async {
                            
                            info.level = json.level
                            info.time = dateFormatter.string(from:(date!))
                            
                            //Convert to Fahrenheit
                            info.temp = (json.temp * 9 / 5) + 32
                            print(info.time)
                        }
                        
                    }
                    
                }
                
            }
        }
        
        
        .padding()
        
    }
}


#Preview {
    ContentView()
}


