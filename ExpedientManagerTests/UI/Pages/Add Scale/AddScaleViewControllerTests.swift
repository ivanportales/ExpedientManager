//
//  AddScaleViewControllerTests.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 02/03/24.
//

import Combine
@testable import ExpedientManager
import XCTest
import UIKit

final class AddScaleViewControllerTests: XCTestCase {
    
    private var viewModel: AddScaleViewModelStub!
    private var router: DeeplinkRouterStub!
    private var viewController: AddScaleViewController!
    private let currentDateForTesting: Date = Date.customDate()!
    private var subscribers: Set<AnyCancellable>!
    
    func test_save_scale() {
        makeSUT()
        
        viewController.set(scaleTitle: "title")
        viewController.set(scaleNotes: "description")
        
        if let saveButton = self.viewController.navigationItem.rightBarButtonItems?[0] {
            saveButton.testTap()
        }
        
        XCTAssertNotNil(viewModel.savedFixedScale!)
        XCTAssertEqual(viewController.selectedWorkScale(), .fixedScale)
        XCTAssertEqual(viewController.titleInputedText(), viewModel.savedFixedScale!.title)
        XCTAssertEqual(viewController.notesInputedText(), viewModel.savedFixedScale!.annotation)
        XCTAssertEqual(viewController.selectedWorkDuration(), viewModel.savedFixedScale!.scale?.scaleOfWork)
        XCTAssertEqual(viewController.selectedWorkRestDuration(), viewModel.savedFixedScale!.scale?.scaleOfRest)
        XCTAssertEqual(viewController.selectedScaleType(), viewModel.savedFixedScale!.scale?.type)
        XCTAssertEqual(viewController.selectedBegginingDate(), viewModel.savedFixedScale!.initialDate)
        XCTAssertEqual(viewController.selectedEndingDate(), viewModel.savedFixedScale!.finalDate)
        XCTAssertEqual(viewController.selectedColor().hex, viewModel.savedFixedScale!.colorHex)
    }
    
    func test_change_selected_scale_type() {
        makeSUT()
       
        viewController.changeSelectedScale(to: .onDuty)
       
        XCTAssertEqual(viewController.selectedWorkScale(), .onDuty)
    }

    // MARK: - Helpers Functions

    private func makeSUT() {
        self.subscribers = Set<AnyCancellable>()
        self.viewModel = AddScaleViewModelStub()
        self.router = DeeplinkRouterStub()
        self.viewController = AddScaleViewController(viewModel: viewModel!,
                                                     router: router!)
        viewController.loadViewIfNeeded()
        viewController.viewWillAppear(false)
    }

    private func listenToStateChange(_ callback: @escaping (AddScaleViewModelState) -> Void) {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { state in
                callback(state)
            }
            .store(in: &subscribers)
    }
}

// MARK: - Helper Extensions

extension AddScaleViewController {

    // MARK: - View Helpers
    
    func set(scaleTitle: String) {
        titleTextField.text = scaleTitle
    }
    
    func set(scaleNotes: String) {
        notesTextView.text = scaleNotes
    }
        
    func selectedWorkScaleLabel() -> String {
        return title ?? ""
    }
    
    func changeSelectedScale(to selectedWorkScale: WorkScaleType) {
        didChangeSelectedIndex(scaleTypeSegmentControll, selectedWorkScale: selectedWorkScale)
    }
    
    func titleInputedText() -> String {
        return titleTextField.text ?? ""
    }
    
    func notesInputedText() -> String {
        return notesTextView.text ?? ""
    }
    
    func selectedWorkScale() -> WorkScaleType {
        return scaleSelectTypeView.selectedWorkScale
    }
    
    func selectedWorkDuration() -> Int {
        return scaleSelectTypeView.workDuration
    }
    
    func selectedWorkRestDuration() -> Int {
        return scaleSelectTypeView.restDuration
    }
    
    func selectedScaleType() -> ScaleType {
        return scaleSelectTypeView.selectedScaleType
    }
    
    func selectedBegginingDate() -> Date {
        return begginingDurationView.date
    }
    
    func selectedEndingDate() -> Date {
        return endingDurationView.date
    }
    
    func selectedColor() -> UIColor {
        return scaleSetColorView.selectedColor
    }
}

fileprivate class AddScaleViewModelStub: AddScaleViewModelProtocol {

    // MARK: - Exposed Properties

    @Published private(set) var statePublished: AddScaleViewModelState = .initial
    var state: Published<AddScaleViewModelState>.Publisher { $statePublished }

    var didCallRequestAuthorizationToSendNotifications = false
    var savedFixedScale: FixedScale?
    var savedOnDuty: OnDuty?
    
    // MARK: - Protocol Functions
    
    func save(fixedScale: FixedScale) {
        self.savedFixedScale = fixedScale
    }
    
    func save(onDuty: OnDuty) {
        self.savedOnDuty = onDuty
    }
    
    func requestAuthorizationToSendNotifications() {
        didCallRequestAuthorizationToSendNotifications = true
    }
    
    // MARK: - Helper Functions for Testing
    
    func change(state newState: AddScaleViewModelState) {
        self.statePublished = newState
    }
}
