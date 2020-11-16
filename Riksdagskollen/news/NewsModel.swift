//
//  NewsModel.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-09.
//

import Foundation


class NewsModel {
    
    var currentPage = 1;
    var newsItems: [NewsDocument] = []
    
    public func loadNextPage(_ onDataFetched: @escaping(() -> ()), onError: @escaping((String) -> ()) ){
        
        NewsService.fetchNews(page: currentPage)
        { newsResult in
            self.newsItems.append(contentsOf: newsResult)
            self.currentPage += 1
            onDataFetched()
        }
        failure: { error in
            onError(error)
        }
    }
    
}
