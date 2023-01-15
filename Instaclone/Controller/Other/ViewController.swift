//
//  ViewController.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/10/23.
//

import UIKit
import SwiftUI
class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addSignInView()
        
    }
    
    
}

private extension LoginViewController {
    
    func addSignInView() {
        func onSuccess () {
            self.dismiss(animated: true, completion: nil)
        }
        func onError() {
            let alert = UIAlertController(title: "Log In Error", message: "Wrong Credentials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            print("shit")
            present(alert, animated: true)
        }
        
        let signInView = SignInView(onSuccess: onSuccess, onError: onError)
        let controller = UIHostingController(rootView: signInView)
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
}
