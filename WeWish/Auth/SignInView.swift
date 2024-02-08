//
//  SignInView.swift
//  WeWish
//
//  Created by Nikita Pishchugin on 04.11.23.
//
import AuthenticationServices
import SwiftUI

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {

    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(
            authorizationButtonType: type,
            authorizationButtonStyle: style)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }

}

struct SignInView: View {

    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var signInWithAppleManager: SignInWithAppleManager

    // MARK: - Body
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("WeWish")
                    .font(.title2)
                    .fontWeight(.black)
                Spacer()
                Text("Sign In to became a part of our world")
                    .multilineTextAlignment(.center)
                Button(action: {
                    Task {
                        do {
                            try await signInWithAppleManager.signInApple()
                        } catch {
                            fatalError("Error during signInApple: \(error.localizedDescription)")
                        }
                    }
                }, label: {
                    SignInWithAppleButtonViewRepresentable(type: .default,
                                                           style: colorScheme == .light ? .black : .white)
                    .allowsHitTesting(false)
                })
                .cornerRadius(10)
                .frame(height: 45)
                .iPadPadding(.noValue)
                
                Spacer()
                Text("By continuing, you accept our [Terms of Use](https://www.apple.com/legal/internet-services/itunes/dev/stdeula/) and [Privacy Policy](https://nikitap1298.github.io/wewishprivacypolicy.md)")
                    .multilineTextAlignment(.center)
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SignInView()
}
