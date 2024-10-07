//
//  ViewController.swift
//  HW23
//
//  Created by Максим Громов on 01.09.2024.
//

import UIKit

class ViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = MainViewController()
        viewControllers.append(vc)
    }
    
    
}

#Preview{
    ViewController()
}
