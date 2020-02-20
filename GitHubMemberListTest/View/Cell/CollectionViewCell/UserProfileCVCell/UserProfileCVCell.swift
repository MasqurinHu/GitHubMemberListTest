//
//  UserProfileCVCell.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/18.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol UserProfileCVCellDelegate: AnyObject {
    func waitForRefresh(done: @escaping () -> ())
    func cancelTask()
}

protocol UserProfileCVCellDataSourse: AnyObject {
    func getAvata() -> UIImage?
    func getLogInName() -> String
    func getHasBadge() -> Bool
    func getUserInfoUrlString() -> String?
}

typealias UserProfileCVCellViewModel = UserProfileCVCellDelegate & UserProfileCVCellDataSourse

class UserProfileCVCell: UICollectionViewCell {
    
    private let avatar: UIImageView = UIImageView()
    private let logInNameLb: UILabel = UILabel()
    private let repoNumberLb: UILabel = UILabel()
    private let anima: AnimaView = AnimaFactory.getAnima(with: .avatar)
    
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
            delegate?.waitForRefresh { [weak self] in
                
                DispatchQueue.main.async { [weak self] in
                    guard let dataSource = self?.dataSoure else {
                        return
                    }
                    self?.setCell(with: dataSource)
                }
            }
        }
    }
    
    private var viewModel: ViewModel?
    
    func setViewModel(with viewModel: ViewModel) {
        self.viewModel?.cancelTask()
        self.viewModel = viewModel
        delegate = viewModel
        dataSoure = viewModel
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
        if let _ = dataSource.getAvata() {
            anima.isHidden = true
            anima.pause()
        } else {
            anima.isHidden = false
            anima.setLootMode(with: .autoReverSe)
            anima.play { isDone in
            }
        }
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
        
        setSameAvatarLayout(with: anima)
        setSameAvatarLayout(with: avatar)
        avatar.layer.cornerRadius = My.avatarRadius
        avatar.clipsToBounds = true
    }
    
    private func setSameAvatarLayout(with newView: UIView) {
        
        setSameLayout(with: newView)
        NSLayoutConstraint.activate([
            newView.widthAnchor.constraint(equalToConstant: My.avatarLength),
            newView.heightAnchor.constraint(equalToConstant: My.avatarLength),
            newView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            newView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
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
