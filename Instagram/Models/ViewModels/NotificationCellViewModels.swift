//
//  NotificationCellViewModels.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/17/23.
//

import Foundation

struct LikeNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
}

struct FollowNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureUrl: URL
    let isCurrentUserFollowing: Bool
    let date: String
}

struct CommentNotificationCellViewModel: Equatable {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
    let date: String
}
