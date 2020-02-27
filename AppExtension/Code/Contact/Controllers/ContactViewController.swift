//
//  ContactViewController.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 27/02/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }

    private func initialSetup() {
        self.setupTableView()
    }
    
}

// MARK: UITableViewDelegate
extension ContactViewController: UITableViewDataSource {
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

// MARK: UITableViewDelegate
extension ContactViewController: UITableViewDelegate {
    
}
