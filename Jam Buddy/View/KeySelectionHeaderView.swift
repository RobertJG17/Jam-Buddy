//
//  KeySelectionHeaderView.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 7/4/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit

protocol KeySelectionHeaderViewDelegate: class {
    
    // Delegate Methods
    func dismissViews(view: Any?)
    
    // Delegate Variables
    // Used to pass major/minor to KeyFamilViewController 
    var majorMinor: Int { get set }
}

class KeySelectionHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static weak var delegate: KeySelectionHeaderViewDelegate?

    private let keyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Please Select A Key"
        label.addShadow()
        label.textColor = UIColor(white: 1, alpha: 0.87)
        label.font = UIFont(name: "Avenir-Light", size: 36)
        return label
    }()

    private var majorMinorSelector: UISegmentedControl = {
        let selector = UISegmentedControl(items: ["Major", "Minor"])
        selector.backgroundColor = .backgroundColor
        selector.tintColor = UIColor(white: 1, alpha: 0.87)
        selector.selectedSegmentIndex = 0
        selector.addTarget(self, action: #selector(toggleBackgroundColor), for: .valueChanged)
        return selector
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 0.87)
        button.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        backgroundColor = .backgroundColor
        configureKeySelectorScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleBackButtonPressed() {
        UIView.animate(withDuration: 0.75) {
            self.backgroundColor = .backgroundColor
        }
        
        KeySelectionHeaderView.delegate?.dismissViews(view: self)
    }
    
    @objc func toggleBackgroundColor() {
        KeySelectionHeaderView.delegate?.majorMinor = majorMinorSelector.selectedSegmentIndex
        
        if majorMinorSelector.selectedSegmentIndex == 0 {
            generateMajorColors()
        } else {
            generateMinorColors()
        }
    }
    
    // MARK: - Helper Functions
    
    // Configuration For UI Elements
    func configureKeySelectorScreen() {
        
        // Back Button Configuration
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                          left: safeAreaLayoutGuide.leftAnchor,
                          paddingTop: 12,
                          paddingLeft: 12)
        fadeInAnimation(subview: backButton)
        backButton.setDimensions(height: 38, width: 38)
    
        // Key Title Label configuration
        addSubview(keyTitleLabel)
        keyTitleLabel.anchor(top: backButton.bottomAnchor,
                             paddingTop: 8)
        keyTitleLabel.centerX(inView: self)
        fadeInAnimation(subview: keyTitleLabel)
        
        // Major minor key selector
        addSubview(majorMinorSelector)
        majorMinorSelector.anchor(top: keyTitleLabel.bottomAnchor,
                                  paddingTop: 32)
        majorMinorSelector.centerX(inView: self)
        fadeInAnimation(subview: majorMinorSelector)
        
        generateMajorColors()
    }
    
    // Background Color generating functions for header view
    func generateMajorColors() {
        UIView.animate(withDuration: 0.75) {
            self.backgroundColor = UIColor.rgb(red: CGFloat(Int.random(in: 100...200)),
                                               green: CGFloat(Int.random(in: 100...200)),
                                               blue: CGFloat(Int.random(in: 100...200)))
        }
    }
    
    func generateMinorColors() {
        UIView.animate(withDuration: 0.75) {
            self.backgroundColor = UIColor.rgb(red: CGFloat(Int.random(in: 50...150)),
                                               green: CGFloat(Int.random(in: 50...150)),
                                               blue: CGFloat(Int.random(in: 50...150)))
        }
    }
}
