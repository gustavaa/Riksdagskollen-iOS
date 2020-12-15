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

class RepresentativeFeedController: DocumentFeedController {
    
  
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero
    
    private var model: RepresentativeFeedModel!
    
    convenience init(representative: Representative, innerTableViewScrollDelegate: InnerTableViewScrollDelegate) {
        self.init(representative: representative)
        self.innerTableViewScrollDelegate = innerTableViewScrollDelegate
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
