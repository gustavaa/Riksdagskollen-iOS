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
    
    private let model: NewsModel
    
    init() {
        model = NewsModel()
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        UIApplication.shared.statusBarView!.backgroundColor = ThemeManager.shared.theme?.primaryColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if model.newsItems.count == 0 {
            requestMoreData()
            LoadingOverlay.shared.showOverlay(in: view)
        }
    }
    
    
    func setupTableview () {
        tableView.separatorStyle = .none
        tableView.register(NewsItemTableViewCell.nib(), forCellReuseIdentifier: NewsItemTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    func requestMoreData () {
        model.loadNextPage(){
            self.tableView.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        } onError: {error in
            // TODO: Handle error
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.newsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsItemTableViewCell.identifier, for: indexPath) as! NewsItemTableViewCell
        cell.configure(with: model.newsItems[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model.newsItems.count {
            requestMoreData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = model.newsItems[indexPath.row]
        let url = URL(string: newsItem.getNewsUrl())
        let vc = SFSafariViewController(url: url!)
        vc.preferredBarTintColor = ThemeManager.shared.theme?.primaryColor
        vc.preferredControlTintColor = ThemeManager.shared.theme?.statusBarTitleTextColor
        present(vc, animated: true, completion: nil)
    }
    
}

