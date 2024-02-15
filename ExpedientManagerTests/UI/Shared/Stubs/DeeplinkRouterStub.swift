//
//  DeeplinkRouterStub.swift
//  ExpedientManagerTests
//
//  Created by Gonzalo Ivan Santos Portales on 14/02/24.
//

@testable import ExpedientManager

final class DeeplinkRouterStub: DeeplinkRouterProtocol {
    
    var didCallPop = false
    var sendedDeeplink: Deeplink?
    var sendedParams: [String : Any] = [:]
    
    func route(to deeplink: Deeplink, withParams params: [String : Any]) {
        self.sendedDeeplink = deeplink
        self.sendedParams = params
    }
    
    func pop() {
        didCallPop = true
    }
}
