//
//  SignInWithApple-ViewModel.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 03.11.23.
//
// Adapted from : https://firebase.google.com/docs/auth/ios/apple#sign_in_with_apple_and_authenticate_with_firebase
// Tutorial: https://www.youtube.com/watch?v=3N77zgo4oXQ
import AuthenticationServices
import CryptoKit
import FirebaseAuth

@MainActor class SignInWithAppleManager: NSObject, ObservableObject {

    @Published private(set) var user: AuthDataResultModel?
    @Published private(set) var showSighWithApple: Bool = false

    private let coreDataModel = CoreDataModel()
    private var currentNonce: String?
    private var isDeleteUser: Bool = false

    func fetchUser() {
        do {
            user = try AuthManager.shared.getAuthenticatedUser()
            showSighWithApple = false
            print("user is: \(String(describing: user))")
        } catch {
            showSighWithApple = true
            print("user is: \(String(describing: user))")
        }
    }

    func signInApple() async throws {
        isDeleteUser = false
        startSignInWithAppleFlow()
    }

    func signOut() async throws {
        do {
            try AuthManager.shared.signOut()
            showSighWithApple = true
        } catch {
            fatalError("Error during signOut: \(error.localizedDescription)")
        }
    }

    func deleteAccount() {
        isDeleteUser = true
        startSignInWithAppleFlow()
    }

    private func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = isDeleteUser ? [.email] : [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController?.presentedViewController
        authorizationController.performRequests()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

}

struct SignInWithAppleResults {
    let token: String
    let nonce: String
}

extension SignInWithAppleManager: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8),
              let nonce = currentNonce,
              let appleAuthCode = appleIDCredential.authorizationCode,
              let authCodeString = String(data: appleAuthCode, encoding: .utf8) else  {
                  print("error")
                  return
              }

        let tokens = SignInWithAppleResults(token: idTokenString, nonce: nonce)

        let fullName = FullName(firstName: appleIDCredential.fullName?.givenName, secondName: appleIDCredential.fullName?.familyName)

        Task {
            do  {
                if !isDeleteUser {
                    try await AuthManager.shared.sighInWithApple(tokens: tokens, fullName: fullName)
                    
                    let currentUserID = try AuthManager.shared.getAuthenticatedUser().uid
                    let ownedRootFolderExists = coreDataModel.folders.contains { $0.ownerId == currentUserID && $0.isRoot == true}
                    
                    if !ownedRootFolderExists {
                        
                        // TODO: Check how does it work
                        // Remove previous folders if they exists
                        for folder in coreDataModel.ownedFolders {
                            if coreDataModel.isOwner(object: folder) {
                                coreDataModel.context.delete(folder)
                                coreDataModel.saveContext()
                            }
                        }
                        
                        let ownedFolder = Folder(context: coreDataModel.context)
                        ownedFolder.createdAt = Date.now
                        ownedFolder.id = UUID()
                        ownedFolder.isRoot = true
                        ownedFolder.name = "Wishlist"
                        ownedFolder.ownerId = currentUserID
                        coreDataModel.saveContext()
                    }
                    
                    showSighWithApple = false
                } else {
                    try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                    
                    AuthManager.shared.deleteUser(tokens: tokens)
                    showSighWithApple = true
                    
                    // Delete all user folders when he delete an account
                    for folder in coreDataModel.ownedFolders {
                        if coreDataModel.isOwner(object: folder) {
                            coreDataModel.context.delete(folder)
                            coreDataModel.saveContext()
                        }
                    }
                }
            } catch {
                print("error deleting account: ", error.localizedDescription)
                showSighWithApple = true
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
