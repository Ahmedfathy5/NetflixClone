//
//  SearchResultsViewController.swift
//  NetFlix
//
//  Created by Ahmed Fathi on 07/09/2023.
//

import UIKit

protocol SearchResultsViewControllerDElegate: AnyObject {
    func SearchResultsViewControllerDidTaped(_ viewModel : TitlePreviewViewModel)
    
    
}

class SearchResultsViewController: UIViewController {
    public var titles :[Title] = [Title]()
    public weak var delegate:SearchResultsViewControllerDElegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
        
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.dataSource = self
        searchResultCollectionView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        APICaller.shared.getMovie(with: title.original_name ?? "") { result in
            switch result {
            case .success(let videoElement):
                self.delegate?.SearchResultsViewControllerDidTaped(TitlePreviewViewModel(title: title.original_name ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))
                
                
            case.failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
        
        
        
    }
}
