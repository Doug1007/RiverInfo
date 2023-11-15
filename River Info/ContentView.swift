//
//  ContentView.swift
//  River Info
//
//  Created by Douglas Judy on 10/18/23.
//

import SwiftUI



struct ContentView: View {
    
    // use timer and vars to intermittently update model data
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var count = 0
    @State private var timeLast = Date().timeIntervalSince1970
    @StateObject var info: RiverObj =  RiverObj()
    
    var body: some View {
        VStack {
            Text("Fletcher, NC")
                .font(.title)
            Spacer()
            Image(systemName: "globe")
                
                .resizable()
                .frame(width: 100,height: 100)
                .foregroundStyle(.tint)
                .padding()
            Text(info.time)
                .font(.title)
                
            Text(String(info.temp) + "°F / " + String(info.level) + " ft.")
                .font(.title)
                .padding(.bottom)
            
            Text("Clear")
            Text("Moderate")
            Text("Cloudy")
            Spacer()
            
        }
        .onReceive(timer) { time in
            
            // update data if app just started or if it has been 15 minutes (900 seconds) since last update
            
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
                        dateFormatter.dateStyle = .medium
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



