import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var users: [GitHubUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func searchUsers(query: String) {
        Service.shared.searchUsers(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                self?.users = response.items
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error searching users: \(error.localizedDescription)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? UserDetailViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    let selectedUser = users[selectedIndexPath.row]
                    detailVC.username = selectedUser.login
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as! UserTableViewCell
        cell.configure(with: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayedSearch), object: nil)
        perform(#selector(delayedSearch), with: searchText, afterDelay: 0.5)
    }
    
    @objc private func delayedSearch(_ searchText: String) {
        searchUsers(query: searchText)
    }
}
