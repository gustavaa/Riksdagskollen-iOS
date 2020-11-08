//
//  MenuController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-06.
//

import Foundation
import UIKit

extension UIApplication {
    
    // Function for getting the statusBarView
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 3848245
            
            let keyWindow = UIApplication.shared.connectedScenes
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999
                
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
            
        } else {
            return nil
        }
    }
}

struct MenuItem {
    var title: String
    var imageName: String
    init(title:String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

enum MenuItems: String, CaseIterable{
    case news = "Aktuellt"
    case decisions = "Riksdagsbeslut"
    case debate = "Debatter"
    case votes = "Voteringar"
    case representatives = "Ledamöter"
    case protocols = "Kammarprotokoll"
}

protocol SideMenuDelegate {
    func didSelectMenuItem(menuItem: MenuItem)
}

class MenuController: UITableViewController {
    public var delegate: SideMenuDelegate?
    
    private let sections = ["", "I Riksdagen", "Partier", "Övrigt"]
    private var selectedMenuItem: MenuItem?
    
    private let riksdagenMenuItems = [
        MenuItem(title: "Aktuellt", imageName: "riksdagskollen_logo_small"),
        MenuItem(title: "Riksdagsbeslut", imageName: "betlogo"),
        MenuItem(title: "Debatter", imageName: "debatelogo"),
        MenuItem(title: "Voteringar", imageName: "votlogo"),
        MenuItem(title: "Ledamöter", imageName: "replogo"),
        MenuItem(title: "Kammarprotokoll", imageName: "replogo")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = ThemeManager.currentTheme().primaryColor
        setupTableView()
    }
    
    func setupTableView() {
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 60;
        let bundle = Bundle(for: MenuItemCell.self)
        let nib = UINib(nibName: "MenuItemCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell
        cell.title.text = riksdagenMenuItems[indexPath.row].title
        cell.itemImage?.image = UIImage(named: riksdagenMenuItems[indexPath.row].imageName)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMenuItem = riksdagenMenuItems[indexPath.row]
        delegate?.didSelectMenuItem(menuItem: selectedMenuItem!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return riksdagenMenuItems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0) {
            return getHeader()
        } else {
            let sectionHeader = UILabel()
            sectionHeader.text = sections[section]
            sectionHeader.textColor = UIColor.black
            sectionHeader.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return sectionHeader
        }
    }
    
    func getHeader() -> UIView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: "riksdagskollen_drawer")
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "RiksdagBlue")
        headerView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        headerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return headerView
    }
    
}
