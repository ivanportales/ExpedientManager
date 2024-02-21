//
//  ViewModelStatePublisherSpy.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 20/02/24.
//

import Combine
import Foundation

final class ViewModelPublisherSpy<StateType> {
    
    var values: [StateType] = []
    private var cancellable: AnyCancellable?
    
    init(publisher: Published<StateType>.Publisher) {
        self.cancellable = publisher.sink(receiveValue: { [weak self] state in
            self?.values.append(state)
        })
    }
}
