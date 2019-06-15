//
//  BaseTableViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavivationItems()
    }

    fileprivate func setupTableView() {
        let tableViewBackground = UIImageView(image: UIImage(named: "wallpaper"))
        tableView.backgroundView = tableViewBackground
    }

    fileprivate func setupNavivationItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .gold

        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    public func alertWithOKButton(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            ok.setValue(UIColor.gold, forKey: "titleTextColor")

        ac.addAction(ok)

        present(ac, animated: true)
    }
}
