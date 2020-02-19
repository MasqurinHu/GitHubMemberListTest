//
//  UserProfileModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import Foundation

struct UserProfileModel: Codable {
    let login: String
    let avatarUrl: String
    let siteAdmin: Bool
    let url: String
}
