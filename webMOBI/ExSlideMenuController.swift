//
//  ExSlideMenuController.swift
//  SlideMenuControllerSwift
//
//   Created by Webmobi on 2016/04/06.
//  Copyright © 2016 Webmobi. All rights reserved.
//

import UIKit

class ExSlideMenuController : SlideMenuController {

    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is MainViewController  ||
                vc is NewAgendaViewController
            {
                return true
            }
        }
        return false
    }
    
    override func track(_ trackAction: TrackAction) {
//        switch trackAction {
//        case .LeftTapOpen:
//            print("TrackAction: left tap open.")
//        case .LeftTapClose:
//            print("TrackAction: left tap close.")
//        case .LeftFlickOpen:
//            print("TrackAction: left flick open.")
//        case .LeftFlickClose:
//            print("TrackAction: left flick close.")
//        case .RightTapOpen:
//            print("TrackAction: right tap open.")
//        case .RightTapClose:
//            print("TrackAction: right tap close.")
//        case .RightFlickOpen:
//            print("TrackAction: right flick open.")
//        case .RightFlickClose:
//            print("TrackAction: right flick close.")
//        }
    }
}
