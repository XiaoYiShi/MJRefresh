//
//  MJSingleViewController.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/23.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit
import MJRefresh

@objc class MJSingleViewController: UITableViewController
{
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.mj_header = MJRefreshNormalHeader.headerWithRefreshingBlock(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self?.count += 12
                self?.tableView.reloadData()
                self?.tableView.mj_header?.endRefreshing()
            }
        })
        
        tableView.mj_header?.isAutomaticallyChangeAlpha = true
        
        let footer = MJRefreshAutoNormalFooter.footerWithRefreshingBlock { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self?.count += 5
                self?.tableView.reloadData()
                self?.tableView.mj_footer?.endRefreshing()
            }
        }
        footer.isHidden = true
        tableView.mj_footer = footer
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }

    static let ID = "cell"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: MJSingleViewController.ID)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: MJSingleViewController.ID)
        }
        if indexPath.row % 2 != 0 , self.navigationController != nil {
            cell?.textLabel?.text = "push"
        } else {
            cell?.textLabel?.text = "modal"
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = MJTestViewController()
        if self.navigationController != nil, indexPath.row % 2 != 0 {
            test.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(test, animated: true)
        } else {
            let nav = UINavigationController.init(rootViewController: test)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}

