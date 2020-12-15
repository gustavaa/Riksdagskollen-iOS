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

struct DrawerMenuItem {
    var image: UIImage
    var title: String
    
    init(title: String, imageName: String) {
        self.image = UIImage(named: imageName)!
        self.title = title
    }
    
    init(title: String, image: UIImage) {
        self.image = image
        self.title = title
    }
}

struct DrawerMenuItems {
    static let news = DrawerMenuItem(title: "Aktuellt", imageName: "riksdagskollen_logo_small")
    static let decisions = DrawerMenuItem(title: "Riksdagsbeslut", imageName: "betlogo")
    static let debate = DrawerMenuItem(title: "Debatter", imageName: "debatelogo")
    static let votes = DrawerMenuItem(title: "Voteringar", imageName: "votlogo")
    static let representatives = DrawerMenuItem(title: "Ledamöter", imageName: "replogo")
    static let protocols = DrawerMenuItem(title: "Kammarprotokoll", imageName: "replogo")
    static let M = DrawerMenuItem(title: CurrentParties.M.name, image: CurrentParties.M.logo)
    static let S = DrawerMenuItem(title: CurrentParties.S.name, image: CurrentParties.S.logo)
    static let SD = DrawerMenuItem(title: CurrentParties.SD.name, image: CurrentParties.SD.logo)
    static let C = DrawerMenuItem(title: CurrentParties.C.name, image: CurrentParties.C.logo)
    static let V = DrawerMenuItem(title: CurrentParties.V.name, image: CurrentParties.V.logo)
    static let KD = DrawerMenuItem(title: CurrentParties.KD.name, image: CurrentParties.KD.logo)
    static let MP = DrawerMenuItem(title: CurrentParties.MP.name, image: CurrentParties.MP.logo)
    static let L = DrawerMenuItem(title: CurrentParties.L.name, image: CurrentParties.L.logo)
}


protocol SideMenuDelegate {
    func didSelectMenuItem(menuEntry: DrawerMenuItem)
}

class MenuController: UITableViewController {
    public var delegate: SideMenuDelegate?
    
    private let sections = ["", "I Riksdagen", "Partier", "Övrigt"]
    private var selectedMenuItem: DrawerMenuItem?
    
    private let riksdagenMenuItems = [ DrawerMenuItems.news, DrawerMenuItems.decisions, DrawerMenuItems.debate, DrawerMenuItems.votes, DrawerMenuItems.representatives, DrawerMenuItems.protocols ]
    
    private let partyMenuItems = [ DrawerMenuItems.M, DrawerMenuItems.S, DrawerMenuItems.SD, DrawerMenuItems.C, DrawerMenuItems.V, DrawerMenuItems.KD, DrawerMenuItems.MP, DrawerMenuItems.L]
    
    private var sectionMenuItems = [[DrawerMenuItem]]()
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionMenuItems.append(riksdagenMenuItems)
        sectionMenuItems.append(partyMenuItems)
        setupTableView()
    }
    
    func setupTableView() {
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.showsVerticalScrollIndicator = false
        let bundle = Bundle(for: MenuItemCell.self)
        let nib = UINib(nibName: "MenuItemCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell
        cell.title.text = sectionMenuItems[indexPath.section-1][indexPath.row].title
        cell.itemImage?.image = sectionMenuItems[indexPath.section-1][indexPath.row].image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMenuItem = sectionMenuItems[indexPath.section-1][indexPath.row]
        delegate?.didSelectMenuItem(menuEntry: selectedMenuItem!)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return partyMenuItems.count
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
            sectionHeader.translatesAutoresizingMaskIntoConstraints = false
            sectionHeader.text = sections[section]
            sectionHeader.textColor = UIColor.black
            let wrapperView = UIView()
            wrapperView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            wrapperView.addSubview(sectionHeader)
            sectionHeader.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor, constant: 0).isActive = true
            sectionHeader.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 20).isActive = true
            return wrapperView
        }
    }
    
    func getHeader() -> UIView{
        let imageView = UIImageView()
        imageView.image = UIImage(named: "riksdagskollen_drawer")
        
        let headerView = DrawerHeaderView()
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
