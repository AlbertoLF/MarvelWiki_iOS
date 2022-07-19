//
//  UITableViewCellExtensions.swift
//  MarvelWiki
//

//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        String(describing: type(of: Self.self))
    }
    
}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        String(describing: type(of: Self.self))
    }
    
}
