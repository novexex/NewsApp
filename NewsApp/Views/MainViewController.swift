//
//  ViewController.swift
//  NewsApp
//
//  Created by Artour Ilyasov on 04.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var models = [NewsEntity]() {
        didSet {
            for i in models.enumerated() {
                cache.setObject(i.element, forKey: NSString(string: "\(i.offset)"))
            }
        }
    }
    private let cache = NSCache<NSString, NewsEntity>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
        tableViewConfigure()
    }
    
    private func fetchData() {
        if let model = cache.object(forKey: NSString(string: "0")) {
            models.append(model)
            print("huy")
        } else {
            NewsData.shared.getData { [weak self] result in
                self?.articles = result
                self?.models = result.compactMap({ NewsEntity(title: $0.title, description: $0.description ?? "", imageURL: URL(string: $0.urlToImage ?? ""), publishedAt: $0.publishedAt, source: $0.source.name, urlToSource: URL(string: $0.url ?? "")) })
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func tableViewConfigure() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        fetchData()
        tableView.reloadData()
        sender.endRefreshing()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "News"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        models[indexPath.row].viewsCount += 1
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.data = models[indexPath.row]
        present(navVC, animated: true)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: models[indexPath.row])
        return cell
        
    }
}
