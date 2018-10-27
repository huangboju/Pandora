# ShapeLayerDemo
# 简介
官方文档对ShapeLayer的定义如下：
>A layer that draws a cubic Bezier spline in its coordinate space.

可以理解为ShapeLayer是其坐标空间内绘有贝塞尔曲线的图层。

使用ShapeLayer可以制作蒙板和图层动画，它继承自CALayer，拥有CALayer的全部属性。ShapeLayer的依赖于贝塞尔曲线`UIBezierPath`，它决定的ShapeLayer的形状。

`StrokeStart`和`StrokeEnd`是`ShapeLayer`的重要属性，它控制`ShapeLayer`的`cgPath`路径的绘制起点和终点，区间都为0~1，0代表从头绘制，1代表绘制到终点。

# 目录
* **ShapeLayer图形动画**
* **ShapeLayer蒙版**

# 使用
## ShapeLayer图形动画
### 动画简介
使用ShapeLayer制作动画原理是通过改变ShapeLayer的strokeEnd属性值来改变ShapeLayer的path的绘制，strokeEnd值区间为0~1

下图为使用ShapeLayer制作仿今日头条下拉动画效果

<img src="http://ogdqxib8j.bkt.clouddn.com/ShapeLayerAnimation.gif" title="shapeLayer动画" width="200" height="400">

### 实现
把整个图形分成三个部分：外边框、左上角的框和所有的横线，分别用贝塞尔曲线绘制这三个部分
##### 外边框
``` objc
let draftPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 5)
```
##### 左上角边框
```
let squarePath = UIBezierPath(roundedRect: CGRect(x: margin, y: margin, width: smallSquareWH, height: smallSquareWH), cornerRadius: 2)
```
##### 所有横线
```
let linePath = UIBezierPath()       
for i in 0..<3 {
	linePath.move(to: CGPoint(x: shortLineLeft, y: margin + 2 + space * CGFloat(i)))
	linePath.addLine(to: CGPoint(x: shortLineRight, y: margin + 2 + space * CGFloat(i)))
}
for i in 0..<3 {
	linePath.move(to: CGPoint(x: margin, y: margin * 2 + 2 + smallSquareWH + space * CGFloat(i)))
	linePath.addLine(to: CGPoint(x: longLineRight, y: margin * 2 + 2 + smallSquareWH + space * CGFloat(i)))
}
```
##### 将所有贝塞尔曲线绘制到ShapeLayer中
```
self.draftShapeLayer = CAShapeLayer()
self.draftShapeLayer!.frame = CGRect(x: 0, y: 0, width: width, height: height)
setupShapeLayer(shapeLayer: self.draftShapeLayer!, path: draftPath.cgPath)
        
self.squareShapeLayer = CAShapeLayer()
self.squareShapeLayer!.frame = CGRect(x: 0, y: 0, width: smallSquareWH, height: smallSquareWH)
setupShapeLayer(shapeLayer: self.squareShapeLayer!, path: squarePath.cgPath)
        
self.lineShapeLayer = CAShapeLayer()
self.lineShapeLayer!.frame = CGRect(x: 0, y: 0, width: width, height: height)
setupShapeLayer(shapeLayer: self.lineShapeLayer!, path: linePath.cgPath)
```
这里抽出了辅助方法来设置ShapeLayer和添加到控制器图层

```
private func setupShapeLayer(shapeLayer : CAShapeLayer, path : CGPath) {
	shapeLayer.path = path
	shapeLayer.strokeColor = UIColor.gray.cgColor
	shapeLayer.fillColor = UIColor.white.cgColor
	shapeLayer.lineWidth = 2
	shapeLayer.strokeStart = 0
	shapeLayer.strokeEnd = 0
	self.containerLayer.addSublayer(shapeLayer)
}
```
##### 添加SliderView
```
private func addSlider() {
	let slider = UISlider(frame: CGRect(x: 20, y: 	UIScreen.main.bounds.height - 50, width: 	UIScreen.main.bounds.width - 40, height: 10))
	slider.minimumValue = 0
	slider.maximumValue = 1
	slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: UIControlEvents.valueChanged)
	view.addSubview(slider)
    }
```
##### sliderValuerChanged方法实现
```   
@objc private func sliderValueChanged(sender: UISlider) {
	guard let draftShapeLayer = self.draftShapeLayer else {
		return
	}guard let squareShapeLayer = self.squareShapeLayer else {
		return
	}
	guard let lineShapeLayer = self.lineShapeLayer else {
		return
	}
	draftShapeLayer.strokeEnd = CGFloat(sender.value)
	squareShapeLayer.strokeEnd = CGFloat(sender.value)
	lineShapeLayer.strokeEnd = CGFloat(sender.value)
}
```
至此，`ShapeLayer`图形动画就完成了
## ShapeLayer蒙版
用ShapeLayer创建一个带图形的蒙版如下图

<img src='http://ogdqxib8j.bkt.clouddn.com/MaskImage.png' width='200', height='400'>
### 思路
新建一个蒙版视图`View`,然后将绘有贝塞尔曲线的`ShapeLayer`设置为蒙版视图图层的`mask`
### 实现
##### 创建蒙版视图并添加到控制器视图
```
let maskView = UIView(frame: view.bounds)
maskView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
maskView.alpha = 0.8
view.addSubview(maskView)
```
##### 用贝塞尔曲线绘制蒙版的形状
``` objc
let bpath = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width: view.bounds.width - 20, height: view.bounds.height - 20), cornerRadius: 15)
let circlePath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: false)
bpath.append(circlePath)
```
##### 创建ShapeLayer，设置之前创建的贝塞尔曲线为cgPath
```
let shapeLayer = CAShapeLayer()
shapeLayer.path = bpath.cgPath
```
##### 将ShapeLayer设为蒙版
```
maskView.layer.mask = shapeLayer
```
接下来就可以运行看效果了

