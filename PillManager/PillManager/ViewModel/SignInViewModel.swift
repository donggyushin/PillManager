//
//  SignInViewModel.swift
//  PillManager
//
//  Created by 신동규 on 2022/03/20.
//

import AuthenticationServices
import Combine

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
            let userIdentifier = appleIDCredential.user
            print("DEBUG: userIdentifier: \(userIdentifier)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.loading = false
        self.error = error
    }
}
