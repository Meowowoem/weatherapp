//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

final class SearchViewController: UITableViewController {
    //MARK: - Private properties
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .default
        bar.placeholder = "Search..."
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    private var searchTask: DispatchWorkItem?
    private var cities: [City] = []
    private let model: SearchModel
    weak var delegate: SearchViewControllerDelegate?
    
    //MARK: - Init
    init(model: SearchModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
    }
    
    //MARK: - Private methods
    private func setupViews() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView() {
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.id)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.id,
            for: indexPath
        ) as? SearchResultCell else { return UITableViewCell() }
        let city = cities[indexPath.row]
        cell.setupCell(name: city.name, country: city.country)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        model.loadForecast(for: city) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(forecast):
                self.delegate?.addForecast(self, forecast: forecast)
                self.navigationController?.popViewController(animated: true)
            case let .failure(error):
                self.showAlert(message: error.description)
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            self?.reload(searchBar)
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        guard query.count > 2 else { return showAlert(message: "Type from 3 symbols") }
        
        model.fetchCities(query: query) { [weak self] result in
            switch result {
            case let .success(cities):
                guard !cities.isEmpty else {
                    self?.cities.removeAll()
                    self?.tableView.reloadData()
                    self?.showAlert(message: "Nothing found")
                    return
                }
                self?.cities = cities
                self?.tableView.reloadData()
            case let .failure(error):
                self?.cities.removeAll()
                self?.tableView.reloadData()
                self?.showAlert(message: error.description)
            }
        }
    }
}
