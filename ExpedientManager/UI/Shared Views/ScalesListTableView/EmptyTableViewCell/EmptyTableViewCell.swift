//
//  EmptyTableViewCell.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 10/11/23.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "emptyTableViewCell"
    
    // MARK: - UI
    
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.font = .poppinsRegularOf(size: 18)
        }
    }
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
        selectionStyle = .none
    }
    
    // MARK: - Exposed Functions
    
    func setupCell(withMessage message: String) {
        messageLabel.text = message
    }
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemBackground
    }
}
