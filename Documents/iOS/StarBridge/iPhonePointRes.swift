//
//  iPhonePointRes.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-08.
//  Return iPhone's point resolution.

import SwiftUI

enum iPhonePointRes: String {
    case iPhoneSE_2ndGen = "iPhone SE (2nd generation)", iPhoneSE_3rdGen = "iPhone SE (3rd generation)"
    case iPhone6s = "iPhone 6s", iPhone6sPlus = "iPhone 6s Plus"
    case iPhone7 = "iPhone 7", iPhone7Plus = "iPhone 7 Plus"
    case iPhone8 = "iPhone 8", iPhone8Plus = "iPhone 8 Plus"
    case iPhoneX = "iPhone X", iPhoneXS = "iPhone Xs", iPhoneXSMax = "iPhone Xs Max"
    case iPhone11 = "iPhone 11", iPhone11Pro = "iPhone 11 Pro", iPhone11ProMax = "iPhone 11 Pro Max", iPhoneXR = "iPhone Xr"
    case iPhone12 = "iPhone 12", iPhone12Mini = "iPhone 12 mini", iPhone12Pro = "iPhone 12 Pro", iPhone12ProMax = "iPhone 12 Pro Max"
    case iPhone13 = "iPhone 13", iPhone13Mini = "iPhone 13 mini", iPhone13Pro = "iPhone 13 Pro", iPhone13ProMax = "iPhone 13 Pro Max"
    case iPhone14 = "iPhone 14", iPhone14Plus = "iPhone 14 Plus", iPhone14Pro = "iPhone 14 Pro", iPhone14ProMax = "iPhone 14 Pro Max"
    case iPhone15 = "iPhone 15", iPhone15Plus = "iPhone 15 Plus", iPhone15Pro = "iPhone 15 Pro", iPhone15ProMax = "iPhone 15 Pro Max"
    

    static func currentDeviceWidth() -> CGFloat? {
        let deviceName = UIDevice.current.name
        guard let model = iPhonePointRes(rawValue: deviceName) else{
            return nil
        }
        return model.width
    }
    
    static func currentDeviceHeight() -> CGFloat? {
        let deviceName = UIDevice.current.name
        guard let model = iPhonePointRes(rawValue: deviceName) else{
            return nil
        }
        return model.height
    }
    
    static func currentDevicePortraitSafeArea() -> UIEdgeInsets?{
        let deviceName = UIDevice.current.name
        guard let model = iPhonePointRes(rawValue: deviceName) else{
            return nil
        }
        return model.portraitSafeArea
    }
    
    static func currentDeviceLandscapeSafeArea() -> UIEdgeInsets?{
        let deviceName = UIDevice.current.name
        guard let model = iPhonePointRes(rawValue: deviceName) else{
            return nil
        }
        return model.landscapeSafeArea
    }
    
    var width: CGFloat {
        switch self {
            case .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE_2ndGen, .iPhoneSE_3rdGen:
                return 375
            case .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
                return 414
            case .iPhoneX, .iPhoneXS, .iPhone11Pro:
                return 375
            case .iPhoneXSMax, .iPhone11ProMax, .iPhoneXR, .iPhone11:
                return 414
            case .iPhone12Mini, .iPhone13Mini:
                return 375
            case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14:
                return 390
            case .iPhone12ProMax, .iPhone13ProMax:
                return 428
            case .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15Plus, .iPhone15ProMax:
                return 430
            case .iPhone15, .iPhone15Pro:
                return 393
        }
    }
    
    var height: CGFloat {
        switch self {
            case .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE_2ndGen, .iPhoneSE_3rdGen:
                return 667
            case .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
                return 736
            case .iPhoneX, .iPhoneXS, .iPhone11Pro:
                return 812
            case .iPhoneXSMax, .iPhone11ProMax, .iPhoneXR, .iPhone11:
                return 896
            case .iPhone12Mini, .iPhone13Mini:
                return 812
            case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14:
                return 844
            case .iPhone12ProMax, .iPhone13ProMax:
                return 926
            case .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax, .iPhone15Plus, .iPhone15ProMax:
                return 932
            case .iPhone15, .iPhone15Pro:
                return 852
        }
    }
    
    var portraitSafeArea: UIEdgeInsets {
        switch self {
            case .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE_2ndGen, .iPhoneSE_3rdGen,
                 .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
                return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
                
            case .iPhoneX, .iPhoneXS, .iPhone11Pro,
                 .iPhoneXSMax, .iPhone11ProMax, .iPhoneXR, .iPhone11,
                 .iPhone12Mini, .iPhone13Mini:
                return UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
                
            case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14,
                 .iPhone12ProMax, .iPhone13ProMax:
                return UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0)
                
            case .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax,
                 .iPhone15, .iPhone15Pro, .iPhone15Plus, .iPhone15ProMax:
                return UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0)
        }
    }
    
    var landscapeSafeArea: UIEdgeInsets{
        switch self {
           case .iPhone6s, .iPhone7, .iPhone8, .iPhoneSE_2ndGen, .iPhoneSE_3rdGen,
                .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
               return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
               
           case .iPhoneX, .iPhoneXS, .iPhone11Pro,
                .iPhoneXSMax, .iPhone11ProMax, .iPhoneXR, .iPhone11,
                .iPhone12Mini, .iPhone13Mini:
               return UIEdgeInsets(top: 0, left: 44, bottom: 21, right: 44)
               
           case .iPhone12, .iPhone12Pro, .iPhone13, .iPhone13Pro, .iPhone14,
                .iPhone12ProMax, .iPhone13ProMax:
               return UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47)
               
           case .iPhone14Plus, .iPhone14Pro, .iPhone14ProMax,
                .iPhone15, .iPhone15Pro, .iPhone15Plus, .iPhone15ProMax:
               return UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59)
           }
    }
}

