//
//  NetworkManager.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/5/22.
//

import Foundation
import Combine

protocol NetworkManager {
    func getModel<Model: Decodable>(_ model: Model.Type, from url: String) -> AnyPublisher<Model, NetworkError>
    func getData(from url: String, completionHandler: @escaping (Data?) -> Void)
}

class MainNetworkManager: NetworkManager {
    
    func getModel<Model: Decodable>(_ model: Model.Type, from url: String) -> AnyPublisher<Model, NetworkError> {
        
        guard let url = URL(string: url)
        else { return Fail<Model, NetworkError>(error: .badURL).eraseToAnyPublisher() }
        
        return URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map { result -> Data in
                return result.data
            }
            .decode(type: model, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                return .other(error)
            }
            .eraseToAnyPublisher()
    }
    
    func getData(from url: String, completionHandler: @escaping (Data?) -> Void) {
        
        guard let url = URL(string: url) else {
            completionHandler(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            completionHandler(data)
        }
        .resume()
    }
}
