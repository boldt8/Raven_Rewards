//
//  PostEditViewController.swift
//  Instagram
//
//  Created by Afraz Siddiqui on 3/22/21.
//

import CoreImage
import UIKit

class ShopEditViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var filters = [UIImage]()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()

    private let image: UIImage

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Shop Edit"
        imageView.image = image
        view.addSubview(imageView)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNext))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        collectionView.frame = CGRect(
            x: 0,
            y: imageView.bottom+20,
            width: view.width,
            height: 100
        )
    }

    @objc func didTapNext() {
        guard let current = imageView.image else { return }
        let vc = ShopCaptionViewController(image: current)
        vc.title = "Add Caption"
        navigationController?.pushViewController(vc, animated: true)
    }

    // Collection

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: filters[indexPath.row])
        return cell
    }
    
}
