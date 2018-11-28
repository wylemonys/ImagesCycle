//
//  ImagesCycleViewController.swift
//  ImagesCycle
//
//  Created by 王越 on 2018/11/22.
//  Copyright © 2018 wangyue. All rights reserved.
//

import UIKit

class ImagesCycleViewController: UIViewController {
    var images = NSMutableArray()
    private let closeBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addCloseBtn()
        prepareData()
        addImageCycleView()
        view.bringSubviewToFront(closeBtn)
        view.backgroundColor = UIColor.white
    }
    func addCloseBtn() {
        closeBtn.setTitle("X", for: UIControl.State.normal)
        closeBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        closeBtn.addTarget(self, action: #selector(close), for: UIControl.Event.touchUpInside)
        self.view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view)
            make.top.equalTo(self.view).offset(20)
            make.width.height.equalTo(30)
        }
    }
    @objc func close(){
        self.dismiss(animated: true) {
            
        }
    }
    func prepareData() {
        //建议自定义一个model，url和imageSize是必须的字段
        let imagesUrl = ["http://sjbz.fd.zol-img.com.cn/t_s1080x1920c/g5/M00/00/04/ChMkJ1fJWF2IDsjCAAjM0FherNgAAU-JQL38pUACMzo495.jpg",
                      "http://pic.sc.chinaz.com/files/pic/pic9/201706/zzpic4339.jpg",
                      "http://img.netbian.com/file/2017/0724/f6742288826c08713a1d8682ca431b15.jpg",
                      "http://www.6gdown.com/uploads/allimg/1703/ImgNCgycwJt76bdz3RDJoG9.jpg",
                      "https://desk-fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/0A/ChMkJlbKz3qIZf6CAAMnlgwlzEQAALJVgNT65cAAyeu011.jpg",
                      "http://sjbz.fd.zol-img.com.cn/t_s1080x1920c/g5/M00/00/04/ChMkJ1fJWFiIQcC6AAbv_XDb2zwAAU-JQITT5YABvAV805.jpg",
                      "http://d.5857.com/tc_170411/001.jpg",
                      "https://n.sinaimg.cn/sinacn01/160/w1080h2280/20180915/0309-hkahyhx0599054.jpg",
                      "https://n.sinaimg.cn/sinacn01/686/w1463h823/20180915/3e8b-hkahyhx0599480.jpg"
        ]
        var imagesSize = ["{1080,1920}","{650,974}","{1920,1080}","{2880,2560}","{960,600}","{1080,1920}","{1024,1024}","{1080,2280}","{1463,823}"]
        for i in 0..<imagesUrl.count{
            let item = ImagesCycleModel()
            item.imageUrl = imagesUrl[i] as NSString
            item.imageSize = NSCoder.cgSize(for: imagesSize[i])
            images.add(item)
        }
    }
    func addImageCycleView() {
        //控件初始高度为第一张图片的高度
        let model:ImagesCycleModel = images[0] as! ImagesCycleModel
        let scale = model.imageSize.height/model.imageSize.width
        let firstH = scale*SCREEN_WIDTH
        let cycleView = ImagesCycleView.createImagesCycleView(images: images, frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: firstH))
        view.addSubview(cycleView)
    }
}
