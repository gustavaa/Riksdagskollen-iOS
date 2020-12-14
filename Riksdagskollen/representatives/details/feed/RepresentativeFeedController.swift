//
//  RepresentativeFeedController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-09.
//

import UIKit

enum DragDirection {
    
    case Up
    case Down
}

class RepresentativeFeedController: UITableViewController {
    
  
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    private var model: RepresentativeFeedModel!
    var representative: Representative! {
        didSet {
            model = RepresentativeFeedModel(representative: representative)
            requestMoreData()
            LoadingOverlay.shared.showOverlay(in: view)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 140
        tableView.register(PartyDocumentTableViewCell.nib(), forCellReuseIdentifier: PartyDocumentTableViewCell.identifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let m = model else { return 0 }
        return m.representativeDocuments.count
    }
    
    func requestMoreData () {
        model.loadNextPage(){
            self.tableView.reloadData()
            LoadingOverlay.shared.hideOverlayView()
        } onError: {error in
            print("error \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == model.representativeDocuments.count {
           requestMoreData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PartyDocumentTableViewCell.identifier, for: indexPath) as! PartyDocumentTableViewCell

        cell.configure(with: model.representativeDocuments[indexPath.row])
        return cell
    }
    


}

extension RepresentativeFeedController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            if delta > 0, topViewUnwrappedHeight > headerViewRange.lowerBound, scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            if delta < 0,
               topViewUnwrappedHeight < headerViewRange.upperBound, scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
 
}
