//
//  NetworkService.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import Foundation

class NetworkService {
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public enum Result {
        case success
        case fail
    }
    
    public enum HTTPMethod: String {
        case get = "GET", put = "PUT", post = "POST", delete = "DELETE"
    }
    
    private let baseUrl: String
    
    private let successRange = 200 ..< 300
    private let failRange = 400 ..< 500
    
    private let session = URLSession.shared
    
    func request<R: Decodable> (_ path: String, method: HTTPMethod, query: [String: String]? = nil, type: R.Type, completion: @escaping (Decodable?) -> Void) {
        var urlComponents = URLComponents(string: baseUrl)!
        
        let queryItems = paramToQueryItems(params: query)
        urlComponents.path = "\(path)"
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }

            guard let resultData = data else { return }

            guard self.successRange.contains(statusCode) else {
                completion(self.decodeResponse(of: ErrorResponse.self, result: resultData))
                return
            }

            completion(self.decodeResponse(of: R.self, result: resultData))
        }.resume()
    }
    
    private func paramToQueryItems(params: [String: String]?) -> [URLQueryItem] {
        return params?.map {
            URLQueryItem(name: $0.0, value: $0.1)
        } ?? []
    }
        
    private func decodeResponse<R: Decodable> (of: R.Type, result: Data) -> R? {
        let decoder = JSONDecoder()
        var response: R? = nil
        
        do {
            response = try decoder.decode(R.self, from: result)
        } catch let error {
            print(error)
        }
        
        return response
    }

}
