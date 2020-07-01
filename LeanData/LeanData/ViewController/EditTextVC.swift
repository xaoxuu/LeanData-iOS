//
//  EditTextVC.swift
//  LeanData
//
//  Created by xu on 2020/7/1.
//  Copyright © 2020 xaoxuu. All rights reserved.
//

import UIKit

class EditTextVC: BaseVC {

    let tv = UITextView()
    let titleLabel = UILabel()
    private var saveCallback: ((String) -> Void)?
    
    init(title: String, text: String?, didSave: @escaping (String) -> Void) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        tv.text = text
        saveCallback = didSave
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        tv.font = .regular(17)
        tv.backgroundColor = .secondarySystemGroupedBackground
        tv.layer.cornerRadius = 12
        self.view.addSubview(self.tv)
        tv.contentInset.left = 8
        tv.contentInset.right = 8
        tv.textAlignment = .justified
        tv.contentOffset = .zero
        
        
        titleLabel.font = .bold(28)
        view.addSubview(titleLabel)
        
        let saveBtn = BaseButton(title: "保存并退出") { [weak self] in
            self?.tv.resignFirstResponder()
            self?.dismiss(animated: true, completion: nil)
            self?.saveCallback?(self?.tv.text ?? "")
        }
        saveBtn.layer.cornerRadius = ipr.layout.cornerRadius.small
        view.addSubview(saveBtn)
        saveBtn.snp.makeConstraints { (mk) in
            mk.height.equalTo(40)
            mk.right.equalToSuperview().offset(-20)
            mk.top.equalToSuperview().offset(32)
            mk.width.equalTo(134)
        }
        
        titleLabel.snp.makeConstraints { (mk) in
            mk.left.equalToSuperview().offset(20)
            mk.centerY.equalTo(saveBtn)
        }
        
        tv.snp.makeConstraints { (mk) in
            mk.left.equalToSuperview().offset(20)
            mk.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(32)
            mk.top.greaterThanOrEqualTo(saveBtn.snp.bottom).offset(32)
            mk.right.equalToSuperview().offset(-20)
            mk.height.equalTo(200)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tv.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tv.resignFirstResponder()
    }
    
}
