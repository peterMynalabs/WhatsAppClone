//
//  ChatListTableViewCell.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/4/21.
//

import Foundation
import UIKit
import SnapKit

class ChatListTableViewCell: UITableViewCell {

    let nameTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let rightArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")?.withTintColor(UIColor(rgb: 0x3C3C43), renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    let lastMessageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(rgb: 0x8E8E93)
        label.textAlignment = .left
        return label
    }()
    
    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = "11/16/19"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(rgb: 0x8E8E93)
        label.textAlignment = .right
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "readIcon")
        return imageView
    }()
    
    let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 26
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profilePhotoImageView)
        addSubview(nameTitleLabel)
        addSubview(lastMessageTitleLabel)
        addSubview(timeStampLabel)
        addSubview(rightArrow)
        addSubview(icon)
        
        profilePhotoImageView.snp.makeConstraints({ make -> Void in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(11)
            make.size.equalTo(52)
        })
    
        nameTitleLabel.snp.makeConstraints({ make -> Void in
            make.left.equalTo(profilePhotoImageView.snp.right).offset(12)
            make.top.equalTo(self).offset(8)
            make.width.equalTo(200)
            make.height.equalTo(21)
        })
        
        lastMessageTitleLabel.snp.makeConstraints({ make -> Void in
            make.left.equalTo(profilePhotoImageView.snp.right).offset(32.5)
            make.top.equalTo(self).offset(40)
            make.width.equalTo(240)
            make.height.equalTo(17)
        })
        
        timeStampLabel.snp.makeConstraints({ make -> Void in
            make.left.equalTo(self.snp.right).inset(35 + 60)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(17)
        })
        
        rightArrow.snp.makeConstraints({ make -> Void in
            make.left.equalTo(self.snp.right).inset(18 + 7)
            make.top.equalTo(self).offset(31)
            make.width.equalTo(7)
            make.height.equalTo(21)
        })
        
        icon.snp.makeConstraints({ make -> Void in
            make.left.equalTo(profilePhotoImageView.snp.right).offset(12)
            make.top.equalTo(self).offset(40)
            make.width.equalTo(17)
            make.height.equalTo(11)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
