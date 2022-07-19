//  
//  CharacterListViewController.swift
//  MarvelWiki
//


import UIKit
import Combine

// MARK: - ViewProtocol

protocol CharacterListViewDelegate: AnyObject {
    func refresh(withModel model: [CharacterListView.Model])
    func showNoResults()
    func showError(text: String)
    func showLoading(_ show: Bool)
}

class CharacterListViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .init(x: 0, y: 0, width: 200, height: 30))
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.placeholder = "Search characters..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .light)
        label.text = "No results."
        label.isHidden = true
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.remembersLastFocusedIndexPath = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CharacterListTableCell.self, forCellReuseIdentifier: CharacterListTableCell.identifier)
        
        return tableView
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        return view
    }()
    
    // MARK: - Properties
    
    private var model: [CharacterListView.Model]
    
    private let presenter: CharacterListPresenterProtocol
    
    private var isLoadingData: Bool = false
    
    private var getCharactersSubject = PassthroughSubject<String?, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    init(_ presenter: CharacterListPresenterProtocol) {
        self.presenter = presenter
        self.model = []
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("This init has not been implemented. Use init(:Presenter) instead.")
    }
    
    deinit {
        clear()
    }
    
    // MARK: - Setup UI
    
    override func loadView() {
        super.loadView()
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        view.fill(with: tableView, atSafeArea: false)
        view.center(view: noResultsLabel)
        view.fill(with: loadingView, atSafeArea: false)
        loadingView.isHidden = true
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showFilters(_:)))
        prepareGetCharactersSubject()
        presenter.viewDidLoad()
    }
}

// MARK: - Private functions

private extension CharacterListViewController {
    
    private func clear() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func prepareGetCharactersSubject() {
        getCharactersSubject
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { searchText in
                self.presenter.getCharacters(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func showFilters(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Characters Order",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        getCharactersOrderActions().forEach(alert.addAction(_:))
        
        // iPad
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = CGRect(x: view.frame.width, y: 44, width: 0, height: 0)
        
        present(alert, animated: true)
    }
    
    private func getCharactersOrderActions() -> [UIAlertAction] {
        CharactersOrder.allCases.map { order in
            let alertAction = UIAlertAction(title: order.textToShow + (presenter.charactersSelectedOrder == order ? " ✔️" : ""),
                                            style: .default) { action in
                self.presenter.selectCharactersOrder(order)
            }
            return alertAction
        }
    }
}

// MARK: - TableView Delegate & DataSource

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterListTableCell.identifier, for: indexPath) as? CharacterListTableCell else {
            return .init()
        }
        let cellModel = model[indexPath.row]
        cell.configure(with: cellModel)
        
        let selectionView = UIView()
        selectionView.backgroundColor = .customRed
        cell.selectedBackgroundView = selectionView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = model[indexPath.row]
        cellModel.action()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastCharacter = model.count - 1
        if indexPath.row == lastCharacter {
            let searchText = searchBar.text
            getCharactersSubject.send(searchText)
        }
    }
}

extension CharacterListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getCharactersSubject.send(searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getCharactersSubject.send(searchText)
    }
}

// MARK: - Presenter Delegate

extension CharacterListViewController: CharacterListViewDelegate {
    
    func refresh(withModel model: [CharacterListView.Model]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.model = model
            self.tableView.reloadData()
            self.showResults(true)
            self.searchBar.endEditing(true)
        }
    }
    
    func showNoResults() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showResults(false)
        }
    }
    
    func showError(text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alertViewController = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertViewController.popoverPresentationController?.sourceView = self.view
            alertViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.width / 2,
                                                                                   y: self.view.frame.height / 2,
                                                                                   width: 0,
                                                                                   height: 0)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true)
        }
    }
    
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = !show
        }
    }
    
    private func showResults(_ show: Bool) {
        self.tableView.isHidden = !show
        self.noResultsLabel.isHidden = show
    }
}
