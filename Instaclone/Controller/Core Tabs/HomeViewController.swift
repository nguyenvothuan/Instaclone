//
//  HomeViewController.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/15/23.
//

import UIKit
import SwiftUI
import FirebaseAuth
class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            // show login view
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    
}
