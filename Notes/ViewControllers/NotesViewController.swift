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
    let fileManager = FileManager.default
    let documentDir = FileManager.documentDirectoryUrl

    var notes = [URL]() {
        didSet {
            if !notes.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                    self?.tableView.reloadData()
                }
            }
        }
    }
//    var notes = [Note]() {
//        didSet {
//            if !notes.isEmpty {
//                DispatchQueue.main.async { [weak self] in
//                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
//                    self?.tableView.reloadData()
//                }
//            }
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAndToolBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dump("NotesViewController()")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }

    @objc internal func editNotesButtonTapped() {
        dump("editNotesButtonTapped()")
    }

    @objc fileprivate func createNewFile() {
        let controller = NoteViewController()
        controller.folderName = self.title!
        navigationController?.pushViewController(controller, animated: true)
    }

    fileprivate func loadNotes() {
        let url = documentDir.appendingPathComponent(self.title!, isDirectory: true)

        do {
            notes = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch {
            alertWithOKButton(title: "Failed to Get File List", message: error.localizedDescription)
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
        let url = notes[indexPath.row].appendingPathExtension("txt")
        controller.note = url
        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .clear
            cell.textLabel?.text = note.deletingPathExtension().lastPathComponent
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return cell
    }
}
