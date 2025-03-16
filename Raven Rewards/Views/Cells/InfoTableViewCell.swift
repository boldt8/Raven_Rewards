//
//  InfoTableViewCell.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 1/5/25.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    
    static let cellId = "InfoTableViewCell"
    
    // Mark: - UI
    
    private lazy var containerVw: UIView = {
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    private lazy var contentStackVw: UIStackView = {
        let stackVw = UIStackView()
        stackVw.translatesAutoresizingMaskIntoConstraints = false
        stackVw.spacing = 4
        stackVw.axis = .vertical
        return stackVw
    }()
    
    private lazy var badgeImg: UIImageView = {
        let imgVw = UIImageView()
        imgVw.translatesAutoresizingMaskIntoConstraints = false
        imgVw.contentMode = .scaleAspectFit
        return imgVw
    }()
    
    private lazy var tempButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .white
        return btn
    }()
    
    private lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var infoLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.textColor = .white
        return lbl
    }()
    
    // Mark: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        containerVw.layer.cornerRadius = 10
    }
    
    func configure(with item: Int) {
        
        containerVw.backgroundColor = .systemGray
        
        let logo = UIImage(named: "Logo 2")
        
        
        
        switch(item){
        case 1:
            nameLbl.text = "1"
            infoLbl.text = "Create an account to get a personal QR code"
            badgeImg.image = UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
            tempButton.setImage(logo, for: .normal)
        case 2:
            nameLbl.text = "2"
            infoLbl.text = "Go to an ASB event or Sports game and check in with the Map to receive raven points"
            badgeImg.image = UIImage(systemName: "qrcode", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
            tempButton.setImage(logo, for: .normal)
        case 3:
            nameLbl.text = "3"
            infoLbl.text = "Check out the Raven Shop to see what is in stock to buy with Raven points. Items can be picked up at the Student Store"
            badgeImg.image = UIImage(systemName: "dollarsign", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
            tempButton.setImage(logo, for: .normal)
        case 4:
            nameLbl.text = "4"
            infoLbl.text = "Go Ravens! Earn free stuff while supporting your fellow students! It's a Win-Win!"
            badgeImg.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32))
            tempButton.setImage(logo, for: .normal)
        default:
            nameLbl.text = "1"
            infoLbl.text = " default"
        }
        
        self.contentView.addSubview(containerVw)
        
        containerVw.addSubview(contentStackVw)
        containerVw.addSubview(badgeImg)
        containerVw.addSubview(tempButton)
        
        contentStackVw.addArrangedSubview(nameLbl)
        contentStackVw.addArrangedSubview(infoLbl)
        
        NSLayoutConstraint.activate([
            containerVw.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            containerVw.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            containerVw.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            containerVw.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            
            
            badgeImg.heightAnchor.constraint(equalToConstant: 50),
            badgeImg.widthAnchor.constraint(equalToConstant: 25),
            badgeImg.topAnchor.constraint(equalTo: contentStackVw.topAnchor),
            badgeImg.leadingAnchor.constraint(equalTo: containerVw.leadingAnchor, constant: 8),
            
            contentStackVw.topAnchor.constraint(equalTo: containerVw.topAnchor, constant: 16),
            contentStackVw.bottomAnchor.constraint(equalTo: containerVw.bottomAnchor, constant: -16),
            contentStackVw.leadingAnchor.constraint(equalTo: badgeImg.trailingAnchor, constant: 8),
            contentStackVw.trailingAnchor.constraint(equalTo: tempButton.leadingAnchor, constant: -8),
            
            tempButton.heightAnchor.constraint(equalToConstant: 80),
            tempButton.widthAnchor.constraint(equalToConstant: 80),
            tempButton.trailingAnchor.constraint(equalTo: containerVw.trailingAnchor, constant: -8),
            tempButton.centerYAnchor.constraint(equalTo: containerVw.centerYAnchor)
        ])
    }
    
}
