//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Bruno Guedes on 20/10/19.
//  Copyright © 2019 Bruno Guedes. All rights reserved.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {

    static let reuseIdentifier = "LaunchTableViewCell"
    
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addNameLabel()
        addDateLabel()
        addStatusLabel()
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacing2x),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacing2x),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacing2x),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .spacing1x),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacing2x),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacing2x),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: .spacing1x),
            statusLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: .spacing2x),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacing2x),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacing2x),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNameLabel() {
        nameLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont.systemFont(ofSize: 20))
        nameLabel.numberOfLines = 0
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .label
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.clipsToBounds = true
        contentView.addSubview(nameLabel)
    }
    
    func addDateLabel() {
        dateLabel.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: UIFont.systemFont(ofSize: 16))
        dateLabel.numberOfLines = 0
        dateLabel.backgroundColor = .clear
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .left
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.clipsToBounds = true
        contentView.addSubview(dateLabel)
    }
    
    func addStatusLabel() {
        statusLabel.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: UIFont.systemFont(ofSize: 16))
        statusLabel.numberOfLines = 0
        statusLabel.backgroundColor = .clear
        statusLabel.textColor = .secondaryLabel
        statusLabel.textAlignment = .right
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.clipsToBounds = true
        contentView.addSubview(statusLabel)
    }
    
    public func configure(launchViewModel: LaunchViewModel) {
        nameLabel.text = launchViewModel.name
        dateLabel.text = launchViewModel.date
        statusLabel.text = launchViewModel.status
    }

}
