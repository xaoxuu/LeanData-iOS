//
//  BaseButton.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit
import RxCocoa

class BaseButton: UIButton {

    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = ipr.layout.cornerRadius.medium
        rx.controlEvent(.touchDown).subscribe(onNext: { [weak self] (void) in
            self?.alpha = 0.5
        }).disposed(by: disposeBag)
        rx.controlEvent([.touchUpInside,.touchUpOutside,.touchCancel]).subscribe(onNext: { [weak self] (void) in
            self?.alpha = 1
        }).disposed(by: disposeBag)
    }
    convenience init(handler: @escaping () -> Void) {
        self.init(frame: .zero)
        rx.tap.subscribe(onNext: { (void) in
            handler()
        }).disposed(by: disposeBag)
    }
    convenience init(title: String?, handler: @escaping () -> Void) {
        self.init(handler: handler)
        setTitle(title, for: .normal)
        titleEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    convenience init(image: UIImage?, handler: @escaping () -> Void) {
        self.init(handler: handler)
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        if let sv = superview {
            if let _ = titleLabel?.text {
                backgroundColor = sv.tintColor
                setTitleColor(UIColor.systemBackground, for: .normal)
            }
        }
    }
    
}
