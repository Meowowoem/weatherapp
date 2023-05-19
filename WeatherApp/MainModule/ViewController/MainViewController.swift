//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class MainViewController: UIViewController, SearchViewControllerDelegate {
    //MARK: - Private properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.backgroundColor = .white
        collection.isHidden = true
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ForecastViewCell.self, forCellWithReuseIdentifier: ForecastViewCell.id)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.tintColor = .systemGray
        loader.startAnimating()
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private let model: MainModel
    private let searchVC: () -> SearchViewController
    private var forecasts: [Forecast] = []
    
    //MARK: - Init
    init(model: MainModel, searchVC: @escaping () -> SearchViewController) {
        self.model = model
        self.searchVC = searchVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        
        model.requestForAuthorization { status in
            if case .denied = status {
                showDeniedLocationAlert()
            }
            getForecastForCurrentLocation()
        }
    }
    
    //MARK: - Private methods
    private func getForecastForCurrentLocation() {
        model.getForecastForCurrentLocation { [weak self] result in
            switch result {
            case let .success(forecast):
                self?.handleForecast(forecast)
            case let .failure(error):
                self?.showAlert(message: error.description) { _ in
                    self?.getForecastFromCache()
                }
            }
        }
    }
    
    private func getForecastFromCache() {
        model.getForecastFromCache { [weak self] in
            self?.showAlert(message: "Forecast loaded from cache")
            self?.forecasts = $0.map(Forecast.init)
            self?.reloadUI()
        }
    }
    
    private func handleForecast(_ forecast: GeneralForecast) {
        model.saveToCache(forecastJson: forecast)
        forecasts.append(Forecast(from: forecast))
        reloadUI()
    }
    
    private func setupNavigationBar() {
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped(_:)))
        button.tintColor = .black
        navigationItem.rightBarButtonItem = button
    }
    
    private func reloadUI() {
        loaderView.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    private func setupViews() {
        view.addSubview(loaderView)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func searchButtonTapped(_ sender: UIBarButtonItem) {
        let searchVC = searchVC()
        searchVC.delegate = self
        show(searchVC, sender: self)
    }
    
    //MARK: - SearchViewControllerDelegate
    func addForecast(_ sender: SearchViewController, forecast: GeneralForecast) {
        model.saveToCache(forecastJson: forecast)
        forecasts.append(Forecast(from: forecast))
        collectionView.reloadData()
        let indexPath = IndexPath(item: forecasts.count - 1, section: .zero)
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastViewCell.id,
                                                            for: indexPath) as? ForecastViewCell else {
            return UICollectionViewCell()
        }
        let forecast = forecasts[indexPath.item]
        cell.setup(forecast)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecasts.count
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        UIScreen.main.bounds.size
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
}

private extension MainViewController {
    func showDeniedLocationAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: "Allow geolocation in settings",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings",
                                           style: .default) { _ in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        showDetailViewController(alertController, sender: self)
    }
}
