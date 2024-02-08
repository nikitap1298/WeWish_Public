//
//  AuthManager.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 03.11.23.
//
import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
}

class FullName {
    let firstName: String?
    let secondName: String?

    init(firstName: String?, secondName: String?) {
        self.firstName = firstName
        self.secondName = secondName
    }
}

class AuthManager {
    static let shared = AuthManager()

    private init() { }

    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        return AuthDataResultModel(user: user)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func deleteUser(tokens: SignInWithAppleResults) {
        let user = Auth.auth().currentUser
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokens.token,
            rawNonce: tokens.nonce
          )
        
        user?.reauthenticate(with: credential, completion: { result, error in
            if let error = error {
                print("Error reauthenticate user: ", error.localizedDescription)
            } else {
                user?.delete { error in
                    if let error = error {
                        print("Error deleting user in Firebase: ", error.localizedDescription)
                    } else {
                        print("Account deleted")
                    }
                }
            }
        })
    }
}

extension AuthManager {

    @discardableResult
    func sighInWithApple(tokens: SignInWithAppleResults, fullName: FullName) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokens.token,
            rawNonce: tokens.nonce
          )

        return try await signIn(credential: credential, fullName: fullName)
    }

    func signIn(credential: AuthCredential, fullName: FullName) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        let changeRequest = authDataResult.user.createProfileChangeRequest()

        if let firstName = fullName.firstName,
           let secondName = fullName.secondName {
            changeRequest.displayName = firstName  + " " + secondName

            do {
                try await changeRequest.commitChanges()
            } catch {
                print("Error saving display name: \(error.localizedDescription)")
            }
        }

        return AuthDataResultModel(user: authDataResult.user)
    }
}
