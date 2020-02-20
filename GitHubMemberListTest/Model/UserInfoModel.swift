//
//  UserInfoModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/20.
//  Copyright © 2020 五加一. All rights reserved.
//

import Foundation

struct UserInfoModel: Codable {
    
    let avatarUrl: String?
    let name: String?
    let bio: String?
    let login: String?
    let siteAdmin: Bool
    let location: String?
    let blog: String?
}
