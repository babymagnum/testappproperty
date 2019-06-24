//
//  PublicFunction.swift
//  Test Apps
//
//  Created by Arief Zainuri on 24/06/19.
//  Copyright © 2019 Arief Zainuri. All rights reserved.
//

import Foundation
import UIKit

class PublicFunction: NSObject {
    static let instance = PublicFunction()
    
    func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
    
    func showUnderstandDialog(_ viewController: UIViewController, _ title: String, _ message: String, _ actionTitle: String, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            completionHandler()
        }))
        viewController.present(alert, animated: true)
    }
}
