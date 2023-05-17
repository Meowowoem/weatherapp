//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 17.05.2023.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func addForecast(_ sender: SearchViewController, forecast: ForecastJson)
}

class SearchViewController: UIViewController {
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.backgroundColor = .white
        return table
    }()
    
    private let searchBar: UISearchBar = {
       let bar = UISearchBar()
        bar.searchBarStyle = UISearchBar.Style.default
        bar.placeholder = "Search..."
        bar.isTranslucent = false
        bar.backgroundImage = UIImage()
        
        return bar
    }()
    
    private var cities: [City] = [
    ]
    
    private var model: SearchModel
    
    weak var delegate: SearchViewControllerDelegate?
    
    init(model: SearchModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension SearchViewController: UITableViewDelegate,
                                UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        let city = cities[indexPath.row]
        cell.setupViews(name: city.name, country: city.country)

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        model.loadForecast(for: city, completion: { result in
            switch result {
            case .success(let value):
                self.delegate?.addForecast(self, forecast: value)
                self.navigationController?.popViewController(animated: true)
            case .failure(_):
                break
            }
        })
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        
        model.fetchCities(query: query, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let cities):
                self.cities = cities
                self.tableView.reloadData()
            case .failure(let error):
                break
            }
        })
    }
}
