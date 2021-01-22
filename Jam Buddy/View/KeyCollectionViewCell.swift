//
//  ProfileCell.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 7/5/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit

class KeyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var label: String? {
        didSet {
            guard let text = label else { return }
            titleLabel.text = text
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 24)
        label.textColor = UIColor(white: 1, alpha: 0.87)
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTitleLabel()
    }
    
    // MARK: - Helper Functions
    
    func configureTitleLabel() {
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
        fadeInAnimation(subview: titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    

