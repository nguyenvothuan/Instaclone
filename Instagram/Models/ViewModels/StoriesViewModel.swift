//
//  StoriesViewModel.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/19/23.
//

import Foundation
import UIKit

struct StoriesViewModel {
    let stories: [Story]
}

struct Story {
    let username: String
    let image: UIImage?
}
