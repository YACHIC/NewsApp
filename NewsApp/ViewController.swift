//
//  ViewController.swift
//  NewsApp
//
//  Created by 莊雅棋 on 2023/5/11.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    // TableView
    // Custom Cell
    // API call
    // Open the News Story
    // Search for News Stories
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self , forCellReuseIdentifier: NewsTableViewCell.indentifier)
        return table
    }()
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        fetchTopStories()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchTopStories(){
        APICaller.shared.getTopStories{ [weak self] result in
            switch result{
                case .success(let articles):
                
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(title: $0.title,
                                                   subtitle: $0.description ?? "No Description",
                                                   imageURL: URL(string: $0.urlToImage ?? "")
                        )
                    })
                
                DispatchQueue.main.sync {
                    self?.tableView.reloadData()
                }
                
                break
                
                case .failure(let error):
                    print(error)
                break
                
                
            }
            
        }
    }

    
    // Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell  = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.indentifier,
            for: indexPath
        ) as? NewsTableViewCell else{
            fatalError()
        }
        
        cell.configure(with: viewModels[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc , animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    



}

