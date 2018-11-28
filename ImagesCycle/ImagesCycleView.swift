//
//  ImagesCycleView.swift
//  ImagesCycle
//
//  Created by 王越 on 2018/11/22.
//  Copyright © 2018 wangyue. All rights reserved.
//

import UIKit

class ImagesCycleView: UIView,UIScrollViewDelegate {
    let scrollView = UIScrollView()
    var pageView = PageControl()
    var imagesArray = NSMutableArray()
    var self_w = CGFloat()
    var self_h = CGFloat()
    
    class func createImagesCycleView(images:NSArray,frame:CGRect) -> ImagesCycleView {
        let imagesCycleView = ImagesCycleView(frame: frame)
        imagesCycleView.imagesArray.addObjects(from: images as! [Any])
        imagesCycleView.self_w = frame.size.width
        imagesCycleView.self_h = frame.size.height
        imagesCycleView.conmmonInit()
        return imagesCycleView
    }
    
    func conmmonInit() {
        scrollViewInit()
        imagesInit()
        pageViewInit()
    }
    func scrollViewInit(){
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: (self_w * CGFloat(imagesArray.count)), height: self_h)
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self);
        }
    }
    func imagesInit() {
        for i in 0..<imagesArray.count {
            let model:ImagesCycleModel = imagesArray[i] as! ImagesCycleModel
            let targetHeight = CGFloat(model.imageSize.height*self_w/model.imageSize.width)
            let imageView = UIImageView(frame: CGRect(x: 0+CGFloat(i)*self_w, y: 0, width: self_w, height: targetHeight))
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = getRandomColor()
            scrollView.addSubview(imageView)
            //异步下载并展示图片
            DispatchQueue.global().async {
                let url = NSURL(string: model.imageUrl as String)
                let data = NSData(contentsOf: url! as URL)
                DispatchQueue.main.sync {
                    if data != nil{
                        imageView.image = UIImage(data: data! as Data)
                    }
                }
            }
        }
    }
    func pageViewInit() {
        pageView = PageControl.createPageControl(count: imagesArray.count, width: Double(self_w))
        self.addSubview(pageView)
        pageView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(10.0)
        }
    }
    func getRandomColor() -> UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //计算当前第几张图片
        let imageNum = Int(scrollView.contentOffset.x/self_w);
        //计算当前滑动偏移量
        let changeX = scrollView.contentOffset.x - CGFloat(imageNum)*self_w;
        let model:ImagesCycleModel = imagesArray[imageNum] as! ImagesCycleModel
        //当前图片高度
        let currentHeight = model.imageSize.height/model.imageSize.width*self_w
        var rightHeight = CGFloat()
        let currentImageView = scrollView.subviews[imageNum]
        var rightImageView = UIView()
        /*
            当前图片不是最后一张图片时右侧图片的高度和右侧图片所在的imageView，无论现在是左滑还是右滑，当前图片的右侧都是后一张图片，当前图片是最后一张的时候，右侧图片就是它本身
         */
        if imageNum < imagesArray.count-1 {
            let rightModel:ImagesCycleModel = imagesArray[imageNum+1] as! ImagesCycleModel
            rightHeight = rightModel.imageSize.height/rightModel.imageSize.width*self_w
            rightImageView = scrollView.subviews[imageNum+1]
        }else {
            rightHeight = currentHeight
            rightImageView = currentImageView
        }
        //当前图片展示的高度，此时当前图片和右侧图片都是同样高度，使用changeX/self_w计算出偏移比例乘以(rightHeight - currentHeight)即可以计算出当前增加或者减少的高度，再加上currentHeight计算得出viewHeight
        let viewHeight = (rightHeight - currentHeight)*changeX/self_w + currentHeight
        scrollView.contentSize = CGSize(width: self_w*CGFloat(imagesArray.count), height: viewHeight)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: viewHeight)
        currentImageView.frame = CGRect(x: currentImageView.frame.origin.x, y: currentImageView.frame.origin.y, width: self_w, height: viewHeight)
        rightImageView.frame = CGRect(x: rightImageView.frame.origin.x, y: rightImageView.frame.origin.y, width: self_w, height: viewHeight)
        
        pageView.updatePageViewLinePosition(offsetX: Double(scrollView.contentOffset.x))
    }
}
