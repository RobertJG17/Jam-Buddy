//
//  KeyLabelCell.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 7/7/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit

class KeyTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var chordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 24)

        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func set(label: String) {
        chordLabel.text = label
    }
    
    func configureCell() {
        backgroundColor = .backgroundColor
        addSubview(chordLabel)
        chordLabel.anchor(left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 8)
        chordLabel.centerY(inView: self)
        fadeInAnimation(subview: chordLabel)
        chordLabel.numberOfLines = 0
        chordLabel.adjustsFontSizeToFitWidth = true
    }
}
