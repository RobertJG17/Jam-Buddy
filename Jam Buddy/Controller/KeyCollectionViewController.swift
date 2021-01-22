//
//  KeyCollectionViewController.swift
//  Jam Buddy
//
//  Created by Robert Guerra on 7/4/20.
//  Copyright © 2020 Robert Guerra. All rights reserved.
//

import UIKit

private let headerIdentifier = "ProfileHeader"
private let cellIdentifier = "ProfileCell"

class KeyCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var typeOfScale: Int = 0
    var rootKey: String = ""
    let keys: [String] = ["A", "A♯|B♭", "B",
                          "C", "C♯|D♭", "D",
                          "D♯|E♭", "E", "F",
                          "F♯|G♭", "G", "G♯|A♭"]
    
    // MARK: - Lifecycle
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        KeySelectionHeaderView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .backgroundColor
        
        // register header
        collectionView!.register(KeySelectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        // register cell
        collectionView.register(KeyCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions

    func renderKeyFamilyController() {
//        dismiss(animated: false, completion: nil)
        let controller = KeyFamilyViewController(rootKey: rootKey, typeOfScale: majorMinor)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    func renderHomeController() {
//        dismiss(animated: false, completion: nil)
        let controller = HomeController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
}

// MARK: - KeySelectionHeaderViewDelegate

extension KeyCollectionViewController: KeySelectionHeaderViewDelegate {
    var majorMinor: Int {
        get {
            return typeOfScale
        }
        set {
            typeOfScale = newValue
        }
    }
    
    func dismissViews(view: Any?) {
        if let view = view {
            switch (view) {
            case is KeySelectionHeaderView:
                collectionView.hideFromView(selectedViews: collectionView.subviews,
                                            completion: renderHomeController)
            case is KeyCollectionViewController:
                collectionView.hideFromView(selectedViews: collectionView.subviews,
                                            completion: renderKeyFamilyController)
            default:
                break
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension KeyCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! KeySelectionHeaderView
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! KeyCollectionViewCell
        
        cell.backgroundColor = .backgroundColor
        cell.titleLabel.text = keys[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rootKey = keys[indexPath.row]
        dismissViews(view: self)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension KeyCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.055 * Double(indexPath.row),
                       options: [.curveEaseInOut],
                       animations: {
                        cell.alpha = 1
        })
    }
}

