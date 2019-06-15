//
//  NoteViewController.swift
//  Notes
//
//  Created by Shawn Bierman on 6/15/19.
//  Copyright © 2019 Shawn Bierman. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

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
        tv.font = UIFont.systemFont(ofSize: 22)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        setupViews()
        setupNavigationAndToolBar()
        textview.becomeFirstResponder()
    }

    @objc fileprivate func handleActionButton() {
        dump("action button")
    }

    @objc fileprivate func handleDoneButton() {
        saveNote()
        navigationController?.popViewController(animated: true)
    }

    fileprivate func saveNote() {
        print("Saving note")
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
