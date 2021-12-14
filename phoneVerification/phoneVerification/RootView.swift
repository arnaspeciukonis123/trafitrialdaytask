//
//  ContentView.swift
//  phoneVerification
//
//  Created by Arnas Peciukonis on 2021-12-14.
//

import SwiftUI
import ComposableArchitecture

struct MainAppState: Equatable {
    var updatePhoneNumberState = UpdatePhoneNumberState()
    var verificationState = VerificationState()
}

enum MainAppAction: Equatable {
    case checkPhoneNumber(UpdatePhoneNumberAction)
    case verificationAction(VerificationAction)
}

struct MainAppEnviroment {
    var phoneVerificationClient: PhoneVerificationClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let mainAppReducer: Reducer<MainAppState, MainAppAction, MainAppEnviroment> = .combine(
    updatePhoneNumberReducer.pullback(
        state: \MainAppState.updatePhoneNumberState,
        action: /MainAppAction.checkPhoneNumber,
        environment: { environment in
            UpdatePhoneNumberEnvironment(
                phoneVerificationClient: environment.phoneVerificationClient,
                mainQueue: environment.mainQueue
            )
        }
    ),
    enterVerificationCodeReducer.pullback(
        state: \MainAppState.verificationState,
        action: /MainAppAction.verificationAction,
        environment: { environment in
            VerificationEnvironment(
                mainQueue: environment.mainQueue,
                phoneVerificationClient: environment.phoneVerificationClient)
        }
    ),
    .init { state, action, environment in
        switch action {
        case .checkPhoneNumber:
            return .none
        case .verificationAction:
            return .none
        }
    }
)

struct RootView: View {
    let UpdatePhoneNumberStore: Store<UpdatePhoneNumberState, UpdatePhoneNumberAction>
    
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: UpdatePhoneNumberView(store: UpdatePhoneNumberStore)
            ) {
                Text("Click here to start the flow")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            UpdatePhoneNumberStore: Store(
                initialState: MainAppState(),
                reducer: mainAppReducer,
                environment: MainAppEnviroment(
                    phoneVerificationClient: PhoneVerificationClient(),
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler())
            )
        )
    }
}
