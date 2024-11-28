//
//  IGFeedPostGeneralTableViewCell.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/8/24.
//

import UIKit

/// Comments
class IGFeedPostGeneralTableViewCell: UITableViewCell {
    static let identifier = "IGFeedPostGeneralTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemRed

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        // configure the cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
