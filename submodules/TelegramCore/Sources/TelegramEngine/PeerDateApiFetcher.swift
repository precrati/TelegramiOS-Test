//
//  PeerDateApiFetcher.swift
//  _idx_TelegramUI_0B72C791_ios_min11.0
//
//  Created by Игорь Лемешевский on 08.04.2023.
//

import Foundation
import SwiftSignalKit

public final class ApiFetcher {
    
    public init() {}
    
    public static func fetchDate(url: URL) -> Signal<Int, NoError> {
        var request = URLRequest(url: url)
        let session = URLSession.shared
        let decoder = JSONDecoder()
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return Signal { subscriber in
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("\(error)")
                }
                guard let data = data else { return }
                do {
                    let result = try decoder.decode(TimestampDateModel.self, from: data)
                    subscriber.putNext(result.unixtime)
                    
                } catch let jsonError {
                    print("There was parsing error: \(jsonError)")
                }
            }

            task.resume()
            return EmptyDisposable
        }
    }
}

public struct TimestampDateModel: Codable {
    
    public let unixtime: Int
}
