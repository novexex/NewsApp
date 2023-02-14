//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Artour Ilyasov on 04.02.2023.
//

import UIKit

class NewsEntity {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data?
    let publishedAt: String
    let source: String
    let urlToSource: URL?
    var viewsCount = 0
    
    init(title: String, description: String, imageURL: URL?, imageData: Data? = nil, publishedAt: String, source: String, urlToSource: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.imageData = imageData
        self.publishedAt = publishedAt
        self.source = source
        self.urlToSource = urlToSource
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "cell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()

    private let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(imgView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = CGRect(
            x: contentView.frame.size.width-235,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 115
        )
        
        viewsLabel.frame = CGRect(
            x: contentView.frame.size.width-235,
            y: 90,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height / 2
        )

        imgView.frame = CGRect(
            x: 10,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        viewsLabel.text = nil
        imgView.image = nil
    }

    func configure(with model: NewsEntity) {
        titleLabel.text = model.title
        viewsLabel.text = "Views: \(model.viewsCount)"

        if let data = model.imageData {
            imgView.image = UIImage(data: data)
        }
        else if let url = model.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                model.imageData = data
                DispatchQueue.main.async {
                    self?.imgView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
