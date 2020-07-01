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
    
    private var saveCallback: ((String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        tv.font = .regular(17)
        tv.backgroundColor = .systemBackground
        tv.layer.cornerRadius = 12
        self.view.addSubview(self.tv)
        self.tv.snp.makeConstraints { (mk) in
            mk.left.equalToSuperview().offset(20)
            mk.top.equalToSuperview().offset(149 + 20)
            mk.right.equalToSuperview().offset(-20)
            mk.height.equalTo(200)
        }
        tv.contentInset.left = 8
        tv.contentInset.right = 8
        tv.textAlignment = .justified
        tv.contentOffset = .zero
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tv.becomeFirstResponder()
    }
    
    func didSave(_ callback: @escaping (String) -> Void) {
        saveCallback = callback
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
    override func loadRightNavBtnImage() -> UIImage? {
        return UIImage(systemName: "checkmark.circle.fill")
    }
    
    override func didTappedRightNavBtn(_ sender: UIBarButtonItem) {
        saveCallback?(tv.text)
        navigationController?.popViewController(animated: true)
    }
    
}
