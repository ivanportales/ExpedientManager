//
//  ScheduledScalesTableViewCell.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 08/11/24.
//

import UIKit

class ScheduledScalesTableViewCell: UITableViewCell {
    static let cellIdentifier = "scheduledScalesTableViewCell"
    
    // MARK: - UI
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dayAndMonthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundHourView: UIView!
    @IBOutlet weak var scaleColorView: UIView!
    
    // MARK: - Private Properties
    
    private let calendar = Calendar.current
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        clipsToBounds = true
    }
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFontsOfViews()
    }
    
    // MARK: - Exposed Functions
    
    func setDataOf(scheduledNotification: ScheduledNotification) {
        self.hourLabel.text = calendar.getHourAndMinuteFrom(date: scheduledNotification.date)
        self.dayAndMonthLabel.text = calendar.getDayAndMonthFrom(date: scheduledNotification.date)
        self.titleLabel.text = scheduledNotification.title
        self.descriptionLabel.text = scheduledNotification.description
        scaleColorView.backgroundColor = UIColor(hex: scheduledNotification.colorHex)
    }
    
    // MARK: - Private Functions
    
    private func setupFontsOfViews() {
        titleLabel.font = .poppinsSemiboldOf(size: 15)
        hourLabel.font = .poppinsMediumOf(size: 17)
        dayAndMonthLabel.font = .poppinsRegularOf(size: 13)
        descriptionLabel.font = .poppinsRegularOf(size: 14)
    }
}
