//
//  RepresentativeDetailsController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-09.
//

import UIKit
import Kingfisher

let headerViewMaxHeight: CGFloat = 300
let headerViewMinHeight: CGFloat = 44 //+  UIApplication.shared.statusBarFrame.height
let headerViewRange = headerViewMinHeight..<headerViewMaxHeight

class RepresentativeDetailsController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var outerHeaderView: UIView!
    
    var pageViewController: UIPageViewController!
    var selectedTabView = CurrentTabIndicatorView()
    private var currentpageIndex = 0
    
    private let orderedViewControllers: [UIViewController] = {
        return [RepresentativeFeedController(),
                RepresentativeAboutViewController()]
    }()
    
    private var tabLabels: [String] = ["LEDAMOTSFLÖDE", "OM"]
    
    @IBOutlet weak var nameLabel: AccentLabel!
    @IBOutlet weak var roleLabel: AccentLabel!
    @IBOutlet weak var partyProfileView: PartyProfileImage!
    @IBOutlet weak var docCountLabel: AccentLabel!
    @IBOutlet weak var voteLabel: AccentLabel!
    @IBOutlet weak var ageLabel: AccentLabel!
    
    var representative: Representative!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabLabels[1] = "OM \(representative.tilltalsnamn.uppercased())"
        setupPagingViewController()
        setupCollectionView()
        setupRepresentativeView()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationController?.navigationBar.tintColor.withAlphaComponent(0) as Any]
        
        (orderedViewControllers[0] as! RepresentativeFeedController).representative = representative
        (orderedViewControllers[1] as! RepresentativeAboutViewController).representative = representative
        
        (orderedViewControllers[0] as! RepresentativeFeedController).innerTableViewScrollDelegate = self
        (orderedViewControllers[1] as! RepresentativeAboutViewController).innerTableViewScrollDelegate = self

    }
    
    func setupRepresentativeView() {
        self.title = "\(representative.tilltalsnamn) \(representative.efternamn)"
        nameLabel.text = "\(representative.tilltalsnamn) \(representative.efternamn)"
        roleLabel.text = representative.descriptiveRole
        self.partyProfileView.setRepresentative(representative: representative, imageSize: .large)
        
        if let age = representative.age {
            ageLabel.text = String(age)
        }
        
        RepresentativeService.fetchDocumentsForRepresentative(iid: representative.intressent_id, page: 1, success: { documents, hits in
            self.docCountLabel.text = hits
        }, failure: { _ in
        
        })
        
        RepresentativeService.fetchVoteStatisticsForRepresentative(iid: representative.intressent_id, success: { statistics in
            self.voteLabel.text = statistics?.attendancePercentage
        }, failure: { _ in
        
        })
        
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
        pageViewController.view.topAnchor.constraint(equalTo: outerHeaderView.bottomAnchor, constant: 0).isActive = true
        
        
        pageViewController.setViewControllers([orderedViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func setupCollectionView() {
        
        let layout = tabBarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 50, height: 50)
        
        tabBarCollectionView.register(UINib(nibName: TabBarCollectionViewCell.identifier, bundle: nil),
                                      forCellWithReuseIdentifier: TabBarCollectionViewCell.identifier)
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        setupSelectedTabView()
    }
    
    func setupSelectedTabView() {
        selectedTabView.frame = CGRect(x: 0, y: 39, width: view.frame.width*0.5, height: 5)
        tabBarCollectionView.addSubview(selectedTabView)
    }
    
    
    
    func scrollSelectedTabView(toPercentage: CGFloat) {
        let width = view.frame.width
        let contentOffset = width * toPercentage
        self.selectedTabView.frame.origin.x = contentOffset - toPercentage * width / 2
    }
    
    
    func setPageTo(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        pageViewController.setViewControllers([orderedViewControllers[index]],
                                                  direction: navigationDirection,
                                                  animated: true,
                                                  completion: { _ in
                                                    self.currentpageIndex = index
                                                  })
    }
   
    func normalize(val: CGFloat, min: CGFloat, max: CGFloat, from a: CGFloat = 0, to b: CGFloat = 1) -> CGFloat {
        return (b - a) * ((val - min) / (max - min)) + a
    }

}

extension RepresentativeDetailsController: UIPageViewControllerDataSource {
    
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
extension RepresentativeDetailsController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let width = view.frame.width
        var percentComplete: CGFloat
        let totalOffset = point.x + CGFloat(currentpageIndex) * width
        percentComplete = abs(totalOffset - view.frame.size.width)/view.frame.size.width
        scrollSelectedTabView(toPercentage: percentComplete)
    }
}

//MARK:- Set correct page index after user scrolls
extension RepresentativeDetailsController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        currentpageIndex = orderedViewControllers.firstIndex(of: currentVC)!
    }
}

protocol InnerTableViewScrollDelegate: class {
    var currentHeaderHeight: CGFloat { get }
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
}

//MARK:- Handle headerview height when inner scrollable view controller scrolls
extension RepresentativeDetailsController: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        return headerViewHeightConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
        headerViewHeightConstraint.constant -= scrollDistance

        if headerViewHeightConstraint.constant > headerViewMaxHeight {
            headerViewHeightConstraint.constant = headerViewMaxHeight
        }
         
        if headerViewHeightConstraint.constant < headerViewMinHeight {
            headerViewHeightConstraint.constant = headerViewMinHeight
        }

        let headerViewAlpha = normalize(val: headerViewHeightConstraint.constant, min: 180, max: headerViewMaxHeight, from: 0, to: 1)
        let navigationTitleAlpha = normalize(val: headerViewHeightConstraint.constant, min: headerViewMinHeight, max: headerViewMaxHeight, from: 1, to: 0)
        headerView.alpha = headerViewAlpha
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationController?.navigationBar.tintColor.withAlphaComponent(navigationTitleAlpha)]
    }
    
}


//MARK:- Tab bar data source
extension RepresentativeDetailsController: UICollectionViewDataSource {
    
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

extension RepresentativeDetailsController: UICollectionViewDelegateFlowLayout {
    
    //MARK:- Handle tab presses. Scroll to correct tab and page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == currentpageIndex {
            return
        }
        
        var direction: UIPageViewController.NavigationDirection
        
        if indexPath.item > currentpageIndex {
            direction = .forward
        } else {
            direction = .reverse
        }
        tabBarCollectionView.scrollToItem(at: indexPath,
                                          at: .centeredHorizontally,
                                          animated: true)
        
        setPageTo(toPageWithAtIndex: indexPath.item, andNavigationDirection: direction)
    }
    
    //MARK:- Get tab size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        return CGSize(width: width * 0.45, height: 40)
    }
    
}


