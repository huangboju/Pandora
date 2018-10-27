# JMWaterFlow
#####JMWaterFlow 使用 *Swift* 语言 对常见的 瀑布流 布局做了封装。 它使用UICollectionView来布局瀑布流，通过自定义layout布局来实现，简单易用。 

* 可自定义布局参数:


![JMWaterFlow.png](http://upload-images.jianshu.io/upload_images/1115674-641c59c78a8bbb6d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####使用方式
  
 * 构造方法
  
``` objective-c
     let layout = WaterFlowViewLayout()
    //构造方法
    init()
    {
        super.init(collectionViewLayout: layout)
    } 
```

 * 初始化
 
``` objective-c
        let Margin:CGFloat = 8;
        /// 瀑布流四周的间距
        layout.sectionInsert = UIEdgeInsets(top: Margin, left: Margin, bottom: Margin, right: Margin)
        /// 瀑布流列数
        layout.column = 5
        /// 列间距
        layout.columnMargin = Margin
        /// 行间距
        layout.rowMargin = Margin
        // 设置代理
        layout.delegate = self        
```

 *  实现代理
 
```objective-c
//MARK: 代理方法
    /// 返回每个cell的高度,需要heightForWidth等比例缩放后的
    func waterFlowViewLayout(waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, atIndexPath: NSIndexPath) -> CGFloat
    {
        return CGFloat(100 + arc4random_uniform(50))//测试使用随机值
    }
    ///返回cell的数量
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 500//测试
    }
    //返回cell
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.randomColor()//测试使用随机色
        return cell
    }
```

---
####个人中文博客 ┑(￣Д ￣)┍
<http://www.jianshu.com/users/53845c6b43dc/top_articles>