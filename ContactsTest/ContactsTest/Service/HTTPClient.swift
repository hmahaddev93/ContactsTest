//
//  HTTPClient.swift
//  ContactsTest
//
//  Created by Khateeb H. on 10/14/21.
//

import Foundation

final class HTTPClient {
    static let shared: HTTPClient = HTTPClient()

    enum HTTPError: Error {
        case invalidURL
        case invalidResponse(Data?, URLResponse?)
    }
    
    public func get(urlString: String, headers:[String: String]? = nil, completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headers = headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }

            guard
                let responseData = data,
                let httpResponse = response as? HTTPURLResponse,
                200 ..< 300 ~= httpResponse.statusCode else {
                    completionBlock(.failure(HTTPError.invalidResponse(data, response)))
                    return
            }

            completionBlock(.success(responseData))
        }
        .resume()
    }
    
    func downloadImage(imageURLString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        get(urlString: imageURLString) { result in
                switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            case .success(let data):
                DispatchQueue.main.async() {
                    completion(.success(data))
                }
            }
        }
    }
}

