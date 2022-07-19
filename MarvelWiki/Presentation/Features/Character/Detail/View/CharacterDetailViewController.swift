//  
//  CharacterDetailViewController.swift
//  MarvelWiki
//


import UIKit

// MARK: - ViewProtocol

protocol CharacterDetailViewDelegate: AnyObject {
    func refresh(with model: CharacterDetailViewController.Model)
    func showError(_ error: String)
    func showLoading(_ show: Bool)
}

// MARK: - Model

extension CharacterDetailViewController {
    
    struct Model {
        var name: String
        var imageURL: URL?
        var description: String?
        var numberOfComics: Int
    }
    
}

class CharacterDetailViewController: UIViewController {

    // MARK: - Views
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = .placeholder
        imageView.clipsToBounds = true
        
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.customRed.cgColor
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .customRed
        return label
    }()
    
    private lazy var numberOfComicsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .customRed
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .customGray
        return label
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            thumbnailImageView,
            nameLabel
        ])
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topStackView,
            numberOfComicsLabel,
            descriptionLabel,
            UIView()
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.addSubview(mainStackView)
        
        return scrollView
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()
    
    // MARK: - Properties
    
    private var model: Model
    
    private let presenter: CharacterDetailPresenterProtocol
    
    private let imageWidthPercentil: CGFloat = 0.4
    
    private let scrollViewSideMargin: CGFloat = 48
    
	// MARK: - Initializers
	
	init(_ presenter: CharacterDetailPresenterProtocol) {
        self.presenter = presenter
        self.model = presenter.model
        super.init(nibName: nil, bundle: Bundle.main)
	}
	
	required init?(coder aDecoder: NSCoder) {
        fatalError("This init has not been implemented. Use init(:Presenter) instead.")
	}

    // MARK: - Setup UI
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.fill(with: scrollView, atSafeArea: false)
        view.fill(with: loadingView, atSafeArea: false)
        
        loadingView.isHidden = true

        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -scrollViewSideMargin),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 6),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: imageWidthPercentil),
            thumbnailImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: imageWidthPercentil)
        ])
        
        thumbnailImageView.layer.cornerRadius = view.bounds.width * imageWidthPercentil * 0.5
    }
    
    // MARK: - Life cycle
    
	override func viewDidLoad() {
		super.viewDidLoad()
        title = "Detail"
        presenter.viewDidLoad()
	}

    // MARK: - Functions

}

// MARK: - Presenter Delegate

extension CharacterDetailViewController: CharacterDetailViewDelegate {

    func refresh(with model: Model) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.model = model
            self.nameLabel.text = model.name
            self.descriptionLabel.text = model.description
            self.numberOfComicsLabel.text = "Number of comics: \(model.numberOfComics)"
            
            if let imageUrl = model.imageURL {
                self.thumbnailImageView.kf.setImage(with: imageUrl, placeholder: UIImage.placeholder)
            }
        }
    }
    
    func showError(_ error: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertViewController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true)
        }
    }
    
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView.isHidden = !show
        }
    }
}
