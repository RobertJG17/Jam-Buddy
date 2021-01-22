//
//  HomeController.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 6/30/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Jam Buddy"
        label.textColor = UIColor.rgb(red: 236, green: 204, blue: 104)
        label.font = UIFont(name: "PingFangSC-Thin", size: 48)
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 245, green: 246, blue: 250), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Light", size: 32)
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureHomePageUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
    @objc func handleStart() {
        view.hideFromView(selectedViews: view.subviews,
                          completion: renderKeyCollectionController)
    }
    
    // MARK: - Helper Functions
    
    // UI Construction
    func configureHomePageUI() {
        view.backgroundColor = .backgroundColor
        
        configureTitleLabel()
        configureStartButton()
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 48)
        titleLabel.centerX(inView: view)
        view.fadeInAnimation(subview: titleLabel)
    }
    
    func configureStartButton() {
        view.addSubview(startButton)
        startButton.centerX(inView: view)
        startButton.centerY(inView: view)
        view.fadeInAnimation(subview: startButton)
    }
    
    // Next View Controller
    func renderKeyCollectionController() {
//        dismiss(animated: false, completion: nil)
        let controller = KeyCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }

}

