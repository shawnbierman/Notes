//
//  NoteViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    let defaults = UserDefaults.standard
    let kNoteKey = "note"
    let fileManager = FileManager.default
    let documentDir = FileManager.documentDirectoryUrl

    var note: URL?
    var folderName: String?

    let backgroundView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "wallpaper")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let textview: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.preferredFont(forTextStyle: .body)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        setupViews()
        setupNavigationAndToolBar()
        textview.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        textview.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNote()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
    }

    @objc fileprivate func handleActionButton() {
        dump("handleActionButton()")
    }

    @objc fileprivate func handleDoneButton() {
        // should dim 'done' button,
        // then resign first responder,
        // but should NOT popViewController.
        // that's not how native app behaves
        // TODO: - Fix this
        navigationController?.popViewController(animated: true)
    }

    fileprivate func loadNote() {
        guard let note = note else { return }
        print("loading note")
        textview.text = "some stuff"
//        let note = documentDir.appendingPathComponent(folderName!, isDirectory: true).appendingPathComponent(self.note!)

    }

    fileprivate func saveNote() {
        guard let text = textview.text else { return }
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let title = text.components(separatedBy: " ").first!
        let filename = documentDir.appendingPathComponent(folderName!).appendingPathComponent(title).appendingPathExtension("txt")

        do {
            try text.write(to: filename, atomically: true, encoding: .utf8)
        } catch {
            alertWithOKButton(title: "Failed to Create", message: error.localizedDescription)
        }
    }

    fileprivate func setupViews() {

        [backgroundView, textview].forEach { view.addSubview( $0 )}

        backgroundView.fillSuperview()

        NSLayoutConstraint.activate([
            textview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }

    fileprivate func setupNavigationAndToolBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneButton))
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleActionButton))

        navigationItem.rightBarButtonItems = [doneButton, actionButton]
        navigationItem.rightBarButtonItem?.tintColor = .gold
    }

    func alertWithOKButton(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        ok.setValue(UIColor.gold, forKey: "titleTextColor")

        ac.addAction(ok)

        present(ac, animated: true)
    }
}
