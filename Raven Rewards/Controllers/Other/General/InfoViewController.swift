//
//  RegistrationViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import UIKit

class InfoViewController: UIViewController {
    
    @objc func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    private lazy var tableVw: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 44
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellId)
        return tv
    }()
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
        view.backgroundColor = .white
    }
}

private extension InfoViewController {
    func setup() {
        self.navigationController?.navigationBar.topItem?.title = "How to use"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableVw.dataSource = self
        
        self.view.addSubview(tableVw)
        
        NSLayoutConstraint.activate([
            tableVw.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableVw.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableVw.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableVw.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        
        ])
    }
}

extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVw.dequeueReusableCell(withIdentifier: InfoTableViewCell.cellId, for: indexPath) as! InfoTableViewCell
        cell.configure(with: indexPath.row + 1)
        return cell
    }
}
