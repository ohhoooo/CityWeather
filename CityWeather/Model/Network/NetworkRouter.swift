//
//  NetworkRouter.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import Foundation
import Alamofire

enum NetworkRouter {
    case fetchPhoto(request: PhotoRequest)
    case fetchWeather(request: WeatherRequest)
    case fetchIconImage(request: IconImageRequest)
    case fetchPhotoImage(request: PhotoImageRequest)
}

// MARK: - extensions
extension NetworkRouter: URLRequestConvertible {
    var baseURL: URL {
        switch self {
        case .fetchPhoto(_):
            return URL(string: "https://api.unsplash.com")!
        case .fetchWeather(_):
            return URL(string: "https://api.openweathermap.org")!
        case .fetchIconImage(_):
            return URL(string: "https://openweathermap.org")!
        case .fetchPhotoImage(let request):
            return URL(string: request.query)!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .fetchPhoto(_):
            return ["Authorization": Bundle.main.infoDictionary?["UnsplashAPIKey"] as! String]
        case .fetchWeather(_):
            return []
        case .fetchIconImage(_):
            return []
        case .fetchPhotoImage(_):
            return []
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .fetchPhoto(_):
            return "/search/photos"
        case .fetchWeather(_):
            return "/data/2.5/group"
        case .fetchIconImage(let request):
            return "/img/wn/\(request.query)"
        case .fetchPhotoImage(_):
            return ""
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchPhoto(let request):
            return request.toDictionary
        case .fetchWeather(let request):
            return request.toDictionary
        case .fetchIconImage(_):
            return nil
        case .fetchPhotoImage(_):
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.headers = headers
        request.method = method
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
