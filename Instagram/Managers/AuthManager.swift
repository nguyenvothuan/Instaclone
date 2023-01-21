//
//  AuthManager.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/15/23.
//

import FirebaseAuth
import Foundation

/// Object to manage authentication
final class AuthManager {
    /// Shared instanece
    static let shared = AuthManager()

    /// Private constructor
    private init() {}

    /// Auth reference
    private let auth = Auth.auth()

    /// Auth errors that can occur
    enum AuthError: Error {
        case newUserCreation
        case signInFailed
    }

    /// Determine if user is signed in
    public var isSignedIn: Bool {
        return auth.currentUser != nil
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
    
    
    /// Attempt sign in
    /// - Parameters:
    ///   - email: Email of user
    ///   - password: Password of user
    ///   - completion: Callback
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        DatabaseManager.shared.findUser(with: email) { [weak self] user in
            guard let user = user else {
                completion(.failure(AuthError.signInFailed))
                return
            }

            self?.auth.signIn(withEmail: email, password: password) { result, error in
                guard result != nil, error == nil else {
                    completion(.failure(AuthError.signInFailed))
                    return
                }

                UserDefaults.standard.setValue(user.username, forKey: "username")
                UserDefaults.standard.setValue(user.email, forKey: "email")
                completion(.success(user))
            }
        }
    }

    /// Attempt new user sign up
    /// - Parameters:
    ///   - email: Email
    ///   - username: Username
    ///   - password: Password
    ///   - profilePicture: Optional profile picture data
    ///   - completion: Callback
    public func signUp(
        email: String,
        username: String,
        password: String,
        profilePicture: Data?,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let newUser = User(username: username, email: email)
        // Create account
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(.failure(AuthError.newUserCreation))
                return
            }

            DatabaseManager.shared.createUser(newUser: newUser) { success in
                if success {
                    StorageManager.shared.uploadProfilePicture(
                        username: username,
                        data: profilePicture
                    ) { uploadSuccess in
                        if uploadSuccess {
                            completion(.success(newUser))
                        }
                        else {
                            completion(.failure(AuthError.newUserCreation))
                        }
                    }
                }
                else {
                    completion(.failure(AuthError.newUserCreation))
                }
            }
        }
    }

    /// Attempt Sign Out
    /// - Parameter completion: Callback upon sign out
    public func signOut(
        completion: @escaping (Bool) -> Void
    ) {
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
