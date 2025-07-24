//
//  UserTableViewCell.swift
//  search_github
//
//  Created by Nguyen Duc on 15/07/2025.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.clipsToBounds = true
    }
    
    func configure(with user: GitHubUser) {
        usernameLabel.text = user.login
        avatarImageView.image = nil
        
        loadImage(from: user.avatarUrl) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        usernameLabel.text = nil
    }
}
