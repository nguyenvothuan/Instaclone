//
//  AuthManager.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/15/23.
//
import FirebaseAuth
import Foundation
public class DatabaseManager {
    static let shared = DatabaseManager()
    
    public func registerNewUser(username: String, email: String, password: String) {
        
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: (Bool -> Void)) {
        if let email = email {
            Auth.auth().signIn(withEmail: email, password:password) { authResult,error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        
    }
    
}
