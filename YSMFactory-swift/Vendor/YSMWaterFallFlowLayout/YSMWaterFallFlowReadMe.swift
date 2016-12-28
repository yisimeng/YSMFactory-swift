//
//  YSMWaterFallFlowReadMe.swift
//  YSMFactory-swift
//
//  Created by 忆思梦 on 2016/12/8.
//  Copyright © 2016年 忆思梦. All rights reserved.
//

/*  瀑布流布局快速使用
 class ViewController: UIViewController {
 
     //item的信息（现在为每个item的高度）
     var modelArray:[CGFloat] = [CGFloat]()
     
     var collectionView:UICollectionView!
     
     override func viewDidLoad() {
     super.viewDidLoad()
         automaticallyAdjustsScrollViewInsets = false
         
         let flowLayout = YSMFlowLayout()
         //最小的行间距
         flowLayout.minimumLineSpacing = 10
         //最小的列间距
         flowLayout.minimumInteritemSpacing = 10
         //内边距
         flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         //设置数据源
         flowLayout.dataSource = self
         
         collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: flowLayout)
         collectionView.dataSource = self
         collectionView.backgroundColor = .white
         collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCellId")
         view.addSubview(collectionView)
         
         let blackView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
         blackView.backgroundColor = .black
         view.addSubview(blackView)
         
         let tap = UITapGestureRecognizer(target: self, action: #selector(tapg))
         blackView.addGestureRecognizer(tap)
 
         loadData()
     }
 
     func loadData() {
         for _ in 0...4 {
             let num = CGFloat(arc4random_uniform(200)+50)
             modelArray.append(num)
         }
         collectionView.reloadData()
     }
 
     func tapg() {
         loadData()
     }
 }
 
 extension ViewController:UICollectionViewDataSource {
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 2
     }
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return modelArray.count
     }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCellId", for: indexPath)
         cell.backgroundColor = UIColor.randomColor()
         return cell
     }
 
 }
 
 extension ViewController : YSMWaterFallLayoutDataSource{
     //返回列数
     func numberOfRows(in layout: YSMFlowLayout) -> Int {
         return 2
     }
     //获取每个item的高度
     func layout(_ layout: YSMFlowLayout, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return modelArray[indexPath.row]
     }
 }
 
 
 */
