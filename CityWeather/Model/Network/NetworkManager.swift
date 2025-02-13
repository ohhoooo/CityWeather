//
//  NetworkManager.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    // MARK: - properties
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - methods
    func request<T: Decodable>(_ object: T.Type,
                               router: NetworkRouter,
                               completion: @escaping ((Result<T, Error>) -> Void)) {
        AF.request(router).responseDecodable(of: object) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
