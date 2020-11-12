//
//  ViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-02.
//
import UIKit
import SideMenu
import SafariServices


class NewsController: UITableViewController {
    
    private var model: NewsModel? = nil
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Nyheter"
        setupTableview()

        model = NewsModel(newsController: self)
        model?.loadNextPage()
    }
    
    func setupTableview () {
    
        tableView.register(NewsItemTableViewCell.nib(), forCellReuseIdentifier: NewsItemTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    public func onDataUpdated(){
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.newsItems.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemTableViewCell.identifier, for: indexPath) as! NewsItemTableViewCell
        cell.configure(with: (model?.newsItems[indexPath.row])!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model?.newsItems.count {
            model?.loadNextPage()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = (model?.newsItems[indexPath.row])!
        let url = URL(string: newsItem.getNewsUrl())
        let vc = SFSafariViewController(url: url!)
        vc.preferredBarTintColor = ThemeManager.currentTheme().primaryColor
        vc.preferredControlTintColor = UIColor.white
        
        navigationController?.present(vc, animated: true)

    }
    
}

