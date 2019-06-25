//
//  NotesViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class NotesViewController: BaseTableViewController {

    let defaults = UserDefaults.standard
    let kNotesKey = "note"

    var notes = [Note]() {
        didSet {
            if !notes.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAndToolBar()
        loadNotes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dump("NotesViewController()")
    }

    @objc internal func editNotesButtonTapped() {
        dump("editNotesButtonTapped()")
    }

    @objc fileprivate func createNewFile() {
        let controller = NoteViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    fileprivate func loadNotes() {
        if let savedData = defaults.object(forKey: kNotesKey) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedData)
            } catch {
                dump(error.localizedDescription)
                dumpUserDefaults()
            }
        }
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

extension NotesViewController {

    func dumpUserDefaults() {
        var defaultsDict = [String: Any]()
        let defaults = UserDefaults.standard

        defaults.dictionaryRepresentation().forEach { (key, value) in
            defaultsDict[key] = value
        }

        var tmpArray = [String]()
        for def in defaultsDict {
            tmpArray.append("\(def.key): \(def.value)")
        }

        tmpArray.sort()
        tmpArray.forEach { dump($0) }
    }

}
