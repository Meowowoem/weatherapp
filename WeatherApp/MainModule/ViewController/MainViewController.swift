//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class MainViewController: UIViewController,
                                SearchViewControllerDelegate {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.backgroundColor = .red
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.tintColor = .white
        loader.startAnimating()
        return loader
    }()
    
    public var model: MainModel?
    private let searchVC: () -> SearchViewController
    private var forecast = [Forecast]()
    
    init(searchVC: @escaping () -> SearchViewController) {
        self.searchVC = searchVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.getForecast { [weak self] in
            guard let self = self else { return }
            self.forecast = self.model?.forecast ?? []
            self.loaderView.stopAnimating()
            self.collectionView.reloadData()
        }
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped(_:)))
        button.tintColor = .white
        
        
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: "ForecastCell")
        view.addSubview(collectionView)
        view.addSubview(loaderView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addForecast(_ sender: SearchViewController, forecast: ForecastJson) {
        self.forecast.append(Forecast(from: forecast))
        collectionView.reloadData()
        let indexPath = IndexPath(item: self.forecast.count - 1, section: 0)
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }
    
    @objc
    private func searchButtonTapped(_ sender: UIBarButtonItem) {
        let searchVC = searchVC()
        searchVC.delegate = self
        show(searchVC, sender: self)
    }
}

extension MainViewController: UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else { return UICollectionViewCell() }
        let forecast = forecast[indexPath.item]
        cell.setupViews(forecast)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

