//
//  UITableView + Extension.swift
//  Dictionary
//
//  Created by STARK on 1.06.2023.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellClass: T.Type) {
        let className = String(describing: T.self)
        self.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
}
