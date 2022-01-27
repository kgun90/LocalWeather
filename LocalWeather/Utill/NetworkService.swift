//
//  NetworkService.swift
//  LocalWeather
//
//  Created by gkang on 2022/01/27.
//

import Foundation
//        MARK: - Temp
struct ErrorResponse: Decodable {
    let errorMessage, errorCode: String
}


class NetworkService {
    init(baseUrl: String, route: String = "") {
        self.baseUrl = baseUrl
        self.route = route
    }
    
    public enum Result {
        case success
        case fail
    }
    
    public enum HTTPMethod: String {
        case get = "GET", put = "PUT", post = "POST", delete = "DELETE"
    }
    
    private let baseUrl: String
    private let route: String
    
    private let successRange = 200 ..< 300
    private let failRange = 400 ..< 500
    
    private let session = URLSession.shared
    
    func request<R: Decodable> (_ path: String, method: HTTPMethod, query: [String: String]? = nil, type: R.Type, headers: [String: String]? = nil, completion: @escaping (Decodable?) -> Void) {
        httpRequest(path: path, method: method, query: query, type: type, headers: headers, completion: completion)
    }
    
    func request<P: Encodable, R: Decodable> (_ path: String, method: HTTPMethod, query: [String: String]? = nil, params: P? = nil, type: R.Type, headers: [String: String]? = nil, completion: @escaping (Decodable?) -> Void) {
        let data = encodeRequest(from: params)
        httpRequest(path: path, method: method, query: query, data: data, type: type, headers: headers, completion: completion)
    }
    
    private func httpRequest<R: Decodable> (path: String, method: HTTPMethod, query: [String: String]? = nil, data: Data? = nil, type: R.Type, headers: [String: String]?, completion: @escaping (Decodable?) -> Void) {
        var urlComponents = URLComponents(string: baseUrl)!
        
        let queryItems = paramToQueryItems(params: query)
        urlComponents.path = "\(route)\(path)"
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        headers?.forEach {
            request.setValue($0.1, forHTTPHeaderField: $0.0)
        }
        
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
    
    private func encodeRequest<P: Encodable> (from inputData: P) -> Data? {
        let encoder = JSONEncoder()
        var data: Data? = nil
        
        do {
            data = try encoder.encode(inputData)
        } catch let error {
            print(error)
        }
        
        return data
    }
    
    private func decodeResponse<R: Decodable> (of: R.Type, result: Data) -> R? {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        var response: R? = nil
        
        do {
            response = try decoder.decode(R.self, from: result)
        } catch let error {
            print(error)
        }
        
        return response
    }
}
