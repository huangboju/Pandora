![SamuraiTransition](https://cloud.githubusercontent.com/assets/1317847/21515399/a0b30e80-cd12-11e6-9170-fb61c0143c17.png)


SamuraiTransiton is a ViewController transition framework in Swift.

It is an animation as if Samurai cut out the screen with a sword.

![samuraitransitiondemo](https://cloud.githubusercontent.com/assets/1317847/22860410/512cbee0-f140-11e6-9485-97c6907afa05.gif)


# Usage
### Simple

```swift

// make your view controller a subclass of SamuraiViewController
// present it as normal

import SamuraiTransition

class ModalViewController: SamuraiViewController {
    //...
}

class ViewController: UIViewController {
    
    @IBAction func horizontalZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func verticalZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        // customization
        vc.samuraiTransition.zan = .vertical
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func diagonallyZan(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        // customization
        vc.samuraiTransition.zan = .diagonally
        present(vc, animated: true, completion: nil)
    }

}

```

### Attributes you can set

```swift
    //Time of transition
    public var duration: TimeInterval = 0.33
    //presenting or not
    public var presenting = true
    //horizontal　or vertical or diagonally
    public var zan = Zan.horizontal
    //enable or disable affine processing when ModalViewcontroller appears 
    public var isAffineTransform: Bool = true
    //Passing point of the sword line
    public var zanPoint: CGPoint?
    //sword line color
    public var zanLineColor = UIColor.black
    //sword line width
    public var zanLineWidth: CGFloat = 1.0

```

### Custom

```swift

class ViewController: UIViewController {
    
    let transition = SamuraiTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition.duration = 1.0
        transition.zan = Zan.vertical
        transition.isAffineTransform = false
        transition.zanLineColor = .blue
        transition.zanLineWidth = 2.0
    }

    @IBAction func tapModalButton(_ sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        let button = sender as! UIButton
        transition.zanPoint = CGPoint(x: button.center.x, y: button.center.y)
//        vc.transitioningDelegate = transition
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }

}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
}


```

# Requirements
* Xcode 8 or higher
* iOS 8.0 or higher
* Swift 3.0

# Installation
#### [CocoaPods](https://github.com/cocoapods/cocoapods)

`pod 'SamuraiTransition'`

#### [Carthage](https://github.com/Carthage/Carthage)

- Insert `github "hachinobu/SamuraiTransition"`
- Run `carthage update`.
- Link your app with `SamuraiTransition.framework` in `Carthage/Build`.

# :warning:Attention
Be careful when running the sample code of this project with the simulator.

There is a bug that the `resizableSnapshotView` method does not work on 'iPhone 7' or 'iPhone 7 plus'.
Therefore, in the case of a simulator, we will get View Snapshot in a different way.

But in that way performance is much worse than using the `resizableSnapshotView` method.

# License
SamuraiTransiton is available under the MIT license. See the LICENSE file for more info.
