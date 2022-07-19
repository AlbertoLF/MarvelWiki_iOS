//
//  LoadingView.swift
//  MarvelWiki
//

//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Views
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .customRed
        return activityIndicator
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        view.center(view: activityIndicator)
        return view
    }()
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    private func setupView() {
        fill(with: containerView, atSafeArea: false)
        activityIndicator.startAnimating()
    }
}
