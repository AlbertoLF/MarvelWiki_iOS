//
//  AppCoordinator.swift
//  MarvelWiki
//

//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinator: Coordinator?
    
    var parentCoordinator: Coordinator?
    
    var navigationController: UINavigationController
    
    private let window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func resolve() {
        let viewController = ScreenFactory.makeCharacterList(navigationDelegate: self)
        navigationController.pushViewController(viewController, animated: true)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
}

// MARK: Private functions

extension AppCoordinator {
    
    private func showCharacterDetail(withIdentifier identifier: Int) {
        let viewController = ScreenFactory.makeCharacterDetail(navigationDelegate: self, characterIdentifier: identifier)
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - CharacterList

extension AppCoordinator: CharacterListNavigationDelegate {
    
    func handle(_ navigation: CharacterListNavigation) {
        switch navigation {
            case .detail(let identifier):
                showCharacterDetail(withIdentifier: identifier)
        }
    }
    
}

// MARK: - CharacterDetail
extension AppCoordinator: CharacterDetailNavigationDelegate {
    func handle(_ navigation: CharacterDetailNavigation) {
        switch navigation {
            // Do some navigations.
        }
    }
}
