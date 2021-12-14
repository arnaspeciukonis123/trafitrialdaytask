//
//  phoneVerificationApp.swift
//  phoneVerification
//
//  Created by Arnas Peciukonis on 2021-12-14.
//

import SwiftUI
import ComposableArchitecture

@main
struct phoneVerificationApp: App {
    var body: some Scene {
        WindowGroup {
            RootView (
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
}
