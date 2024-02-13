import Foundation

public class LocalizedString {

    private static let tableName = "Localizable"

    static func localized(for key: String) -> String {
        let bundle = Bundle(for: LocalizedString.self)
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, value: "", comment: "")
    }
}

extension LocalizedString {
    //HomeView
    static let activitiesLabel = localized(for: "activitiesLabel")
    static let backTitlebutton = localized(for: "backTitlebutton")
    static let listTitleView = localized(for: "listTitleView")
    static let editShiftTitle = localized(for: "editShiftTitle")
    static let editOndutyTitle = localized(for: "editOndutyTitle")
    static let deleteTitleText = localized(for: "deleteTitleText")
    
    //AddShiftView
    static let titleLabel = localized(for: "titleLabel")
    static let nameLabel = localized(for: "nameLabel")
    static let durationLabel = localized(for: "durationLabel")
    static let colorLabel = localized(for: "colorLabel")
    static let notesLabel = localized(for: "notesLabel")
    static let saveButton = localized(for: "saveButton")
    static let fixedButton = localized(for: "fixedButton")
    static let ondutyButton = localized(for: "ondutyButton")
    static let workForLabel = localized(for: "workForLabel")
    static let restForLabel = localized(for: "restForLabel")
    static let startLabel = localized(for: "startLabel")
    static let endLabel = localized(for: "endLabel")
    static let describeHerePlaceholder = localized(for: "describeHerePlaceholder")
    static let daysLabel = localized(for: "daysLabel")
    static let hoursLabel = localized(for: "hoursLabel")
    static let doneButton = localized(for: "doneButton")
    
    //Alerts
    static let alertErrorTitle = localized(for: "alertErrorTitle")
    static let alertErrorMsg = localized(for: "alertErrorMsg")
    static let deleteAlertTitle = localized(for: "deleteAlertTitle")
    static let deleteAlertMsg = localized(for: "deleteAlertMsg")
    static let yesText = localized(for: "yesText")
    static let noText = localized(for: "noText")
    
    static let emptyScheduledNotificationsMessage = localized(for: "emptyScheduledNotificationsMessage")
    static let emptyScheduledNotificationsForDayMessage = localized(for: "emptyScheduledNotificationsForDayMessage")
    static let periodLabel = localized(for: "periodLabel")
    static let addTitle = localized(for: "addTitle")
    
    //Onboarding
    static let onboardingMsg1 = localized(for: "onboardingMsg1")
    static let onboardingMsg2 = localized(for: "onboardingMsg2")
    static let onboardingMsg3 = localized(for: "onboardingMsg3")
    static let nextButton = localized(for: "nextButton")
    static let getStartButton = localized(for: "getStartButton")
}
