//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/17/23.
//

import Foundation

enum ProfileButtonType {
    case edit
    case follow(isFollowing: Bool)
}

struct ProfileHeaderViewModel {
    let profilePictureUrl: URL?
    let followerCount: Int
    let followingICount: Int
    let postCount: Int
    let buttonType: ProfileButtonType
    let name: String?
    let bio: String?
}
