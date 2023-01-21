//
//  Notification.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/15/23.
//

import Foundation

struct IGNotification: Codable {
    let identifer: String
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let profilePictureUrl: String
    let username: String
    let dateString: String
    // Follow/Unfollow
    let isFollowing: Bool?
    // Like/Comment
    let postId: String?
    let postUrl: String?
}
