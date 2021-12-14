//
//  PhoneVerificationClient.swift
//  phoneVerification
//
//  Created by Arnas Peciukonis on 2021-12-14.
//

import ComposableArchitecture

enum Response {
    case success
}

struct PhoneVerificationClient {
    var verify: (phoneNumber) -> Effect<Response, Error>
    var verifyPin: (String) -> Effect<Response, Error>
}

extension PhoneVerificationClient {
}

extension PhoneVerificationClient {
    static func mock() {}
}


// MARK: - do the request and Encode/Decode Requests
class RequestHelper {
    
}
