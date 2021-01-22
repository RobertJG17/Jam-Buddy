//
//  KeyFamilyViewController.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 7/6/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "KeyCell"

class KeyFamilyViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var tableView = UITableView()
    
    // Properties to be Initialized
    var typeOfScale: Int
    var rootKey: String
    
    var audioPlayer: AVAudioPlayer!
    var colors = [UIColor.rgb(red: 125, green: 95, blue: 255)  /*   light slate blue    */,
                  UIColor.rgb(red: 224, green: 86, blue: 253)  /*   heliotrope          */,
                  UIColor.rgb(red: 126, green: 214, blue: 223) /*   middle blue         */,
                  UIColor.rgb(red: 50, green: 255, blue: 126)  /*   wintergreen         */,
                  UIColor.rgb(red: 255, green: 82, blue: 82)   /*   fluorescent red     */,
                  UIColor.rgb(red: 255, green: 121, blue: 63)  /*   synthetic pumpkin   */,
                  UIColor.rgb(red: 249, green: 202, blue: 36)  /*   turbo               */]
    var scaleMap = [0: "Major", 1: "Minor"]
    var chord = ""
    let keys = ["A", "A♯|B♭", "B",
                "C", "C♯|D♭", "D",
                "D♯|E♭", "E", "F",
                "F♯|G♭", "G", "G♯|A♭"]
    
    var rootKeyList = [String]()
    var chordsInKey = [String]()
    
    private lazy var rootKeyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.text = "Key: \(rootKey) \(scaleMap[typeOfScale]!)"
        label.textColor = UIColor(white: 1, alpha: 0.87)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 0.87)
        button.addTarget(self, action: #selector(handleBackButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "901847-200").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 1, alpha: 0.87)
        button.addTarget(self, action: #selector(handleHomeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerView: UIView = {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.width,
                                          height: view.frame.height / 4))
        header.backgroundColor = .backgroundColor
        header.layer.borderWidth = 0.5
        header.layer.borderColor = UIColor.white.cgColor
        header.layer.cornerRadius = 24
        return header
    }()

    // MARK: - Lifecycle
    
    /// Custom Init Function
    /// - Parameters:
    ///   - rootKey: Passed From Previous View Controller String of Cell Selected by User
    ///   - typeOfScale: Passed From Previous View Controller Int Marking Whether User Selected Major or Minor
    init(rootKey: String, typeOfScale: Int) {
        self.typeOfScale = typeOfScale
        self.rootKey = rootKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureKeysInScale()
        configureKeyFamilyScreen()
        configureTableView()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
    @objc func handleBackButtonPressed() {
        if let audio = audioPlayer {
            if audio.isPlaying { audio.stop() }
        }
        
        UIView.animate(withDuration: 0.75) {
            self.view.backgroundColor = .backgroundColor
        }
        view.hideFromView(selectedViews: view.subviews) {
            self.renderKeyCollectionController()
        }
    }
    
    @objc func handleHomeButtonPressed() {
        if let audio = audioPlayer {
            if audio.isPlaying { audio.stop() }
        }
        
        UIView.animate(withDuration: 0.75) {
            self.view.backgroundColor = .backgroundColor
        }
        view.hideFromView(selectedViews: view.subviews) {
            self.renderHomeController()
        }
    }

    // MARK: - Helper Functions
    
    // Configuration For UI Elements
    func configureKeyFamilyScreen() {
        
        // Header View
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.safeAreaLayoutGuide.leftAnchor,
                          right: view.safeAreaLayoutGuide.rightAnchor,
                          paddingTop: 8)
        view.fadeInAnimation(subview: headerView)
        
        // Back Button
        view.addSubview(backButton)
        view.fadeInAnimation(subview: backButton)
        backButton.setDimensions(height: 38,
                                 width: 38)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          left: view.safeAreaLayoutGuide.leftAnchor,
                          paddingTop: 12,
                          paddingLeft: 12)
        
        // Home Button
        view.addSubview(homeButton)
        view.fadeInAnimation(subview: homeButton)
        homeButton.setDimensions(height: 38,
                                 width: 38)
        homeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          right: view.safeAreaLayoutGuide.rightAnchor,
                          paddingTop: 16,
                          paddingRight: 18)
        
        // Root Key Label
        view.addSubview(rootKeyLabel)
        view.fadeInAnimation(subview: rootKeyLabel)
        rootKeyLabel.centerX(inView: headerView)
        rootKeyLabel.anchor(top: backButton.bottomAnchor,
                            bottom: headerView.bottomAnchor,
                            paddingTop: 8,
                            paddingBottom: 16)
    }
    
    // Configuration for Proper Keys in Specified Scale
    func configureKeysInScale() {
        let root = keys.firstIndex(of: rootKey)!
        var tempList = keys[root...11]
        tempList += keys[0..<root]
        rootKeyList = Array(tempList)

        if typeOfScale == 0 {
            chordsInKey.append("I    :   \(rootKeyList[0]) Major")
            chordsInKey.append("II   :   \(rootKeyList[2]) Minor")
            chordsInKey.append("III  :   \(rootKeyList[4]) Minor")
            chordsInKey.append("IV  :   \(rootKeyList[5]) Major")
            chordsInKey.append("V   :   \(rootKeyList[7]) Major")
            chordsInKey.append("VI  :   \(rootKeyList[9]) Minor")
            chordsInKey.append("VII :   \(rootKeyList[11]) Diminished")
        } else {
            chordsInKey.append("I    :   \(rootKeyList[0]) Minor")
            chordsInKey.append("II   :   \(rootKeyList[2]) Diminished")
            chordsInKey.append("III  :   \(rootKeyList[3]) Major")
            chordsInKey.append("IV  :   \(rootKeyList[5]) Minor")
            chordsInKey.append("V   :   \(rootKeyList[7]) Minor")
            chordsInKey.append("VI  :   \(rootKeyList[8]) Major")
            chordsInKey.append("VII :   \(rootKeyList[10]) Major")
        }
    }
    
    // Configuration for TableView
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = (view.frame.height  - headerView.frame.height - 8 ) / CGFloat(chordsInKey.count)
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        tableView.separatorColor = .white
        tableView.backgroundColor = .backgroundColor
        tableView.register(KeyTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.anchor(top: headerView.bottomAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor,
                         paddingTop: 8)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Present Functions for Home and KeyCollection View Controllers
    func renderKeyCollectionController() {
        let controller = KeyCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    func renderHomeController() {
        let controller = HomeController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    func renderChordViewController(chord: String, relationship: Int) {
        let controller = ChordViewController(chord: chord, relationship: relationship)
        present(controller, animated: true)
    }
    
    // Audio Player
    func playChord(_ key: String) {
        if let path = Bundle.main.path(forResource: key, ofType: "wav") {
            
            let url = URL(fileURLWithPath: path)
            let audio = try? AVAudioPlayer(contentsOf: url)
            
            audioPlayer = audio
            audioPlayer.play()
            
        } else {
            print("ERROR LOADING WAV FILE")
            print(key)
        }
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource Protocol Methods

extension KeyFamilyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chordsInKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! KeyTableViewCell
        let chord = chordsInKey[indexPath.row]
        cell.set(label: chord)
        cell.chordLabel.textColor = colors.popLast()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.1 * Double(indexPath.row),
                       options: [.curveEaseInOut],
                       animations: {
                        cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chord = chordsInKey[indexPath.row]
        chord = chord.replacingOccurrences(of: "[ |IV:]",
                                           with: "",
                                           options: .regularExpression,
                                           range: nil)
        
        playChord(chord)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let infoAction = UIContextualAction(style: .normal, title: "Info") { (action, view, handle) in
            self.renderChordViewController(chord: self.chord, relationship: indexPath.row + 1)
        }
        
        infoAction.backgroundColor = UIColor.rgb(red: 51,
                                                 green: 153,
                                                 blue: 255)
        
        let actions = UISwipeActionsConfiguration(actions: [infoAction])
        
        return actions
    }
}
