//
//  RootViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-06.
//

import Foundation
import UIKit
import SideMenu

class MasterViewController: UIViewController, SideMenuDelegate{
    
    var newsViewController = NewsController()
    var decisionsViewController = DecisionsViewController()
    
    var menu: SideMenuNavigationController?
    
    var currentViewController: UIViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupViewController(viewController: newsViewController)
        setupViewController(viewController: decisionsViewController)
        
        currentViewController = newsViewController
        switchToViewControlller(viewController: newsViewController)
        navigationItem.title = "Aktuellt"
        navigationController?.navigationBar.barTintColor = ThemeManager.currentTheme().primaryColor
    }
    
    func setupSideMenu() {
        let menuController = MenuController()
        menuController.delegate = self
        menu = SideMenuNavigationController(rootViewController: menuController)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.rightMenuNavigationController = nil
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        menu?.presentationStyle = .viewSlideOutMenuPartialIn
    }
    
    @IBAction func onMenuTap(){
        present(menu!, animated: true)
    }
    
    func didSelectMenuItem(menuItem: MenuItem) {
        switch menuItem.title {
        case MenuItems.news.rawValue:
            switchToViewControlller(viewController: newsViewController)
            break
        case MenuItems.decisions.rawValue:
            switchToViewControlller(viewController: decisionsViewController)
            break
        case MenuItems.debate.rawValue:
            break
        default: break
        }
        navigationItem.title = menuItem.title
    }
    
    func setupViewController(viewController: UIViewController){
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.frame
        viewController.didMove(toParent: self)
        viewController.view.isHidden = true
    }
    
    func switchToViewControlller(viewController: UIViewController){
        currentViewController?.view.isHidden = true
        viewController.view.isHidden = false
        currentViewController = viewController
        dismiss(animated: true)
    }
}
