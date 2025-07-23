import UIKit

class UserDetailViewController: UIViewController {
    
    var username: String?
    
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.clipsToBounds = true
        loadUserDetail()
    }
    
    private func loadUserDetail() {
        guard let username = username else { return }
        
        Service.shared.getUserDetail(username: username) { [weak self] result in
            switch result {
            case .success(let userDetail):
                self?.updateUI(with: userDetail)
            case .failure(let error):
                print("Error loading user detail: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI(with user: UserDetail) {
        title = user.login
        nameLabel.text = user.name ?? user.login
        usernameLabel.text = "@\(user.login)"
        bioLabel.text = user.bio
        
        bioLabel.isHidden = user.bio == nil || user.bio!.isEmpty
        
        followersLabel.text = "\(user.followers)"
        followingLabel.text = "\(user.following)"
        reposLabel.text = "\(user.publicRepos)"
        
        loadImage(from: user.avatarUrl) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }
}
