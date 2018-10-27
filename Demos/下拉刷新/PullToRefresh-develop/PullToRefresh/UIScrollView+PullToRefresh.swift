//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToRefresh
//

public extension UIScrollView {
    
    private struct AssociatedKeys {
        static var topPullToRefresh = "topPullToRefresh"
        static var bottomPullToRefresh = "bottomPullToRefresh"
    }
    
    fileprivate(set) var topPullToRefresh: PullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.topPullToRefresh) as? PullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.topPullToRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate(set) var bottomPullToRefresh: PullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.bottomPullToRefresh) as? PullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.bottomPullToRefresh, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addHeaderRefresh(handle: @escaping () -> ()) {
        addPullToRefresh(PullToRefresh(), action: handle)
    }
    
    public func addFooterRefresh(handle: @escaping () -> ()) {
        addPullToRefresh(PullToRefresh(position: .bottom), action: handle)
    }
    
    public func addPullToRefresh(_ pullToRefresh: PullToRefresh, action: @escaping () -> ()) {
        pullToRefresh.scrollView = self
        pullToRefresh.action = action
        
        var originY: CGFloat
        let refreshView = pullToRefresh.refreshView
        
        switch pullToRefresh.position {
        case .top:
            if topPullToRefresh != nil {
                removeHeaderPullToRefresh()
            }
            topPullToRefresh = pullToRefresh
            originY = -refreshView.frame.height
        case .bottom:
            if bottomPullToRefresh != nil {
                removeFooterPullToRefresh()
            }
            bottomPullToRefresh = pullToRefresh
            originY = contentSize.height
        }
        
        refreshView.frame = CGRect(x: 0, y: originY, width: frame.width, height: refreshView.frame.height)
        addSubview(refreshView)
        sendSubview(toBack: refreshView)
    }
    
    public func removePullToRefresh() {
        removeHeaderPullToRefresh()
        removeFooterPullToRefresh()
    }
    
    public func removeHeaderPullToRefresh() {
        topPullToRefresh?.refreshView.removeFromSuperview()
        topPullToRefresh = nil
    }
    
    public func removeFooterPullToRefresh() {
        bottomPullToRefresh?.refreshView.removeFromSuperview()
        bottomPullToRefresh = nil
    }
    
    public func headerStartRefreshing() {
        topPullToRefresh?.startRefreshing()
    }
    
    public func footerStartRefreshing() {
        bottomPullToRefresh?.startRefreshing()
    }
    
    public func footerEndRefreshing() {
        bottomPullToRefresh?.endRefreshing()
    }
    
    public func headerEndRefreshing() {
        topPullToRefresh?.endRefreshing()
    }
}
