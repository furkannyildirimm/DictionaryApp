//
//  CustomBackButton.swift
//  Dictionary
//
//  Created by STARK on 29.05.2023.
//

import Foundation
import UIKit

class CustomBackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        setImage(UIImage(named: "left-arrow"), for: .normal)
        addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
