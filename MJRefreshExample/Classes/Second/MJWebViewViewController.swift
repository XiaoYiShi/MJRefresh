//
//  MJWebViewViewController.swift
//  MJRefreshExample
//
//  Created by 史晓义 on 2020/2/20.
//  Copyright © 2020 小码哥. All rights reserved.
//

import UIKit
import MJRefresh

@objc class MJWebViewViewController: UIViewController
{
    
    private lazy var webView: UIWebView = {
        let web = UIWebView()
        web.frame = .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        web.delegate = self
        return web
    }()
    
    private lazy var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(back(_:)), for: .touchUpInside)
        btn.setTitle("回到上一页", for: .normal)
        btn.backgroundColor = .red
        btn.frame = .init(x: 30, y: 200, width: 200, height: 50)
        return btn
    }()
    @objc func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(backBtn)
        
        // 添加下拉刷新控件
        self.webView.scrollView.mj_header = MJRefreshNormalHeader.headerWithRefreshingBlock(refreshingBlock: {
            self.webView.reload()
        })
        
        // 如果是上拉刷新，就以此类推
        
        // 加载页面
        self.webView.loadRequest(URLRequest.init(url: URL.init(string: "http://weibo.com/exceptions")!))
        backBtn.backgroundColor = .red
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension MJWebViewViewController:UIWebViewDelegate
{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.mj_header?.endRefreshing()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.webView.scrollView.mj_header?.endRefreshing()
    }
}
