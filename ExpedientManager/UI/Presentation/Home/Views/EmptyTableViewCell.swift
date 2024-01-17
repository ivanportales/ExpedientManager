//
//  EmptyTableViewCell.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/24.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    static let cellIdentifier = "emptyTableViewCell"
    
    // MARK: - UI
    
    @IBOutlet weak var messageLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.clipsToBounds = true
    }
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemBackground
        messageLabel.font = .poppinsRegularOf(size: 18)
        messageLabel.text = LocalizedString.emptyTableViewMsg
    }
}
