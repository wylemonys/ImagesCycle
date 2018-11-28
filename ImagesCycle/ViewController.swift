//
//  ViewController.swift
//  ImagesCycle
//
//  Created by 王越 on 2018/11/22.
//  Copyright © 2018 wangyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        let startButton = UIButton()
        startButton.backgroundColor = UIColor.orange
        startButton.setTitle("start", for: UIControl.State.normal)
        startButton.addTarget(self,action: #selector(ViewController.showImagesCycle), for: UIControl.Event.touchUpInside)
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }
    
    @objc func showImagesCycle(){
        let imagesCycleVC = ImagesCycleViewController()
        self.present(imagesCycleVC, animated: true) {
            
        }
    }

}

