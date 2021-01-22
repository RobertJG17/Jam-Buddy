//
//  ChordViewController.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 8/7/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit

class ChordViewController: UIViewController {
    
    // MARK: - Properties
    
    private let chord: String
    private let relationship: Int
    
    private lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "The \(relationship) chord"
        label.font = UIFont(name: "Avenir-Light", size: 48)
        label.textColor = UIColor.init(white: 1, alpha: 0.87)
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(chord: String, relationship: Int) {
        self.chord = chord
        self.relationship = relationship
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 127, green: 0, blue: 255)
        displayChordInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func displayChordInfo() {
        view.addSubview(testLabel)
        testLabel.centerX(inView: view)
        testLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
    }
}
