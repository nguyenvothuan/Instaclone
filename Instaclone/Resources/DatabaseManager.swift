//
//  DatabaseManager.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/15/23.
//

import FirebaseDatabase

public class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    public func canCreateNewUser(with email: String, username: String, completion: (Bool)->Void) {
        completion(true)
    }
    
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool)-> Void) {
        
        database.child(email.safeDatabaseKey()).setValue(["username":username], withCompletionBlock: {error, _ in
            if error == nil {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
}
