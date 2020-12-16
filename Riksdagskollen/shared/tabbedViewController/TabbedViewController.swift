//
//  TabbedViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-16.
//

import Foundation

//
//  RepresentativeDetailsController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-09.
//

import UIKit
import Kingfisher


class TabbedViewController: UIViewController {
    
    var pageViewController: UIPageViewController!
    var selectedTabView = CurrentTabIndicatorView()
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    private var currentpageIndex = 0
    private var ignoreScrollEvents = false
    private var isAnimatingToSelectedTab = false
    private var selectedTabIndex = 0
    
    var orderedViewControllers = [UIViewController]()
    var tabLabels = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagingViewController()
        setupCollectionView()
    }


    func setupPagingViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        
        for v in pageViewController.view.subviews{
            if v.isKind(of: UIScrollView.self){
                (v as! UIScrollView).delegate = self
            }
        }
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        pageViewController.didMove(toParent: self)
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        
        pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func setupCollectionView() {
        tabBarCollectionView.register(UINib(nibName: TabBarCollectionViewCell.identifier, bundle: nil),
                                      forCellWithReuseIdentifier: TabBarCollectionViewCell.identifier)
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        tabBarCollectionView.addObserver(self, forKeyPath: "contentSize", options: .old, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        setupSelectedTabView()
        tabBarCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func setupSelectedTabView() {
        let tabBarWidth = tabBarCollectionView.bounds.width
        print(tabBarCollectionView.contentSize)
        let initialTabWidth = (tabBarWidth)/CGFloat(orderedViewControllers.count)
        print(initialTabWidth)
        let height = 4 as CGFloat
        let y = tabBarCollectionView.frame.height - height
        selectedTabView.frame = CGRect(x: 0, y: y, width: initialTabWidth, height: height)
        tabBarCollectionView.addSubview(selectedTabView)
    }
    
    
    func scrollSelectedTabView(toPercentage: CGFloat) {
        
        let tabBarWidth = tabBarCollectionView.bounds.width

        let tabWidth = (tabBarWidth)/CGFloat(orderedViewControllers.count)
        self.selectedTabView.frame.origin.x = toPercentage * tabWidth
    }
    
    func scrollSelectedTabView(toIndex: Int){
        if isAnimatingToSelectedTab { return }
        isAnimatingToSelectedTab = true
        let tabBarWidth = tabBarCollectionView.frame.width
        let tabWidth = (tabBarWidth)/CGFloat(orderedViewControllers.count)
       
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedTabView.frame.origin.x = CGFloat(self.selectedTabIndex) * tabWidth
        }, completion: {_ in
            self.ignoreScrollEvents = false
            self.isAnimatingToSelectedTab = false
        })
    }
    
    
    func setPageTo(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        pageViewController.setViewControllers([orderedViewControllers[index]],
                                                  direction: navigationDirection,
                                                  animated: true,
                                                  completion: { _ in
                                                    self.currentpageIndex = index
                                                  })
    }


}

extension TabbedViewController: UIPageViewControllerDataSource {
    
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


//MARK:- Listen to page controller scroll events and animate currently selected tab indicator
extension TabbedViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Dont listen to scroll events if a tab was explicitly selected
        if ignoreScrollEvents { return }
        let point = scrollView.contentOffset
        let width = view.frame.width
        var percentComplete: CGFloat
        let totalOffset = point.x + CGFloat(currentpageIndex) * width
        percentComplete = abs(totalOffset - view.frame.size.width)/view.frame.size.width
        scrollSelectedTabView(toPercentage: percentComplete)
    }
}

//MARK:- Set correct page index after user scrolls
extension TabbedViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        currentpageIndex = orderedViewControllers.firstIndex(of: currentVC)!
    }
}

//MARK:- Tab bar data source
extension TabbedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderedViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let tabCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCell.identifier, for: indexPath) as? TabBarCollectionViewCell {
            tabCell.tabNameLabel.text = tabLabels[indexPath.row]
            tabCell.tabNameLabel.font = tabCell.tabNameLabel.font.withSize(14)
            tabCell.tabNameLabel.textAlignment = .center
            return tabCell
        }
        return UICollectionViewCell()
    }
}

//MARK:- Collection View Delegate, tab bar logic

extension TabbedViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK:- Handle tab presses. Scroll to correct tab and page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == currentpageIndex {
            return
        }
        ignoreScrollEvents = true
        selectedTabIndex = indexPath.item
        var direction: UIPageViewController.NavigationDirection
        
        if indexPath.item > currentpageIndex {
            direction = .forward
        } else {
            direction = .reverse
        }
        scrollSelectedTabView(toIndex: selectedTabIndex)
        setPageTo(toPageWithAtIndex: indexPath.item, andNavigationDirection: direction)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = tabBarCollectionView.bounds.width
        return CGSize(width: width/CGFloat(orderedViewControllers.count), height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    //MARK:- Get tab size
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = tabBarCollectionView.frame.width
//        let tabWidth = (width - 20)/CGFloat(orderedViewControllers.count)
//        print(tabWidth)
//        print(width)
//        return CGSize(width: tabWidth, height: 40)
//    }
    
}


