# YSMFactory-swift

* YSMPageView:多视图控制器管理。  

![YSMPageView](https://cl.ly/iNNK/Screen%20Recording%202016-12-07%20at%2002.59%20%E4%B8%8B%E5%8D%88.gif)  

> YSMPageView的使用：  

```
let pageViewFrame = CGRect(x: 0, y: kNavigationBarHeight, width: view.bounds.width, height: view.bounds.height-kNavigationBarHeight)
let titles = ["第一","第二二第三","第五","第三第三","第五","第四第第五第五","第五","第六","第四第第五第五","第五","第六"]
var childVCs = [UIViewController]()
for _ in 0..<titles.count {
let viewController = UIViewController()
viewController.view.backgroundColor = UIColor.randomColor()
childVCs.append(viewController)
}
let style = YSMPageViewStye()
let pageView = YSMPageView(frame: pageViewFrame, titles: titles, viewControllers: childVCs, parentController: self, style: style)
view.addSubview(pageView) 
```  

> 可以通过style对显示的样式进行修改   

```
//titleView的高度
var titleViewHeight:CGFloat = 44
//title的字体大小
var titleFontSize:CGFloat = 14
//title选中的颜色(RGB)
var titleSelectColor:UIColor = UIColor(hex: 0xff0000, alpha: 1)
//title的未选中颜色(RGB)
var titleNormalColor:UIColor = UIColor(hex: 0x000000, alpha: 1)
//title颜色是否渐变
var isTitleColorCrossDissolve = true
//title是否为自适应
var isTitleAutoresize:Bool = true
//title自适应时的间距（前提：isTitleAutoresize = true）
var titleMargin:CGFloat = 20

//下划线是否显示
var isBottomLineShow:Bool = true
//下划线的颜色
var bottomLineColor:UIColor = .red
//下划线的高度
var bottomLineHeight:CGFloat = 2

//contentView滚动动画是否开启
var isContentScrollAnimated:Bool = false

//titleView跟随contentView变化
var isTitleFollowAnimated:Bool = true
```

* YSMWaterFallFlowLayout :瀑布流布局  

> 主要实现数据源方法

```
//数据源
protocol YSMWaterFallLayoutDataSource : class{
//外部使用，需传入瀑布流列数
func numberOfRows(in layout:YSMFlowLayout) -> Int
//设置item的高度 (猜测可以给UICollectionViewDataSource协议进行扩展，写到扩展中,遇到扩展协议的问题)
func layout(_ layout:YSMFlowLayout, heightForRowAt indexPath: IndexPath) -> CGFloat
}
```




