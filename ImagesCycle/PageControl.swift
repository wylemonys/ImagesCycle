//
//  PageControl.swift
//  ImagesCycle
//
//  Created by 王越 on 2018/11/23.
//  Copyright © 2018 wangyue. All rights reserved.
//

import UIKit

class PageControl: UIView {
    var self_w = Double()
    var count = Int()
    let line_w = 20.0
    let line_h = 4.0
    let pageView_h = 10.0
    let line_margin = 5.0
    let currentLine_w = 50.0
    var lineBegin_x = Double()
    var selectColor = UIColor()
    class func createPageControl(count:Int,width:Double) -> PageControl{
        let pageControl = PageControl()
        pageControl.self_w = width
        pageControl.count = count
        pageControl.pageViewInit()
        return pageControl
    }
    func pageViewInit(){
        selectColor = UIColor(red: 240.0/255.0, green: 1, blue: 0, alpha: 1)
        //计算起始点位置
        lineBegin_x = (self_w-(line_w+line_margin)*Double(count-1)-currentLine_w)/2.0
        for i in 0..<count {
            let shapeLayer = CAShapeLayer(layer: layer)
            let path = UIBezierPath()
            var moveX = Double()
            var addX = Double()
            var y = Double()
            //第一个位置
            if (i == 0){
                moveX = lineBegin_x
                addX = lineBegin_x + currentLine_w
            }else {
                moveX = lineBegin_x + Double(i-1)*(line_w+line_margin)+currentLine_w+line_margin
                addX = moveX+line_w
            }
            y = (pageView_h-line_h)/2.0
            path.move(to: CGPoint(x: moveX, y: y))
            path.addLine(to: CGPoint(x: addX, y: y))
            path.close()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.white.cgColor
            if i==0{
                shapeLayer.strokeColor = selectColor.cgColor
            }
            shapeLayer.lineWidth = CGFloat(line_h)
            self.layer.addSublayer(shapeLayer)
        }
    }
    func updatePageViewLinePosition(offsetX:Double){
        let pageNum = Int(offsetX/self_w)
        let changeX = offsetX - Double(pageNum)*self_w
        let layers = self.layer.sublayers
        for i in 0..<Int(layers!.count) {
            let shapeLayer = layers![i] as! CAShapeLayer
            let path = UIBezierPath()
            var moveX = Double()
            var addX = Double()
            var y = Double()
            if(i==pageNum){
                moveX = lineBegin_x+Double(i)*(line_w+line_margin)
                //计算滚动偏移
                addX = moveX-(currentLine_w-line_w)*changeX/self_w+currentLine_w
            }else if(i<pageNum){
                //当前位置之前的线段
                moveX = lineBegin_x+Double(i)*(line_w+line_margin)
                addX = moveX+line_w
            }else{
                //当前位置后一个线段
                if(i==pageNum+1){
                    moveX = lineBegin_x+Double(i-1)*(line_w+line_margin)+currentLine_w+line_margin-(currentLine_w-line_w)*changeX/self_w
                    addX = moveX+line_w+(currentLine_w-line_w)*changeX/self_w
                }else{
                    moveX = lineBegin_x+Double(i-1)*(line_w+line_margin)+currentLine_w+line_margin
                    addX = moveX+line_w
                }
            }
            y = (pageView_h-line_h)/2.0
            path.move(to: CGPoint(x: moveX, y: y))
            path.addLine(to: CGPoint(x: addX, y: y))
            path.close()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.white.cgColor
            if i==pageNum{
                shapeLayer.strokeColor = selectColor.cgColor
            }
        }
    }
}
