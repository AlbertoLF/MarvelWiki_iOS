//
//  CharacterListView.swift
//  MarvelWiki
//

//

import UIKit
import Kingfisher

class CharacterListTableCell: UITableViewCell {
    
    let view = CharacterListView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.fill(with: view)
    }
    
    func configure(with model: CharacterListView.Model) {
        view.configure(with: model)
    }
    
}

class CharacterListView: UIView {
    
    // MARK: - Model
    
    struct Model {
        var name: String
        var imageURL: String?
        var action: Action
    }
    
    // MARK: - Views
    
    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.borderColor = UIColor.customRed.cgColor
        imageView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.widthAnchor.constraint(equalToConstant: 64)
        ])
        
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .customRed
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            characterImageView,
            nameLabel
        ])
        stackView.spacing = 16
        return stackView
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 5
        
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: 2)
        
        view.fill(with: mainStackView, edges: .init(top: 8, left: 8, bottom: 8, right: 8))
        return view
    }()
    
    // MARK: - Properties
    
    var model: Model = .init(name: "Character Name", imageURL: nil, action: {})
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        characterImageView.layer.cornerRadius = characterImageView.bounds.height * 0.5
    }
    
    private func setupView() {
        fill(with: containerView, edges: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    func configure(with model: Model) {
        self.model = model
        nameLabel.text = model.name
        if let imageURL = model.imageURL {
            let url = URL(string: imageURL)
            characterImageView.kf.setImage(with: url, placeholder: UIImage.placeholder)
        } else {
            characterImageView.image = .placeholder
        }
    }
}
