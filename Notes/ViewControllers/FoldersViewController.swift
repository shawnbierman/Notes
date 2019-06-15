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
    let kNotesFolderKey = "folders"
    var dialog: UIAlertController?

    var folders = [Folder]() {
        didSet {
            DispatchQueue.main.async {
                if !self.folders.isEmpty {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Folders"

        setupNavigationAndToolBar()
        loadFolders()
    }

    fileprivate func loadFolders() {
        if let savedData = defaults.object(forKey: kNotesFolderKey) as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                folders = try jsonDecoder.decode([Folder].self, from: savedData)
            } catch {
                alertWithOKButton(title: "Failure", message: "Failed to load folders.")
            }
        }
    }

    fileprivate func saveFolders(with name: String? = nil) {

        // save folder to array, but make sure folder.name does not already exist.
        if let name = name {
            let id = UUID().uuidString

            if !self.folders.contains(where: { ($0.name == name) }) {
                self.folders.append(Folder(id: id, name: name, notes: nil))
            } else {
                alertWithOKButton(title: "Name Taken", message: "Please choose a different name.")
            }
        }

        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(folders) {
            defaults.set(savedData, forKey: kNotesFolderKey)
        } else {
            alertWithOKButton(title: "Failure", message: "Failed to save folders.")
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        dump("setting \(editing)")
        tableView.setEditing(editing, animated: true)
    }

    @objc internal func addFolderButtonTapped() {

        dialog = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        dialog?.addTextField { [weak self] (textfield) in
            textfield.placeholder = "Name"
            textfield.autocapitalizationType = .sentences
            textfield.tintColor = .gold
            textfield.addTarget(self, action: #selector(self?.alertTextFieldDidChange(_:)), for: .editingChanged)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default, handler: { [weak self, weak dialog] (_) in

            let folder = dialog?.textFields?[0].text ?? "unknown"
            self?.saveFolders(with: folder)

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

    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return folders.count }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = NotesViewController()
        controller.title = folders[indexPath.row].name
        navigationController?.pushViewController(controller, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let folder = folders[indexPath.row]
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = .clear
            cell.textLabel?.text = folder.name
            cell.detailTextLabel?.text = "0"
            cell.textLabel?.font = UIFont(name: "Heiti TC", size: 22)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            folders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveFolders()
            if folders.isEmpty && isEditing { setEditing(false, animated: true)}
        }
    }
}
