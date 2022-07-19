//
//  UIViewExtensions.swift
//  MarvelWiki
//

//

import UIKit

// MARK: Constraints

extension UIView {
    
    func fill(with view: UIView, edges: UIEdgeInsets = .zero, atSafeArea: Bool = true) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = atSafeArea ? safeAreaLayoutGuide.topAnchor : topAnchor
        let bottomAnchor = atSafeArea ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor
        
        let viewTopAnchor = atSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        let viewBottomAnchor = atSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
        
        addSubview(view)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: viewTopAnchor, constant: -edges.top),
            bottomAnchor.constraint(equalTo: viewBottomAnchor, constant: edges.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -edges.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edges.right)
        ])
    }
    
    func center(view: UIView, verticalSpacing: CGFloat = 0, horizontalSpacing: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -horizontalSpacing),
            view.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: -verticalSpacing)
        ])
    }
    
}
