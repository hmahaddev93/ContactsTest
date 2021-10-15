//
//  ContactService.swift
//  ContactsTest
//
//  Created by Khateeb H. on 10/14/21.
//

import Foundation

enum ContactsAPI  {
    static let host: String = "mobile.staging.listfly.com"
    static let apiTokenHeader: [String: String] = ["Api-Token": "9b5d6641aa55e368f678ff47eda44a1fc12e6ee8912ddf92cb381558edbd9af0e91ab449"]
    static let dateFormat = "yyyy-MM-dd"
    enum EndPoints {
        static let contacts = "/api/3/contacts"
    }
}

enum SortDirection: String {
    case ASCE, DESC
}

protocol Contacts_Protocol {
    func fetchContacts(orderByFieldName: String, sortDirection: SortDirection, limit: Int, completion: @escaping (Result<[Contact], Error>) -> Void)
}

final class ContactService: Contacts_Protocol {
    
    private let httpClient: HTTPClient
    private let jsonDecoder: JSONDecoder
    
    enum ContactServiceError: Error {
        case invalidData
    }
    
    init(httpClient: HTTPClient = HTTPClient.shared) {
        self.httpClient = httpClient
        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ContactsAPI.dateFormat
        self.jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    struct ContactsBody: Codable {
        let contacts: [Contact]
    }
    
    func fetchContacts(orderByFieldName: String, sortDirection: SortDirection, limit: Int, completion: @escaping (Result<[Contact], Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = ContactsAPI.host
        urlComponents.path = ContactsAPI.EndPoints.contacts

        let queryItemLimit = URLQueryItem(name: "limit", value: "\(limit)")
        let queryItemOrder = URLQueryItem(name: "orders[\(orderByFieldName)]", value: sortDirection.rawValue)
        urlComponents.queryItems = [queryItemOrder, queryItemLimit]
        
        httpClient.get(urlString: urlComponents.url!.absoluteString, headers: ContactsAPI.apiTokenHeader) { result in
            switch result {
            case .success(let data):
                print(data)
                if let contactsBody = try? self.jsonDecoder.decode(ContactsBody.self, from: data) {
                    print(contactsBody.contacts)
                    completion(.success(contactsBody.contacts))
                }else {
                    completion(.failure(ContactServiceError.invalidData))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
