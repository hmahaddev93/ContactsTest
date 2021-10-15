//
//  ContactsViewModel.swift
//  ContactsTest
//
//  Created by Khateeb H. on 10/14/21.
//

import Foundation

final class ContactsViewModel {
    var contacts = [Contact]()
    
    func fectchContacts(completion: @escaping (Result<[Contact], Error>) -> Void) {
        ContactService().fetchContacts(orderByFieldName: "last_name", sortDirection: .DESC, limit: 50) { result in
            switch result {
            case .success(let contacts):
                self.contacts = contacts
                completion(.success(contacts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
