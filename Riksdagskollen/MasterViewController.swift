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
    
    var votesViewController: VotingFeedController?
    var newsViewController: NewsController?
    var decisionsViewController: DecisionsController?
    var debateViewController: DebateFeedController?
    var representativesViewController: RepresentativesListController?

    var menu: SideMenuNavigationController?
    
    var currentViewController: UIViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        newsViewController = NewsController()
        setupViewController(viewController: newsViewController!)
        currentViewController = newsViewController
        switchToViewController(viewController: newsViewController!)
        navigationItem.title = "Aktuellt"
        RepresentativeService.fetchAllCurrentRepresentatives(success: {_ in}, failure: {_ in})
    }
    
    func setupSideMenu() {
        let menuController = MenuController()
        menuController.delegate = self
        menu = SideMenuNavigationController(rootViewController: menuController)
        menu?.leftSide = true
        menu?.menuWidth = 300
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
            if newsViewController == nil {
                newsViewController = NewsController()
                setupViewController(viewController: newsViewController!)
            }
            switchToViewController(viewController: newsViewController!)
            break
        case MenuItems.decisions.rawValue:
            if decisionsViewController == nil {
                decisionsViewController = DecisionsController()
                setupViewController(viewController: decisionsViewController!)
            }
            switchToViewController(viewController: decisionsViewController!)
            break
        case MenuItems.debate.rawValue:
            if debateViewController == nil {
                debateViewController = DebateFeedController()
                setupViewController(viewController: debateViewController!)
            }
            switchToViewController(viewController: debateViewController!)
            break
        case MenuItems.votes.rawValue:
            if votesViewController == nil {
                votesViewController = VotingFeedController()
                setupViewController(viewController: votesViewController!)
            }
            switchToViewController(viewController: votesViewController!)
            break
        case MenuItems.representatives.rawValue:
            if representativesViewController == nil {
                representativesViewController = RepresentativesListController()
                setupViewController(viewController: representativesViewController!)
            }
            switchToViewController(viewController: representativesViewController!)
            break
        default: break
        }
        navigationItem.title = menuItem.title
    }
    
    func setupViewController(viewController: UIViewController){
        addChild(viewController)
        view.addSubview(viewController.view)
        print(view.frame)
        if let cvc = currentViewController {
            viewController.view.frame = cvc.view.frame
        } else {
            viewController.view.frame = view.frame
        }
        viewController.didMove(toParent: self)
        viewController.view.isHidden = true
    }
    
    func switchToViewController(viewController: UIViewController){
        currentViewController?.view.isHidden = true
        viewController.view.isHidden = false
        currentViewController = viewController
        dismiss(animated: true)
    }
}
