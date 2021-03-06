//
//  ViewController.swift
//  01-掌握 - iOS8.0之前的定位
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

// 在swift 里面遵守协议, 是使用 逗号 ","
class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: 懒加载位置管理者
    lazy var locationM : CLLocationManager = {

        /// 1. 创建位置管理者
        let tempLocationM = CLLocationManager()

        /// 2. 设置代理
        tempLocationM.delegate = self


        /// 3. 额外设置
        // 3.1 如果针对于导航应用, 需要每隔多远更新一次用户位置, 可以通过设置特定属性来实现
        // 代表每隔100米获取一次用户的位置信息, 并通过代理告诉外界
//        tempLocationM.distanceFilter = 100


        // 3.2 设置定位的精确度
        // 精确度越高, 获取到得位置精准度越高, 但是越耗电, 定位时间越长
//         kCLLocationAccuracyBestForNavigation  最适合导航
//         kCLLocationAccuracyBest;  最好的
//         kCLLocationAccuracyNearestTenMeters; 附近10米
//         kCLLocationAccuracyHundredMeters; 附近100米
//         kCLLocationAccuracyKilometer;  附近1000 米
//         kCLLocationAccuracyThreeKilometers; 附近3000米
        tempLocationM.desiredAccuracy = kCLLocationAccuracyBest


        // 4. 后台定位
        // 在iOS8.0之前, 只需要勾选后台模式就可以
        // target -> Capabilities -> 开启Background Modes -> 勾选 location updates





        /************************iOS8.0之后定位适配*****************************/

        if Float(UIDevice.currentDevice().systemVersion) >= 8.0
        {
            // 需要主动请求授权
            // 请求前台定位授权, 默认情况下, 只能在前台获取到用户位置信息
            // 注意: 一定不要忘记在info.plist文件里面配置对应的key
            // 如果在前台授权模式下, 想要在后台也获取用户位置信息, 必须勾选后台模式 location updates, 但是此时如果APP 退到后台, 在屏幕顶部会出现一个蓝条
//            tempLocationM .requestWhenInUseAuthorization()

            // 请求前后台定位授权, 默认情况下, 无论在前台, 还是后台, 都可以获取用户位置信息, 而且不需要勾选后台模式location updates. 并且不会出现蓝条
             // 注意: 一定不要忘记在info.plist文件里面配置对应的key
            tempLocationM.requestAlwaysAuthorization()


        }




        return tempLocationM
    }()


    /// 重写系统touchesBegan方法
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {


        /// 3. 调用方法, 开始更新用户位置信息
        locationM.startUpdatingLocation()


    }


    // MARK: CLLocationManagerDelegate 代理方法

    /// 1. 获取到用户位置之后调用
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)

        // 场景1: 如果只需要获取一次用户位置, 那么在此处获取到位置之后, 可以停止更新用户位置
//        manager.stopUpdatingLocation()


        // 场景2: 如果针对于导航应用, 需要每隔多远更新一次用户位置, 可以通过设置特定属性来实现(见懒加载方法内部)


    }


    /// 2. 授权状态发生变化时调用
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status
        {
            case CLAuthorizationStatus.NotDetermined:
                print("用户还没有决定")

            case CLAuthorizationStatus.Restricted:
                print("受限制")

            case CLAuthorizationStatus.Denied:
                if CLLocationManager.locationServicesEnabled()
                {
                    print("被拒绝")
                    // 一般在此处, 提醒用户授权状态, 并弹框提供快捷跳转到设置界面的方式
                    // 跳转到设置界面的核心代码

                    // iOS 8.0 之后
                    let url:NSURL = NSURL(string: UIApplicationOpenSettingsURLString)!
                    if UIApplication.sharedApplication().canOpenURL(url)
                    {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                 else
                {
                    print("定位服务关闭")
                    // 当定位服务关闭时, 系统会自动弹出一个对话框, 让用户跳转到"设置"界面, 开启定位服务, 不需要我们处理
                }

            case CLAuthorizationStatus.AuthorizedWhenInUse:
                print("前台定位授权")

            case CLAuthorizationStatus.AuthorizedAlways:
                print("前后台定位授权")

        }

    }


}

