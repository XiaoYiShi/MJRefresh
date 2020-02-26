//
//  MJCollectionViewController.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/23.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit
import MJRefresh


@objc class MJCollectionViewController: UICollectionViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .white
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        example()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 设置尾部控件的显示和隐藏
        self.collectionView.mj_footer?.isHidden = self.colors.count == 0
        return self.colors.count;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = self.colors[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let test = MJTestViewController()
        if (indexPath.row % 2 != 0) {
            self.navigationController?.pushViewController(test, animated: true)
        } else {
            let nav = UINavigationController.init(rootViewController: test)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    /** 存放假数据 */
    private var colors = [UIColor]()
    private func example() {
        
        // 下拉刷新
        self.collectionView.mj_header = MJRefreshNormalHeader.headerWithRefreshingBlock(refreshingBlock: { [weak self] in
            // 增加5条假数据
            for _ in 0..<10 {
                self?.colors.insert(MJRandomColor, at: 0)
            }
            
            // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+MJDuration) {
                self?.collectionView.reloadData()
                // 结束刷新
                self?.collectionView.mj_header?.endRefreshing()
            }
        })
        self.collectionView.mj_header?.beginRefreshing()
        
        // 上拉刷新
        self.collectionView.mj_footer = MJRefreshBackNormalFooter.footerWithRefreshingBlock(refreshingBlock: { [weak self] in
            // 增加5条假数据
            for _ in 0..<5 {
                self?.colors.append(MJRandomColor)
            }
            // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+MJDuration) {
                self?.collectionView.reloadData()
                // 结束刷新
                self?.collectionView.mj_footer?.endRefreshing()
            }
        })
        
        // 默认先隐藏footer
        self.collectionView.mj_footer?.isHidden = true
    }
    /**
    *  初始化
    */
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 80, height: 80)
        
        layout.sectionInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - other
private let MJDuration:Double = 2.0
/**
* 随机色
*/
private var MJRandomColor : UIColor {
    return UIColor.init(
        red: CGFloat(arc4random_uniform(255))/255.0,
        green: CGFloat(arc4random_uniform(255))/255.0,
        blue: CGFloat(arc4random_uniform(255))/255.0,
        alpha: 1
    )
}

private let reuseIdentifier = "Cell"
