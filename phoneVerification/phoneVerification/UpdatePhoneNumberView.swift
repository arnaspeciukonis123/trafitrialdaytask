//
//  UpdatePhoneNumberView.swift
//  phoneVerification
//
//  Created by Arnas Peciukonis on 2021-12-14.
//

import SwiftUI
import ComposableArchitecture

struct UpdatePhoneNumberState: Equatable {
    var phoneNumber = String()
    var phonenumberInvalidAlert: String? = nil
}

enum UpdatePhoneNumberAction: Equatable {
    case textFieldChanged(String)
    case buttonPressed
    case phonenumberInvalidtDismissed
}

struct UpdatePhoneNumberEnvironment {
    var phoneVerificationClient: PhoneVerificationClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let updatePhoneNumberReducer = Reducer<UpdatePhoneNumberState , UpdatePhoneNumberAction, UpdatePhoneNumberEnvironment> { state, action, environment in
    struct VerifyCancelId: Hashable {}
    switch action {
    case .buttonPressed:
        if state.phoneNumber.count > Constants.phoneNumberLenght {
        return environment.phoneVerificationClient
            .verify(state.phoneNumber)
            .cancellable(id: VerifyCancelId())
            .catchToEffect()
        } else {
            return .none
        }
        
    case .textFieldChanged(let phoneNumber):
        state.phoneNumber = phoneNumber
        return .none
    case .phonenumberInvalidtDismissed:
            state.phonenumberInvalidAlert = nil
        return .none
    }
}.debug()

struct UpdatePhoneNumberView: View {
    let store: Store<UpdatePhoneNumberState, UpdatePhoneNumberAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Text("phone_number")
                TextField(
                    "verification",
                    text: viewStore.binding(
                        get: \.phoneNumber,
                        send: UpdatePhoneNumberAction.textFieldChanged)
                )
                    .keyboardType(.numberPad)
                
                Text("we_will_send_you")
                Button("update_number") { viewStore.send(.buttonPressed) }
                .navigationBarTitle("Update phone number")
                .navigationBarTitleDisplayMode(.inline)
            }.alert(
                item: viewStore.binding(
                  get: { $0.phonenumberInvalidAlert.map(InvalidNumberAlert.init(title:)) },
                  send: .phonenumberInvalidtDismissed
                ),
                content: { Alert(title: Text($0.title)) }
              )
        }
    }
}


//xcode cannot save a new file for whatever reason so I am just leaving this here for now
struct InvalidNumberAlert: Identifiable {
  var title: String
  var id: String { self.title }
}

struct Constants {
    static let phoneNumberLenght = 12
}
