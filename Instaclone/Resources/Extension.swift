//
//  Extension.swift
//  Instaclone
//
//  Created by Nguyen Vo Thuan on 1/15/23.
//

import Foundation

extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}
