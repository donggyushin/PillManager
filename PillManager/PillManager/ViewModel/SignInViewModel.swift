//
//  SignInViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import AuthenticationServices
import Combine
import CryptoKit
import FirebaseAuth

class SignInViewModel: NSObject {
    
    @Published var error: Error?
    @Published var loading = false
    
    var cancellables: Set<AnyCancellable> = .init()
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
}

extension SignInViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        viewController.view.window ?? UIWindow()
    }
}

extension SignInViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.loading = false
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nil)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                self?.error = error
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.loading = false
        self.error = error
    }
}
