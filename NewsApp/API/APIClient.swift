//
//  APIClient.swift
//  intro-lab-novexex
//
//  Created by Artour Ilyasov on 04.02.2023.
//

import Foundation

// MARK: - News
struct Response: Codable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}


final class NewsData {
    
    static let shared = NewsData()
    
    private let apiKey = "&apiKey=5321ba914914497c8ec09294122ff818"
    
    public func getData(completion: @escaping ([Article]) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us\(apiKey)") else { return }
        var request = URLRequest(url: url, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data else { return }
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                print("Articels: \(result.articles.count)")
                completion(result.articles)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
