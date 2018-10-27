import UIKit

// MARK: - SwipeMenuViewOptions
public struct SwipeMenuViewOptions {

    public struct TabView {

        public enum Style {
            case flexible
            case segmented
            // TODO: case infinity
        }

        public enum Addition {
            case underline
            case none
        }

        public struct ItemView {
            public var width: CGFloat = 100.0
            public var margin: CGFloat = 5.0
            public var textColor: UIColor = .lightGray
            public var selectedTextColor: UIColor = .black
        }

        public struct UndelineView {
            public var height: CGFloat = 2.0
            public var margin: CGFloat = 0.0
            public var backgroundColor: UIColor = .black
            public var animationDuration: CGFloat = 0.3
        }

        // self
        public var height: CGFloat = 44.0
        public var margin: CGFloat = 0.0
        public var backgroundColor: UIColor = .clear
        public var style: Style = .flexible
        public var addition: Addition = .underline
        public var isAdjustItemViewWidth: Bool = true

        // item
        public var itemView = ItemView()

        // underline
        public var underlineView = UndelineView()
    }

    public struct ContentScrollView {

        // self
        public var backgroundColor: UIColor = .clear
        public var isScrollEnabled: Bool = true
    }

    // TabView
    public var tabView = TabView()

    // ContentScrollView
    public var contentScrollView = ContentScrollView()

    public init() { }
}

// MARK: - SwipeMenuViewDelegate

public protocol SwipeMenuViewDelegate: class {

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int)
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int)
}

extension SwipeMenuViewDelegate {

    public func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) { }
    public func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) { }
}

// MARK: - SwipeMenuViewDataSource

public protocol SwipeMenuViewDataSource: class {

    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController
}

// MARK: - SwipeMenuView

open class SwipeMenuView: UIView {

    open weak var delegate: SwipeMenuViewDelegate?

    open weak var dataSource: SwipeMenuViewDataSource?

    open fileprivate(set) var tabView: TabView? {
        didSet {
            guard let tabView = tabView else { return }
            tabView.dataSource = self
            addSubview(tabView)
            layout(tabView: tabView)
        }
    }

    open fileprivate(set) var contentScrollView: ContentScrollView? {
        didSet {
            guard let contentScrollView = contentScrollView else { return }
            contentScrollView.delegate = self
            contentScrollView.dataSource = self
            addSubview(contentScrollView)
            layout(contentScrollView: contentScrollView)
        }
    }

    private(set) var currentIndex: Int = 0

    public var isOrientationChange: Bool = false

    public var options: SwipeMenuViewOptions

    fileprivate var pageCount: Int {
        return dataSource?.numberOfPages(in: self) ?? 0
    }

    fileprivate var isJumping: Bool = false
    fileprivate var isPortrait: Bool = true

    public init(frame: CGRect, options: SwipeMenuViewOptions? = nil) {

        if let options = options {
            self.options = options
        } else {
            self.options = .init()
        }

        super.init(frame: frame)

        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }

    public required init?(coder aDecoder: NSCoder) {

        self.options = .init()

        super.init(coder: aDecoder)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        reloadData(isOrientationChange: true)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setup()
    }

    public func reloadData(options: SwipeMenuViewOptions? = nil, isOrientationChange: Bool = false) {

        if let options = options {
            self.options = options
        }

        self.isOrientationChange = isOrientationChange

        if !isOrientationChange {
            reset()
            setup()
        }

        jump(to: currentIndex)

        self.isOrientationChange = false
    }

    public func jump(to index: Int) {

        if let tabView = tabView, let contentScrollView = contentScrollView {
            tabView.jump(to: index)
            contentScrollView.jump(to: index, animated: false)
        }
    }

    public func willChangeOrientation() {
        isOrientationChange = true
    }

    internal func onOrientationChange(_ notification: Notification) {

        let deviceOrientation: UIDeviceOrientation  = UIDevice.current.orientation
        isPortrait = !UIDeviceOrientationIsLandscape(deviceOrientation)

        reloadData(isOrientationChange: true)
    }

    fileprivate func update(from fromIndex: Int, to toIndex: Int) {

        if !isOrientationChange {
            delegate?.swipeMenuView(self, willChangeIndexFrom: fromIndex, to: toIndex)
        }

        tabView?.update(toIndex)
        contentScrollView?.update(toIndex)
        currentIndex = toIndex

        if !isOrientationChange {
            delegate?.swipeMenuView(self, didChangeIndexFrom: fromIndex, to: toIndex)
        }
    }

