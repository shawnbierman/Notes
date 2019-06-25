//
//  FoldersViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class FoldersViewController: BaseTableViewController {

    let defaults = UserDefaults.standard
    let fileManager = FileManager.default
    let documentDir = FileManager.documentDirectoryUrl

    var dialog: UIAlertController?

    var folders = [URL]() {
        didSet {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = !self.folders.isEmpty
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Folders"

        setupNavigationAndToolBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFolders()
    }

    fileprivate func loadFolders() {
        print("loading folders...")
        do {
            folders = try fileManager.contentsOfDirectory(at: documentDir, includingPropertiesForKeys: nil)
        } catch {
            alertWithOKButton(title: "Failure", message: error.localizedDescription)
        }
    }

    fileprivate func saveFolder(withString path: String) {
        let folder = documentDir.appendingPathComponent(path, isDirectory: true)

        do {
            try fileManager.createDirectory(at: folder, withIntermediateDirectories: false)
            folders.append(folder)
        } catch {
            alertWithOKButton(title: "Name Taken", message: error.localizedDescription)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: true)
    }

    @objc internal func addFolderButtonTapped() {

        dialog = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        dialog?.addTextField { [weak self] (textfield) in
            textfield.placeholder = "Name"
            textfield.autocapitalizationType = .sentences
            textfield.tintColor = .gold
            textfield.autocapitalizationType = .words
            textfield.addTarget(self, action: #selector(self?.alertTextFieldDidChange(_:)), for: .editingChanged)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak dialog] (_) in

            let folder = dialog?.textFields?[0].text ?? "unknown"
            self?.saveFolder(withString: folder)

        })

            cancel.setValue(UIColor.gold, forKey: "titleTextColor")
            save.setValue(UIColor.gold, forKey: "titleTextColor")
            save.isEnabled = false

        dialog?.addAction(cancel)
        dialog?.addAction(save)

        present(dialog!, animated: true)
    }

    // enable/disable Save button depending on content
    @objc internal func alertTextFieldDidChange(_ sender: UITextField) {
        dialog?.actions[1].isEnabled = !sender.text!.isEmpty
    }

    fileprivate func setupNavigationAndToolBar() {
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = .gold
        navigationItem.rightBarButtonItem?.style = UIBarButtonItem.Style.done
        navigationItem.rightBarButtonItem?.isEnabled = false

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let folderBtn = UIBarButtonItem(title: "New Folder", style: .done, target: self, action: #selector(addFolderButtonTapped))
            folderBtn.tintColor = .gold

        toolbarItems = [spacer, folderBtn]
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

extension FoldersViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NotesViewController()
        controller.title = folders[indexPath.row].lastPathComponent
        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let folder = folders[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .clear
            cell.textLabel?.text = folder.lastPathComponent
            cell.detailTextLabel?.text = "0"
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folderToDelete = folders[indexPath.row]

            do {
                try fileManager.removeItem(at: folderToDelete)
                folders.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

                if folders.isEmpty && isEditing {
                    setEditing(false, animated: true)
                }
            } catch {
                alertWithOKButton(title: "Error Removing Folder", message: error.localizedDescription)
            }
        }
    }
}
