//
//  UpComingViewController.swift
//  NetFlix
//
//  Created by Ahmed Fathi on 04/09/2023.
//

import UIKit

class UpComingViewController: UIViewController {

    private var titles: [Title] = [Title]()
    
    private let UpComingTable : UITableView = {
       let tabel = UITableView()
        tabel.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tabel
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpComing"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(UpComingTable)
        UpComingTable.dataSource = self
        UpComingTable.delegate = self
        fetchUpComingData ()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UpComingTable.frame = view.bounds
    }
    
    private func fetchUpComingData (){
        APICaller.shared.getUpCommingMovie {[weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.UpComingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}
extension UpComingViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_name ?? title.original_title) ?? "UnKnown", posterURL: title.poster_path ?? "UnKnown"))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else{return}
        APICaller.shared.getMovie(with: titleName) { result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
                
            case.failure(let erorr):
                print(erorr.localizedDescription)
            }
        }
    }
}
