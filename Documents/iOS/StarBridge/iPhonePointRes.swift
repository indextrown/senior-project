//
//  iPhonePointRes.swift
//  StarBridge
//
//  Created by 최윤진 on 2024-08-08.
//  Return iPhone's point resolution.

import SwiftUI
import UIKit


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
        guard let model = iPhonePointRes.currentDeviceModel() else {
            return nil
        }
        return model.width
    }
    
    static func currentDeviceHeight() -> CGFloat? {
        guard let model = iPhonePointRes.currentDeviceModel() else {
            return nil
        }
        return model.height
    }
    
    static func currentDevicePortraitSafeArea() -> UIEdgeInsets? {
        guard let model = iPhonePointRes.currentDeviceModel() else {
            return nil
        }
        return model.portraitSafeArea
    }
    
    static func currentDeviceLandscapeSafeArea() -> UIEdgeInsets? {
        guard let model = iPhonePointRes.currentDeviceModel() else {
            return nil
        }
        return model.landscapeSafeArea
    }
    
    static func currentDeviceModel() -> iPhonePointRes? {
        let identifier = getDeviceIdentifier()
        return iPhonePointRes(identifier: identifier)
    }
    
    private static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    static func stdRatio(model: String = "iPhone Xs Max") -> CGFloat {
        if let currentDeviceWidth = iPhonePointRes.currentDeviceWidth(),
           let targetModel = iPhonePointRes(rawValue: model) {
            return currentDeviceWidth / targetModel.width
        }
        return 0
    }

    private init?(identifier: String) {
        switch identifier {
        case "iPhone8,4": self = .iPhoneSE_2ndGen
        case "iPhone12,8": self = .iPhoneSE_3rdGen
        case "iPhone8,1": self = .iPhone6s
        case "iPhone8,2": self = .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": self = .iPhone7
        case "iPhone9,2", "iPhone9,4": self = .iPhone7Plus
        case "iPhone10,1", "iPhone10,4": self = .iPhone8
        case "iPhone10,2", "iPhone10,5": self = .iPhone8Plus
        case "iPhone10,3", "iPhone10,6": self = .iPhoneX
        case "iPhone11,2": self = .iPhoneXS
        case "iPhone11,4", "iPhone11,6": self = .iPhoneXSMax
        case "iPhone11,8": self = .iPhoneXR
        case "iPhone12,1": self = .iPhone11
        case "iPhone12,3": self = .iPhone11Pro
        case "iPhone12,5": self = .iPhone11ProMax
        case "iPhone13,1": self = .iPhone12Mini
        case "iPhone13,2": self = .iPhone12
        case "iPhone13,3": self = .iPhone12Pro
        case "iPhone13,4": self = .iPhone12ProMax
        case "iPhone14,4": self = .iPhone13Mini
        case "iPhone14,5": self = .iPhone13
        case "iPhone14,2": self = .iPhone13Pro
        case "iPhone14,3": self = .iPhone13ProMax
        case "iPhone14,7": self = .iPhone14
        case "iPhone14,8": self = .iPhone14Plus
        case "iPhone15,2": self = .iPhone14Pro
        case "iPhone15,3": self = .iPhone14ProMax
        case "iPhone15,4": self = .iPhone15
        case "iPhone15,5": self = .iPhone15Plus
        case "iPhone15,6": self = .iPhone15Pro
        case "iPhone15,7": self = .iPhone15ProMax
        default: return nil
        }
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
    
    var landscapeSafeArea: UIEdgeInsets {
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


