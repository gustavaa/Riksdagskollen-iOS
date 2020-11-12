//
//  NewsModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-09.
//

import Foundation


class NewsModel {
    
    var currentPage = 1;
    var newsItems: [NewsItem] = []
    let newsController: NewsController
    
    init(newsController: NewsController) {
        self.newsController = newsController
    }
    
    public func loadNextPage(){
        
        NewsService.getNews(page: currentPage) { (newsResult) in
            self.newsItems.append(contentsOf: newsResult!)
            self.currentPage += 1
            self.newsController.onDataUpdated()
        } failure: { error in
            print("Error getting news: \(error)")
        }
    }
    
}
