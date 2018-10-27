//
//    MIT License
//
//    Copyright (c) 2017 Touchwonders B.V.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


open class PushTransitionAnimation : EdgeTransitionAnimation {
        
    private weak var topView: UIView?
    private weak var bottomView: UIView?
    
    private var topTargetTransform: CGAffineTransform = .identity
    private var bottomTargetTransform: CGAffineTransform = .identity
    
    private var isDismissing: Bool = false
    
    open override func setup(in operationContext: TransitionOperationContext) {
        let context = operationContext.context
        
        guard let topView = context.defaultViewSetup(for: operationContext.operation),
            let transitionEdge = transitionScreenEdgeFor(operation: operationContext.operation)
            else { return }
        self.topView = topView
        self.bottomView = topView == context.toView ? context.fromView : context.toView
        
        isDismissing = operationContext.operation.isDismissing
        
        let effectiveTransitionEdge = isDismissing ? transitionEdge.opposite : transitionEdge
        
        //  Top
        let topHiddenTransform = transformForTranslatingViewTo(edge: effectiveTransitionEdge, outside: context.containerView.bounds)
        
        let topInitialTransform = isDismissing ? .identity : topHiddenTransform
        topTargetTransform = isDismissing ? topHiddenTransform : .identity
        
        topView.transform = topInitialTransform
        
        //  Bottom
        let bottomHiddenTransform = transformForTranslatingViewTo(edge: effectiveTransitionEdge.opposite, outside: context.containerView.bounds)
        
        let bottomInitialTransform = isDismissing ? bottomHiddenTransform : .identity
        bottomTargetTransform = isDismissing ? .identity : bottomHiddenTransform
        
        bottomView?.transform = bottomInitialTransform
    }
    
    open override var layers: [AnimationLayer] {
        return [AnimationLayer(timingParameters: AnimationTimingParameters(animationCurve: animationCurve), animation: animate)]
    }
    
    open func animate() {
        topView?.transform = topTargetTransform
        bottomView?.transform = bottomTargetTransform
    }
    
    open override func completion(position: UIViewAnimatingPosition) {
        if position != .end && !isDismissing {
            topView?.removeFromSuperview()
        }
        bottomView?.transform = .identity
        
    }
}
