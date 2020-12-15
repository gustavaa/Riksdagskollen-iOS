//
//  PartyViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-15.
//

import UIKit

class PartyViewController: UIViewController {
    
    @IBOutlet weak var tabController: TabBar!
    var pageViewController: UIPageViewController!
    var orderedViewControllers: [UIViewController]!
    var currentPageIndex = 0
    @IBOutlet weak var navbarExtensionView: NavBarExtensionView!
    
    var party: Party!
    init(party: Party) {
        super.init(nibName: nil, bundle: nil)
        self.party = party
        orderedViewControllers = [UIViewController]()
        orderedViewControllers.append(DocumentFeedController(party: party))
        orderedViewControllers.append(PartyRepresentativeListController(party: party))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagingViewController()
//        tabController.layer.backgroundColor = UIColor.red.cgColor
        tabController.subviews.forEach( { view in
            view.backgroundColor = tabController.backgroundColor
        })
        // Do any additional setup after loading the view.
    }
    
    func setupPagingViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)

        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.delegate = self
        pageViewController.dataSource = self

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: navbarExtensionView.bottomAnchor, constant: 0).isActive = true
        
        pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: false, completion: nil)
        
    }

}

extension PartyViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    
    //MARK:- Get previous viewcontroller, if any, when scrolling backwards
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewControllerIndex = orderedViewControllers.firstIndex(where: { $0 == viewController }) {
            if (1..<(orderedViewControllers.count)).contains(currentViewControllerIndex) {
                return orderedViewControllers[currentViewControllerIndex - 1]
            }
        }
        return nil
    }
    
    //MARK:- Get next viewcontroller, if any, when scrolling forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewControllerIndex = orderedViewControllers.firstIndex(where: { $0 == viewController }) {
            if (0..<(orderedViewControllers.count - 1)).contains(currentViewControllerIndex) {
                return orderedViewControllers[currentViewControllerIndex + 1]
            }
        }
        return nil
    }
    
}

//MARK:- Set correct page index after user scrolls
extension PartyViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        currentPageIndex = orderedViewControllers.firstIndex(of: currentVC)!
    }
}


