//
//  ViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//
import UIKit
import SideMenu


class NewController: UITableViewController {
    
    private var newsItems: [NewsItem] = []
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Nyheter"
        let bundle = Bundle(for: NewsItemCell.self)
        let nib = UINib(nibName: "NewsItemCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        getData()
    }
    
    func getData() {
        var urlComponents = URLComponents(string: "https://data.riksdagen.se/dokumentlista/")!
        let queryItems = [
            URLQueryItem(name: "avd", value: "aktuellt"),
            URLQueryItem(name: "sort", value: "datum"),
            URLQueryItem(name: "sortorder", value: "desc"),
            URLQueryItem(name: "lang", value: "sv"),
            URLQueryItem(name: "cmskategori", value: "startsida"),
            URLQueryItem(name: "utformat", value: "json"),
            URLQueryItem(name: "p", value: "1"),
        ]
        urlComponents.queryItems = queryItems;
        
        if let test = try? Data(contentsOf: urlComponents.url!){

            if let decodedResponse = try? JSONDecoder().decode(NewsResult.self, from: test) {
                DispatchQueue.main.async {
                    self.newsItems = decodedResponse.dokumentlista.dokument
                    self.tableView.reloadData()
                }
                return
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsItemCell
        cell.setCellContent(newsItem: newsItems[indexPath.row])

        return cell
    }
    
    
    
 
    
    
}

