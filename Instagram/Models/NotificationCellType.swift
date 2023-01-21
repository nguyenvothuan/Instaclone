//
//  NotificationCelltype.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/17/23.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
