//
//  ContactTableViewCell.swift
//  ContactsTest
//
//  Created by Khateeb H. on 10/14/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    var contact: Contact! {
        didSet {
            guard let first = contact.firstName,
                  let last = contact.lastName
            else {
                self.contactLabel.text = contact.email
                return
            }
            self.contactLabel.text = "\(first) \(last)"
        }
    }
    
    @IBOutlet weak var contactLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
