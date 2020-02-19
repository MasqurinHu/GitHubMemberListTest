//
//  AnimaView.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit
import Lottie

protocol AnimaView: UIView {
    func play(done: @escaping (Bool) -> ())
    func pause()
    func setLootMode(with mode: AnimaLoopMode)
}

enum AnimeName: String {
    case loading,
    cross,
    badge,
    avatar
}

enum AnimaLoopMode {
    case playOnce,
    loop,
    autoReverSe
}

extension AnimationView: AnimaView {
    
    func play(done: @escaping (Bool) -> ()) {
        play(completion: done)
    }
    
    func setLootMode(with mode: AnimaLoopMode) {
        switch mode {
        case .playOnce:
            loopMode = .playOnce
        case .loop:
            loopMode = .loop
        case .autoReverSe:
            loopMode = .autoReverse
        }
    }
    
}

class AnimaFactory {
    class func getAnima(with name: AnimeName) -> AnimaView {
        return AnimationView(name: name.rawValue)
    }
}
