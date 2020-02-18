//
//  UserProfileCVCell.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/18.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol UserProfileCVCellDelegate: AnyObject {
    
}

protocol UserProfileCVCellDataSourse: AnyObject {
    func getAvata() -> UIImage
    func getLogInName() -> String
    func getHasBadge() -> Bool
    
}

typealias UserProfileCVCellViewModel = UserProfileCVCellDelegate & UserProfileCVCellDataSourse

class UserProfileCVCell: UICollectionViewCell {
    
    private let avatar: UIImageView = UIImageView()
    private let logInNameLb: UILabel = UILabel()
    private let repoNumberLb: UILabel = UILabel()
    
    private var badgeView: AnimaView = AnimaFactory.getAnima(with: .badge)
    
    typealias Delegate = UserProfileCVCellDelegate
    typealias DataSource = UserProfileCVCellDataSourse
    typealias ViewModel = UserProfileCVCellViewModel
    
    weak var delegate: Delegate?
    weak var dataSoure: DataSource? {
        didSet {
            guard let dataSource = dataSoure else {
                return
            }
            setCell(with: dataSource)
        }
    }
    
    var viewModel: ViewModel? {
        didSet {
            delegate = viewModel
            dataSoure = viewModel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError()
    }
}

extension UserProfileCVCell {
    
    private typealias My = UserProfileCVCell
    private class var avatarLength: CGFloat {60}
    private class var badgeLength: CGFloat {35}
    private class var avatarRadius: CGFloat {avatarLength / 2}
    private class var verticalpadding: CGFloat {12}
    private var horizontalPadding: CGFloat {24}
    private var gap: CGFloat {8}
}

extension UserProfileCVCell {
    
    private func setCell(with dataSource: DataSource) {
        
        setAvatar(with: dataSource)
        setLogInNameLb(with: dataSource)
        setBadge(with: dataSource)
    }
    
    private func setAvatar(with dataSource: DataSource) {
        avatar.image = dataSource.getAvata()
    }
    private func setLogInNameLb(with dataSource: DataSource) {
        logInNameLb.text = dataSource.getLogInName()
    }
    private func setBadge(with dataSource: DataSource) {
        
        guard dataSource.getHasBadge() else {
            badgeView.pause()
            badgeView.isHidden = true
            return
        }
        badgeView.isHidden = false
        badgeView.setLootMode(with: .loop)
        badgeView.play { isDone in
            
        }
    }
}

extension UserProfileCVCell {
    
    private func layoutCell() {
        
        layoutAvatar()
        layoutLogInNameLb()
        layoutBadgeView()
    }
    
    private func layoutAvatar() {
        setSameLayout(with: avatar)
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: My.avatarLength),
            avatar.heightAnchor.constraint(equalToConstant: My.avatarLength),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            avatar.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        avatar.layer.cornerRadius = My.avatarRadius
        avatar.clipsToBounds = true
    }
    
    private func layoutLogInNameLb() {
        setSameLayout(with: logInNameLb)
        NSLayoutConstraint.activate([
            logInNameLb.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: gap),
            logInNameLb.topAnchor.constraint(equalTo: avatar.topAnchor),
            logInNameLb.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -horizontalPadding
            )
        ])
        avatar.sizeToFit()
    }
    
    private func layoutBadgeView() {
        setSameLayout(with: badgeView)
        NSLayoutConstraint.activate([
            badgeView.widthAnchor.constraint(equalToConstant: My.badgeLength),
            badgeView.heightAnchor.constraint(equalToConstant: My.badgeLength),
            badgeView.leadingAnchor.constraint(equalTo: logInNameLb.leadingAnchor),
            badgeView.topAnchor.constraint(equalTo: logInNameLb.bottomAnchor, constant: gap)
        ])
    }
    
    private func setSameLayout(with view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
}
