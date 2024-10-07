//
//  MainViewController.swift
//  HW23
//
//  Created by Максим Громов on 22.09.2024.
//

import UIKit
import WebKit
import SnapKit
class MainViewController: UIViewController, UISearchBarDelegate, WKNavigationDelegate, HistoryDelegate {
    
    lazy var webView = WKWebView()
    lazy var searchController = UISearchController()
    lazy var bottomView = UIStackView()
    var favorites: [URL] = []
    var history: [URL] = []
    lazy var favoriteButton = UIButton()
    
    
    func open(url: URL) {
        openURL(url: url.absoluteString)
    }
    func openURL(url: String) {
        let text = url.lowercased()
        var request: URLRequest?
        if text.hasPrefix("https://") {
            request = URLRequest(url: URL(string: text)!)
        }else if text.hasPrefix("www.") {
            request = URLRequest(url: URL(string: "https://" + text)!)
        }else{
            request = URLRequest(url: URL(string: "https://google.com/search?q=\(text)")!)
        }
        webView.load(request!)
    }
    var backButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left")?.applyingSymbolConfiguration(.init(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }
    var historyButton: UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "book")?.applyingSymbolConfiguration(.init(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        return button
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        guard var text = searchBar.text else { return true }
        openURL(url: text)
        return true
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        if let url = navigationResponse.response.url{
            history.append(url)
            UserDefaults.standard.set(history, forKey: "history")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateFavoriteButtonState()
        }
        return .allow
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = UserDefaults.standard.array(forKey: "favorites") as? [URL] ?? []
        history = UserDefaults.standard.array(forKey: "history") as? [URL] ?? []
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        view.addSubview(webView)
        webView.navigationDelegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.backgroundColor = .systemGray6
        bottomView.axis = .horizontal
        bottomView.addArrangedSubview(backButton)
        bottomView.addArrangedSubview(favoriteButton)
        bottomView.addArrangedSubview(historyButton)
        bottomView.distribution = .fillEqually
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        updateFavoriteButtonState()
        
    }
    
    func updateFavoriteButtonState(){
        guard let url = webView.url else {
            print("Not Filled")
            favoriteButton.setImage(UIImage(systemName: "star")?.applyingSymbolConfiguration(.init(pointSize: 24)), for: .normal)
            return
        }
        if favorites.contains(url){
            print("Filled")
            favoriteButton.setImage(UIImage(systemName: "star.fill")?.applyingSymbolConfiguration(.init(pointSize: 24)), for: .normal)
        }else{
            print("Not Filled")
            favoriteButton.setImage(UIImage(systemName: "star")?.applyingSymbolConfiguration(.init(pointSize: 24)), for: .normal)
        }
    }
    
    @objc func backButtonTapped(){
        webView.goBack()
        updateFavoriteButtonState()
    }
    
    @objc func favoriteButtonTapped(){
        guard let url = webView.url else { return }
        if favorites.contains(url){
            favorites.remove(at: favorites.firstIndex(of: url)!)
        }else{
            favorites.append(url)
        }
        UserDefaults.standard.set(favorites, forKey: "favorites")
        updateFavoriteButtonState()
    }
    
    @objc func historyButtonTapped(){
        let historyVC = HistoryViewController()
        historyVC.favorite = favorites
        historyVC.history = history
        historyVC.delegate = self
        navigationController?.pushViewController(historyVC, animated: true)
    }
}


