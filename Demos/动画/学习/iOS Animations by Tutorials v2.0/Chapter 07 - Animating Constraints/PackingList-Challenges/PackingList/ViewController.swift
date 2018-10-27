/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class ViewController: UIViewController {
  
  //MARK: IB outlets
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var buttonMenu: UIButton!
  @IBOutlet var titleLabel: UILabel!
  
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
  //MARK: further class variables
  
  var slider: HorizontalItemList!
  var isMenuOpen = false
  var items: [Int] = [5, 6, 7]
  
  //MARK: class methods
  
  @IBAction func actionToggleMenu(sender: AnyObject) {
    
    for con in titleLabel.superview!.constraints {
      print(" -> \(con.description)\n")
    }

    isMenuOpen = !isMenuOpen
    
    for constraint in titleLabel.superview!.constraints {
      if constraint.firstItem as? NSObject == titleLabel &&
        constraint.firstAttribute == .CenterX {
          constraint.constant = isMenuOpen ? -100.0 : 0.0
          continue
      }
      
      if constraint.identifier == "TitleCenterY" {
        constraint.active = false
        
        //add new constraint
        let newConstraint = NSLayoutConstraint(
          item: titleLabel,
          attribute: .CenterY,
          relatedBy: .Equal,
          toItem: titleLabel.superview!,
          attribute: .CenterY,
          multiplier: isMenuOpen ? 0.67 : 1.0,
          constant: 5.0)
        newConstraint.identifier = "TitleCenterY"
        newConstraint.active = true

        continue
      }
    }
    
    menuHeightConstraint.constant = isMenuOpen ? 200.0 : 60.0
    titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"

    UIView.animateWithDuration(1.0, delay: 0.0,
      usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0,
      options: .CurveEaseIn, animations: {
        self.view.layoutIfNeeded()

        let angle = self.isMenuOpen ? CGFloat(M_PI_4) : 0.0
        self.buttonMenu.transform = CGAffineTransformMakeRotation(angle)

      }, completion: nil)

    if isMenuOpen {
      slider = HorizontalItemList(inView: view)
      slider.didSelectItem = {index in
        print("add \(index)")
        self.items.append(index)
        self.tableView.reloadData()
        self.actionToggleMenu(self)
      }
      self.titleLabel.superview!.addSubview(slider)
    } else {
      slider.removeFromSuperview()
    }

  }
  
  func showItem(index: Int) {
    print("tapped item \(index)")
    
    let imageView  = UIImageView(image:
      UIImage(named: "summericons_100px_0\(index).png"))
    imageView.backgroundColor = UIColor(red: 0.0, green: 0.0,
      blue: 0.0, alpha: 0.5)
    imageView.layer.cornerRadius = 5.0
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)

    let conX = imageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
    let conBottom = imageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: imageView.frame.height)
    let conWidth = imageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.33, constant: -50.0)
    let conHeight = imageView.heightAnchor.constraintEqualToAnchor(
      imageView.widthAnchor)
    NSLayoutConstraint.activateConstraints([conX, conBottom, conWidth, conHeight])
    
    view.layoutIfNeeded()
    
    UIView.animateWithDuration(0.8, delay: 0.0,
      usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
      options: [], animations: {
        conBottom.constant = -imageView.frame.size.height/2
        conWidth.constant = 0.0
        self.view.layoutIfNeeded()
      }, completion: nil)

    UIView.animateWithDuration(0.8, delay: 1.0,
      usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0,
      options: [], animations: {
        conBottom.constant = imageView.frame.size.height
        conWidth.constant = -50.0
        self.view.layoutIfNeeded()
      }, completion: {_ in
        imageView.removeFromSuperview()
    })
  }
}


let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  // MARK: View Controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView?.rowHeight = 54.0
  }
  
  // MARK: Table View methods
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
    cell.accessoryType = .None
    cell.textLabel?.text = itemTitles[items[indexPath.row]]
    cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    showItem(items[indexPath.row])
  }
  
}