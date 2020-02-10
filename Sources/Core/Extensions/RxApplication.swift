//
//  RxApplication.swift
//  StreamChatCore
//
//  Created by Alexey Bukhtin on 06/02/2020.
//  Copyright © 2020 Stream.io Inc. All rights reserved.
//

import UIKit
import RxSwift

extension UIApplication {
    private static var rxApplicationStateKey: UInt8 = 0
    
    fileprivate var rxApplicationState: Observable<UIApplication.State> {
        associated(to: self, key: &UIApplication.rxApplicationStateKey) {
            let center = NotificationCenter.default
            
            let notifications: [Observable<UIApplication.State>] =
                [center.rx.notification(UIApplication.willEnterForegroundNotification).map({ _ in .inactive }),
                 center.rx.notification(UIApplication.didBecomeActiveNotification).map({ _ in .active }),
                 center.rx.notification(UIApplication.willResignActiveNotification).map({ _ in .inactive }),
                 center.rx.notification(UIApplication.didEnterBackgroundNotification).map({ _ in .background })]
            
            return Observable.merge(notifications)
                .subscribeOn(MainScheduler.instance)
                .startWith(UIApplication.shared.applicationState)
                .share(replay: 1, scope: .forever)
        }
    }
}

extension Reactive where Base == UIApplication {
    var applicationState: Observable<UIApplication.State> {
        base.rxApplicationState
    }
}
