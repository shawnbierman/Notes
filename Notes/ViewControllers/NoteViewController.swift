//
//  NoteViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    var note: Note?
    let defaults = UserDefaults.standard
    let kNoteKey = "note"

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

    @objc fileprivate func handleActionButton() {
        dump("handleActionButton()")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let text = textview.text else { return }

        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            dump("NODATA")
        } else {
            saveNote()
        }
    }

    @objc fileprivate func handleDoneButton() {
        // should dim 'done' button,
        // then resign first responder,
        // but should NOT popViewController.
        // that's not how native app behaves
        // TODO: - Fix this
        navigationController?.popViewController(animated: true)
    }

    fileprivate func saveNote() {
        guard let text = textview.text else { return }
        dump("saveNote(): \(text)")

        let jsonEncoder = JSONEncoder()

        note = Note(title: "title string", content: text)

        do {
            let data = try jsonEncoder.encode(note)
            defaults.set(data, forKey: kNoteKey)
        } catch {
            dump("ERROR: \(error.localizedDescription)")
        }

//        if let savedData = try? jsonEncoder.encode(note) {
//            defaults.set(savedData, forKey: kNoteKey)
//        } else {
//            dump("failed to save")
//        }
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
}
