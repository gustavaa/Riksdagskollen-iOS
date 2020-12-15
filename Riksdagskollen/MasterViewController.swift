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
    
    
    var viewControllers = [String : UIViewController]()
    
    @IBOutlet weak var optionsBarButton: UIBarButtonItem!
    
    var menu: SideMenuNavigationController?
    
    var currentViewController: UIViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setInitialVC()
        RepresentativeService.fetchAllCurrentRepresentatives(success: {_ in}, failure: {_ in})
        setOptionsButtonHidden(hidden: true)
    }
    
    func setInitialVC(){
        viewControllers[DrawerMenuItems.news.title] = NewsController()
        setupViewController(viewController: viewControllers[DrawerMenuItems.news.title]!)
        switchToViewController(viewController: viewControllers[DrawerMenuItems.news.title]!)
        navigationItem.title = DrawerMenuItems.news.title
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
    
    func didSelectMenuItem(menuEntry: DrawerMenuItem) {
        setOptionsButtonHidden(hidden: true)
        if viewControllers[menuEntry.title] == nil {
            switch menuEntry.title {
            case DrawerMenuItems.news.title:
                viewControllers[menuEntry.title] = NewsController()
            case DrawerMenuItems.decisions.title:
                viewControllers[menuEntry.title] = DecisionsController()
            case DrawerMenuItems.debate.title:
                viewControllers[menuEntry.title] = DebateFeedController()
            case DrawerMenuItems.votes.title:
                viewControllers[menuEntry.title] = VotingFeedController()
            case DrawerMenuItems.representatives.title:
                viewControllers[menuEntry.title] = RepresentativesListController()
            case DrawerMenuItems.protocols.title:
                viewControllers[menuEntry.title] = ProtocolsFeedController()
            case DrawerMenuItems.M.title, DrawerMenuItems.S.title, DrawerMenuItems.SD.title, DrawerMenuItems.C.title, DrawerMenuItems.V.title, DrawerMenuItems.KD.title, DrawerMenuItems.MP.title, DrawerMenuItems.L.title:
                viewControllers[menuEntry.title] = PartyViewController(party: CurrentParties.getParty(name: menuEntry.title)!)
            default:
                return
            }
        }
        setupViewController(viewController: viewControllers[menuEntry.title]!)
        switchToViewController(viewController: viewControllers[menuEntry.title]!)
        navigationItem.title = menuEntry.title
    }
    
    func setOptionsButtonHidden(hidden: Bool){
        if hidden{
             optionsBarButton?.isEnabled = false
            optionsBarButton?.tintColor = UIColor.clear
         } else{
            optionsBarButton?.isEnabled = true
            optionsBarButton?.tintColor = nil
         }
    }
    
    func setupViewController(viewController: UIViewController){
        addChild(viewController)
        view.addSubview(viewController.view)

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
