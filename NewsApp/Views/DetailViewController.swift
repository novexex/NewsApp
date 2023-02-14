//
//  DetailView.swift
//  intro-lab-novexex
//
//  Created by Artour Ilyasov on 04.02.2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 6
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Source", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    private var webView: WKWebView!
    
    var data: NewsEntity?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setAttributes()
        configure()
        configureButtons()
        
    }
    
    @objc private func buttonHandler() {
        guard let data, let url = data.urlToSource else { return }
        let vc = WebViewController(url: url, title: data.source)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc private func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setAttributes() {
        guard let data else { return }
        titleLabel.text = data.title
        descriptionLabel.text = data.description + "\n\nPublished at: " + data.publishedAt.replacingOccurrences(of: "T", with: " ").replacingOccurrences(of: "Z", with: "") + "\nSource: " + data.source
        if let imgData = data.imageData {
            imgView.image = UIImage(data: imgData)
        }
    }
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(didTapDone))
        navigationItem.leftBarButtonItem?.tintColor = .white
        button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
    }
    
    private func configure() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 100),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        contentView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
            imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgView.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 125),
            imgView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: imgView.centerYAnchor, constant: 200),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 130),
            descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.topAnchor.constraint(equalTo: descriptionLabel.centerYAnchor, constant: 100),
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension DetailViewController: WKNavigationDelegate {}
