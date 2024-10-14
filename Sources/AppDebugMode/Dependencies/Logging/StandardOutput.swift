//
//  StandardOutput.swift
//  AppDebugMode
//
//  Created by Andrej Jasso on 16/09/2024.
//

import Foundation

struct StandardOutput {
    
    static let sampleValues = [
        """
        🚀GET| ✅200| https://myfakeapi.com/api/cars/Top
        🏷 Headers: empty headers
        ↗️ Start: 2024-02-26 16:41:53 +0000
        ⌛️ Duration: 0.3984450101852417s
        ⬇️ Response body:
        {
          "Car" : {
            "availability" : false,
            "id" : 4,
            "car" : "Jeep",
            "car_model" : "Compass",
            "car_vin" : "4USBT33454L511606",
            "price" : "$2732.99",
            "car_color" : "Violet",
            "car_model_year" : 2012
          }
        }
        """,
        """
        🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft
        🏷 Headers: empty headers
        ↗️ Start: 2024-02-26 16:41:53 +0000
        ⌛️ Duration: 0.3984450101852417s
        ⬇️ Response body:
        {
          "Car" : {
            "availability" : false,
            "id" : 4,
            "car" : "Jeep",
            "car_model" : "Compass",
            "car_vin" : "4USBT33454L511606",
            "price" : "$2732.99",
            "car_color" : "Violet",
            "car_model_year" : 2012
          }
        }
        """,
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/5353afeafaef4faf4f4fa4fgafa4t5y5r65eh5eh5eh5eh5eh5hrfthfthftthfthft",
        "🚀GET| ✅200| https://myfakeapi.com/api/cars/4/Bottom"
    ].map {
        Log(message: $0)
    }
    
}
