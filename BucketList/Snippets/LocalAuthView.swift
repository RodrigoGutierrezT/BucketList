//
//  LocalAuthView.swift
//  BucketList
//
//  Created by Rodrigo on 17-08-24.
//

import LocalAuthentication
import SwiftUI

struct LocalAuthView: View {
    @State private var isUnlocked = false
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnlocked = true
                } else {
                    //
                }
            }
        } else {
            // behavior if no Biometrics auth method is found
        }
    }
}

#Preview {
    LocalAuthView()
}
