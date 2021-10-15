//
//  ViewController.swift
//  ContactsTest
//
//  Created by Khateeb H. on 10/14/21.
//

import UIKit

final class ContactsViewController: UIViewController {
    
    private static let reuseContactCellIdentifier = "ContactCell"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private let alertPresenter: AlertPresenter_Proto = AlertPresenter()
    private let viewModel: ContactsViewModel = ContactsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareView()
        
        showSpinner()
        viewModel.fectchContacts { [unowned self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.update()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.display(error: error)
                }
            }
        }
    }
    
    private func prepareView() {
        self.title = "Contacts"
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: type(of: self).reuseContactCellIdentifier)
        tableView.tableFooterView = UIView()
        
        spinner.hidesWhenStopped = true
    }
    
    private func update() {
        tableView.reloadData()
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error.localizedDescription)",
                               dismissButtonTitle: "OK")
    }
    
    private func showSpinner() {
        spinner.startAnimating()
    }
    
    private func hideSpinner() {
        spinner.stopAnimating()
    }
}

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).reuseContactCellIdentifier, for: indexPath) as? ContactTableViewCell {
            
            cell.contact = viewModel.contacts[indexPath.row]
            
            return cell
        }
        return  UITableViewCell()
    }
}

