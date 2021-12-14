//
//  EnterVerificationCodeView.swift
//  phoneVerification
//
//  Created by Arnas Peciukonis on 2021-12-14.
//

import SwiftUI
import ComposableArchitecture

struct VerificationState: Equatable {
    let verificationCode = String()
}

enum VerificationAction: Equatable {
    case resendButtonTapped
    case pinCodeEntered
}

struct VerificationEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var phoneVerificationClient: PhoneVerificationClient
}

let enterVerificationCodeReducer = Reducer<VerificationState , VerificationAction, VerificationEnvironment> { state, action, environment in
    struct VerifyCancelPinId: Hashable {}
    switch action {
    case .resendButtonTapped:
        return .none
    case .pinCodeEntered:
        return environment.verifyPin(state.verificationCode)
            .cancellable(id: VerifyCancelPinId())
            .catchToEffect()
    }
}.debug()

struct EnterVerificationCodeView: View {
    let store: Store<VerificationState, VerificationAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Text("VERIFICATION CODE")
                TextField(
                    "---",
                    text: viewStore.binding(
                        get: \.verificationCode,
                        send: VerificationAction.pinCodeEntered
                    )
                )
                Text("We sent you a 4-digit code to \(viewStore.state.phoneNumber)")
                Button("Resend text") { viewStore.send(.resendButtonTapped) }
                .navigationBarTitle("Enter Verification code")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
