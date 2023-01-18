//
//  AuthManager.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/15/23.
//
import FirebaseAuth
import Foundation
public class AuthManager {
    static let shared = AuthManager()
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                print("registering new user")
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        completion(false)
                        return
                    }
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                        } else  {
                            completion(false)
                        }
                        return
                    }
                }
            }
            else {
                completion(false)
                print("registration fails")
            }
            
        }
    }
    
    public func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password:password) { authResult,error in
            guard authResult != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
        
        
    }
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
}
