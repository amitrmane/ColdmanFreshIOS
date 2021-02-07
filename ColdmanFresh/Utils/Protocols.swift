//
//  Protocols.swift
//  ColdmanFresh
//
//  Created by Prasad Patil on 07/01/21.
//  Copyright © 2021 Prasad Patil. All rights reserved.
//

import Foundation

protocol LoginSuccessProtocol {
    func loginSuccess(profile: UserProfile)
}

protocol AddressSelectionProtocol {
    func selectedAddress(addr: Address)
}

protocol OrderSuccess {
    func orderSuccessfullyPlaced()
}
