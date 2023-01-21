//
//  SettingsModels.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/19/23.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let image: UIImage?
    let color: UIColor
    let handler: (() -> Void)
}
