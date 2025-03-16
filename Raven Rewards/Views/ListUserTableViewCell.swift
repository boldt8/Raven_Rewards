//
//  ListUserTableViewCell.swift
//  Instagram
//
//  Created by Afraz Siddiqui on 3/24/21.
//

import UIKit

class ListUserTableViewCell: UITableViewCell {
    static let identifier = "ListUserTableViewCell"

    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(pointsLabel)
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        usernameLabel.sizeToFit()
        pointsLabel.sizeToFit()
        let size: CGFloat = contentView.height/1.3
        profilePictureImageView.frame = CGRect(x: 5, y: (contentView.height-size)/2, width: size, height: size)
        profilePictureImageView.layer.cornerRadius = size/2
        usernameLabel.frame = CGRect(
            x: profilePictureImageView.right+10,
            y: 0,
            width: usernameLabel.width,
            height: contentView.height)
        pointsLabel.frame = CGRect(
            x: usernameLabel.right+10,
            y: 0,
            width: pointsLabel.width,
            height: contentView.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profilePictureImageView.image = nil
    }

    func configure(with viewModel: ListUserTableViewCellViewModel) {
        usernameLabel.text = viewModel.username
        if(viewModel.points != -1){
            pointsLabel.text = "#\(viewModel.leaderBoardnumber)) \(viewModel.points) points "
        }
        StorageManager.shared.profilePictureURL(for: viewModel.username) { [weak self] url in
            DispatchQueue.main.async {
                self?.profilePictureImageView.sd_setImage(with: url, completed: nil)
            }
        }
        
    }
}
