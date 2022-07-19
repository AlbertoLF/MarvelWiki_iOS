//
//  Coordinator.swift
//  MarvelWiki
//

//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinator: Coordinator? { get set }
    
    var parentCoordinator: Coordinator? { get }
    
    var navigationController: UINavigationController { get }
    
    func resolve()
    
}
