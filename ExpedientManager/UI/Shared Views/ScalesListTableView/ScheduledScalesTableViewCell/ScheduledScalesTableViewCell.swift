//
//  ScheduledScalesTableViewCell.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 08/11/23.
//

import UIKit

class ScheduledScalesTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "scheduledScalesTableViewCell"
    
    // MARK: - UI
    
    @IBOutlet weak var hourLabel: UILabel! {
        didSet {
            hourLabel.font = .poppinsMediumOf(size: 17)
        }
    }
    
    @IBOutlet weak var dayAndMonthLabel: UILabel! {
        didSet {
            dayAndMonthLabel.font = .poppinsRegularOf(size: 13)
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .poppinsSemiboldOf(size: 15)
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .poppinsRegularOf(size: 14)
        }
    }
    
    @IBOutlet weak var backgroundHourView: UIView! {
        didSet {
            backgroundHourView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var scaleColorView: UIView!
        
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
        selectionStyle = .none
    }
       
    // MARK: - Exposed Functions
    
    func setDataOf(scheduledNotification: ScheduledNotification) {
        hourLabel.text = scheduledNotification.date.formatTime()
        dayAndMonthLabel.text = scheduledNotification.date.formateDate(withFormat: "d/MM")
        titleLabel.text = scheduledNotification.title
        descriptionLabel.text = scheduledNotification.description
        scaleColorView.backgroundColor = UIColor(hex: scheduledNotification.colorHex)
    }
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
}
