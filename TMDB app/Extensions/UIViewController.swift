//
//  UIViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 08.01.2023.

//MARK: - Frameworks
import UIKit

//MARK: - UIViewController
extension UIViewController{
    //MARK: - UIAlertController
    func alertMessage(alertTitle: String, alertMesssage: String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMesssage, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
}
