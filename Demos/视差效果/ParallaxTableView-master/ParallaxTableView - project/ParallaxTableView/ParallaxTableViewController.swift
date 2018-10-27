// The MIT License (MIT)
// Copyright © 2016 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class ParallaxTableViewController: SPParallaxTableViewController {
    
    private let cellCount: Int = 24
    
    private var titles: [String]!
    private var subtitles: [String]!
    private var backgroundImages: [UIImage]!
    
    private var cellHeight: CGFloat = 240
    private var selectedCellHeight: CGFloat = 310
    
    private let cellIdentificator = "ParallaxTableViewCell"
    private var selectedCellIndex: IndexPath = IndexPath.init()
    
    private let normalCellGradeAlpha: CGFloat = 0.5
    private let selectedCellGradeAlpha: CGFloat = 0.2
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isHiddenStatusBar
    }
    
    private var isHiddenStatusBar: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titles = DataAPI.getTitles()
        self.backgroundImages = DataAPI.getBackgroundImages()
        
        tableView.contentInset = UIEdgeInsetsMake(
            -cellHeight * 0.2,
            0, 0, 0
        );
        
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        tableView.register(ParallaxTableViewCell.self, forCellReuseIdentifier: self.cellIdentificator)
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellCount
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        let offsetY = scrollView.contentOffset.y + 20 - cellHeight * 0.26
        if (offsetY > 20) {
            self.isHiddenStatusBar = true
        } else {
            self.isHiddenStatusBar = false
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentificator) as! ParallaxTableViewCell
        cell.parallaxSize = 150

        let x: Int = indexPath.row / self.backgroundImages.count
        let cellIndex = indexPath.row - x * self.backgroundImages.count
        
        cell.gradeView.alpha = self.normalCellGradeAlpha
        if indexPath == self.selectedCellIndex {
            cell.gradeView.alpha = self.selectedCellGradeAlpha
        }
        cell.backgroundImageView.image = self.backgroundImages[cellIndex]
        cell.titleLabel.text = self.titles[cellIndex]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedCellIndex {
            return self.selectedCellHeight
        }
        return self.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var needShowOpenAnimation: Bool = false
        
        if (selectedCellIndex == indexPath) {
            selectedCellIndex = IndexPath.init()
            needShowOpenAnimation = false
        } else {
            selectedCellIndex = indexPath
            needShowOpenAnimation = true
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        for cell in tableView.visibleCells {
            let parallaxCell = cell as! ParallaxTableViewCell
            
            SPAnimation.animate(
                0.3, animations: {
                    
                    parallaxCell.parallaxOffset(self.tableView)
                    parallaxCell.gradeView.alpha = self.normalCellGradeAlpha
                    parallaxCell.layoutIfNeeded()
                    
            }, options: [.curveEaseInOut]
            )
        }
        
        if needShowOpenAnimation {
            
            let cell = tableView.cellForRow(at: indexPath) as! ParallaxTableViewCell
            
            SPAnimation.animate(
                0.3, animations: {
                    
                    cell.gradeView.alpha = self.selectedCellGradeAlpha
                    cell.layoutIfNeeded()
                    
            }, options: [.curveEaseInOut]
            )
            
        }
    }
}