    // MARK: - Setup
    public func setup() {

        backgroundColor = .clear

        tabView = TabView(frame: CGRect(x: 0, y: 0, width: frame.width, height: options.tabView.height), options: options.tabView)
        addTabItemGestures()

        contentScrollView = ContentScrollView(frame: CGRect(x: 0, y: options.tabView.height, width: frame.width, height: frame.height - options.tabView.height), options: options.contentScrollView)
    }

    private func layout(tabView: TabView) {

        tabView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: self.topAnchor),
            tabView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tabView.heightAnchor.constraint(equalToConstant: options.tabView.height)
            ])
    }

    private func layout(contentScrollView: ContentScrollView) {

        contentScrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: options.tabView.height),
            contentScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }

    private func reset() {

        if !isOrientationChange {
            currentIndex = 0
        }

        if let tabView = tabView, let contentScrollView = contentScrollView {
            tabView.removeFromSuperview()
            contentScrollView.removeFromSuperview()
            tabView.reset()
            contentScrollView.reset()
        }
    }
}

// MARK: - TabViewDataSource

extension SwipeMenuView: TabViewDataSource {

    public func numberOfItems(in menuView: TabView) -> Int {
        return dataSource?.numberOfPages(in: self) ?? 0
    }

    public func tabView(_ tabView: TabView, titleForItemAt index: Int) -> String? {
        return dataSource?.swipeMenuView(self, titleForPageAt: index)
    }
}

// MARK: - GestureRecognizer

extension SwipeMenuView {

    fileprivate var tapGestureRecognizer: UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapItemView(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.cancelsTouchesInView = false
        return gestureRecognizer
    }

    fileprivate func addTabItemGestures() {
        tabView?.itemViews.forEach {
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    func tapItemView(_ recognizer: UITapGestureRecognizer) {

        guard let itemView = recognizer.view as? TabItemView, let tabView = tabView, let index: Int = tabView.itemViews.index(of: itemView), let contentScrollView = contentScrollView else { return }
        if currentIndex == index { return }

        isJumping = true

        contentScrollView.jump(to: index, animated: true)
        moveTabItem(tabView: tabView, index: index)

        update(from: currentIndex, to: index)
    }

    private func moveTabItem(tabView: TabView, index: Int) {

        switch options.tabView.addition {
        case .underline:
            tabView.animateUnderlineView(index: index, completion: nil)
        case .none:
            tabView.update(index)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension SwipeMenuView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if isJumping || isOrientationChange { return }

        // update currentIndex
        if scrollView.contentOffset.x >= frame.width * CGFloat(currentIndex + 1) {
            update(from: currentIndex, to: currentIndex + 1)
        } else if scrollView.contentOffset.x <= frame.width * CGFloat(currentIndex - 1) {
            update(from: currentIndex, to: currentIndex - 1)
        }

        updateTabViewAddition(by: scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        if isJumping || isOrientationChange {
            isJumping = false
            isOrientationChange = false
            return
        }

        updateTabViewAddition(by: scrollView)
    }

    /// update addition in tab view
    private func updateTabViewAddition(by scrollView: UIScrollView) {
        switch options.tabView.addition {
        case .underline:
            moveUnderlineView(scrollView: scrollView)
        case .none:
            tabView?.update(currentIndex)
        }
    }

    /// update underbar position
    private func moveUnderlineView(scrollView: UIScrollView) {

        if let tabView = tabView, let contentScrollView = contentScrollView {

            let ratio = scrollView.contentOffset.x.truncatingRemainder(dividingBy: contentScrollView.frame.width) / contentScrollView.frame.width

            switch scrollView.contentOffset.x {
            case let offset where offset >= frame.width * CGFloat(currentIndex):
                tabView.moveUnderlineView(index: currentIndex, ratio: ratio, direction: .forward)
            case let offset where offset < frame.width * CGFloat(currentIndex):
                tabView.moveUnderlineView(index: currentIndex, ratio: ratio, direction: .reverse)
            default:
                break
            }
        }
    }
}

// MARK: - ContentScrollViewDataSource

extension SwipeMenuView: ContentScrollViewDataSource {

    public func numberOfPages(in contentScrollView: ContentScrollView) -> Int {
        return dataSource?.numberOfPages(in: self) ?? 0
    }

    public func contentScrollView(_ contentScrollView: ContentScrollView, viewForPageAt index: Int) -> UIView? {
        return dataSource?.swipeMenuView(self, viewControllerForPageAt: index).view
    }
}
