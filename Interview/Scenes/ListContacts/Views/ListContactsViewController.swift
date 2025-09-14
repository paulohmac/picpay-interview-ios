import UIKit

@MainActor
class ListContactsViewController: UIViewController {
    private lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.register(ContactCell.self, forCellReuseIdentifier: String(describing: ContactCell.self))
        tableView.backgroundView = activity
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private var contacts: [Contact]?
    private var viewModel: ListContactsViewModelProtocol?
    
    init(_ viewModel: ListContactsViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        configureViews()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "viewControllerTitle".localized
        Task {
            await self.loadData()
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .red
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func loadData() async {
        do {
            self.contacts = try await viewModel?.loadContacts()
        }catch{
            let alert = UIAlertController(title: "netWorkErrorTitle".localized, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "netWorkErrorMsg".localized, style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        self.tableView.reloadData()
        self.activity.stopAnimating()

    }
    
    private func showMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "alertBoxOkButton".localized, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

extension ListContactsViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self), for: indexPath) as? ContactCell else {
            return UITableViewCell()
        }
        
        let contact = contacts?[indexPath.row]
        cell.fullnameLabel.text = contact?.name
        if let prothoUrl = contact?.photoURL{
            Task {
                let image = try await viewModel?.loadImage(prothoUrl)
                cell.contactImage.image = image
            }
        }
        cell.stopAnimation()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contato = contacts?[indexPath.row]
        var title = "tableTapSelectedWonTitle".localized
        var message = "tableTapSelectedWonMessage".localized
        if let contato = contato, !(viewModel?.isLegacy(id: contato.id) ?? false) {
            title = "tableTapSelectedTitle".localized
            message = "\(contato.name)"
        }
        showMessage(title, message)
    }
    
}
