//
//  PanoramaView.swift
//  Panorama Swift
//
//  Created by Sameh Mabrouk on 12/12/14.
//  Copyright (c) 2014 SMApps. All rights reserved.
//

import UIKit
import CoreMotion
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



class PanoramaView: UIView {


    //Constatnts
    let CRMotionViewRotationMinimumThreshold:CGFloat = 0.1
    let CRMotionGyroUpdateInterval:TimeInterval = 1 / 100
    let CRMotionViewRotationFactor:CGFloat = 4.0

    // Managing Motion Sensing
    fileprivate var motionManager: CMMotionManager = CMMotionManager()
    fileprivate var motionEnabled: Bool = true
    fileprivate var scrollIndicatorEnabled: Bool = true

    //Subviews
    fileprivate var viewFrame: CGRect!
    fileprivate var scrollView: UIScrollView!
    fileprivate var imageView: UIImageView!

    //Managing Motion
    fileprivate var motionRate:CGFloat!
    fileprivate var minimumXOffset:CGFloat!
    fileprivate var maximumXOffset:CGFloat!

    // The image that will be diplayed.
    fileprivate var image: UIImage!


    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewFrame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Instance methods
    func commonInit(){

        self.scrollView = UIScrollView(frame: self.viewFrame)
        self.scrollView.isUserInteractionEnabled = false
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.contentSize = CGSize.zero
        self.addSubview(self.scrollView)

        self.imageView = UIImageView(frame: self.viewFrame)
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageView.backgroundColor = UIColor.black
        self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.scrollView.addSubview(self.imageView)

        self.minimumXOffset = 0
        self.scrollIndicatorEnabled = true
        self.startMonitoring()

    }

    // MARK: - Setters
    /*
    set image for the imageview to display it to the reciever.
    */
    func setImage(_ image:UIImage){

        self.image = image

        let width = self.viewFrame.size.height / self.image.size.height * self.image.size.width
        self.imageView.frame = CGRect(x: 0, y: 0, width: width, height: self.viewFrame.height)
        self.imageView.backgroundColor = UIColor.blue
        self.imageView.image = self.image

        self.scrollView.contentSize = CGSize(width: self.imageView.frame.size.width, height: self.scrollView.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: (self.scrollView.contentSize.width - self.scrollView.frame.size.width) / 2, y: 0)

        //enable panormama indicator.
        self.scrollView.enablePanoramaIndicator()

        self.motionRate = self.image.size.width / self.viewFrame.size.width * CRMotionViewRotationFactor
        self.maximumXOffset = self.scrollView.contentSize.width - self.scrollView.frame.size.width
    }

    /*
    enable motion and recieving the gyro updates.
    */
    func setMotionEnabled(_ motionEnabled:Bool){

        self.motionEnabled = motionEnabled
        if self.motionEnabled{

            self.startMonitoring()
        }
        else{

            self.stopMonitoring()
        }
    }

    /*
    enable or disable the scrolling of the scrolling indicator of PanoramaIndicator.
    */
    func setScrollIndicatorEnabled(_ scrollIndicatorEnabled:Bool){

        self.scrollIndicatorEnabled = scrollIndicatorEnabled
        if self.scrollIndicatorEnabled{
            //enable panormama indicator.
            self.scrollView.enablePanoramaIndicator()
        }
        else{

            //disable panormama indicator.
            self.scrollView.disablePanoramaIndicator()
        }

    }

    // MARK: - Core Motion
    /*
    start monitoring the updates of the gyro to rotate the scrollview accoring the device motion rotation rate.
    */
    func startMonitoring(){


        self.motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval
        if !self.motionManager.isGyroActive && self.motionManager.isGyroAvailable{

            self.motionManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (CMGyroData, NSError) -> Void in
                self.rotateAccordingToDeviceMotionRotationRate(CMGyroData!)
            })


        }

        else{

            print("No Availabel gyro")
        }
    }

    /*
    this function calculate the rotation of UIScrollview accoring to the device motion rotation rate.
    */
    func rotateAccordingToDeviceMotionRotationRate(_ gyroData:CMGyroData){
        // Why the y value not x or z.
        /*
        *    y:
        *      Y-axis rotation rate in radians/second. The sign follows the right hand
        *      rule (i.e. if the right hand is wrapped around the Y axis such that the
        *      tip of the thumb points toward positive Y, a positive rotation is one
        *      toward the tips of the other 4 fingers).
        */
        let rotationRate = CGFloat(gyroData.rotationRate.y)
        if abs(rotationRate) >= CRMotionViewRotationMinimumThreshold{

            var offsetX = self.scrollView.contentOffset.x - rotationRate * self.motionRate
            if offsetX > self.maximumXOffset{

                offsetX = self.maximumXOffset
            }
            else if offsetX < self.minimumXOffset{

                offsetX = self.minimumXOffset
            }


            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction, .curveEaseOut], animations: { () -> Void in
                self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
                }, completion: nil)
        }


    }

    /*
    Stop gyro updates if reciever set motionEnabled = false
    */
    func stopMonitoring(){
        
        self.motionManager.stopGyroUpdates()
    }
    
}
