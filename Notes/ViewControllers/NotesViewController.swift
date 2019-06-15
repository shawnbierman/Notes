//
//  NotesViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class NotesViewController: BaseTableViewController {

    var notes = [Note]() {
        didSet {
            if !notes.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAndToolBar()
    }

    @objc internal func editNotesButtonTapped() {
        dump("editNotesButtonTapped()")
    }

    @objc fileprivate func createNewFile() {
        let controller = NoteViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc fileprivate func showNotesAttachments() {
        dump("showNotesAttachments()")
    }

    fileprivate func setupNavigationAndToolBar() {

        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.style = UIBarButtonItem.Style.done
        navigationItem.rightBarButtonItem?.isEnabled = false

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let attach = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showNotesAttachments))
            attach.tintColor = .gold
        let count = UIBarButtonItem(title: "0 Notes", style: .done, target: self, action: nil)
            count.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                                          NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        let editBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewFile))
            editBtn.tintColor = .gold

        toolbarItems = [attach, spacer, count, spacer, editBtn]
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

/// MARK - Table view delegate/datasource methods
extension NotesViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NoteViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
