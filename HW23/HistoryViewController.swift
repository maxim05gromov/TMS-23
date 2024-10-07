//
//  HistoryViewController.swift
//  HW23
//
//  Created by Максим Громов on 23.09.2024.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var history: [URL] = []
    var favorite: [URL] = []
    
    lazy var switcher  = UISegmentedControl()
    lazy var tableView = UITableView()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switcher.selectedSegmentIndex == 0 ? history.count : favorite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = switcher.selectedSegmentIndex == 0 ? history[indexPath.row].absoluteString : favorite[indexPath.row].absoluteString
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let from = switcher.selectedSegmentIndex == 0 ? history : favorite
        delegate?.open(url: from[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    weak var delegate: HistoryDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "History"
        view.addSubview(switcher)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        switcher.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        switcher.insertSegment(withTitle: "History", at: 0, animated: false)
        switcher.insertSegment(withTitle: "Favorite", at: 1, animated: false)
        switcher.selectedSegmentIndex = 0
        switcher.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(switcher.snp.bottom)
        }
        
    }
    @objc func segmentChanged() {
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
protocol HistoryDelegate: AnyObject {
    func open(url: URL)
}
