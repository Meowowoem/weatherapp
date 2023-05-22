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
        let loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    private let noForecastStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    private let noForecastLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "No forecast"
        return label
    }()
    
    private let noForecastButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        return button
    }()
    
    private let model: MainModel
    private let searchVC: () -> SearchViewController
    private var forecasts: [Forecast] = []
    private var cachedForecasts: [Forecast] = []
    
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
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        showForecast()
    }
    
    //MARK: - Private methods
    private func showForecast() {
        noForecastStackView.isHidden = true
        loaderView.startAnimating()
        getForecastFromCache { [weak self] in
            self?.model.requestForAuthorization { result in
                switch result {
                case let .success(status):
                    if case .denied = status {
                        self?.showDeniedLocationAlert()
                    }
                    self?.getForecastForCurrentLocation {
                        self?.getForecastForCachedLocation()
                    }
                case let .failure(error):
                    self?.showAlert(message: error.description)
                }
            }
        }
    }
    
    private func getForecastForCurrentLocation(completion: @escaping () -> Void) {
        model.getForecastForCurrentLocation { [weak self] result in
            switch result {
            case let .success(forecast):
                self?.handleForecast(forecast, currenLocation: true)
                completion()
            case let .failure(error):
                self?.showAlert(message: error.description) { _ in
                    self?.showCachedForecast()
                }
            }
        }
    }
    
    private func getForecastForCachedLocation() {
        model.getForecastForCachedLocation(cachedForecasts) { [weak self] result in
            switch result {
            case let .success(forecast):
                self?.handleForecast(forecast, currenLocation: false)
            case let .failure(error):
                self?.showAlert(message: error.description) { _ in
                    self?.showCachedForecast()
                }
            }
        }
    }
    
    private func getForecastFromCache(completion: @escaping () -> (Void)) {
        model.getForecastFromCache { [weak self] in
            self?.cachedForecasts = $0.map(Forecast.init)
            completion()
        }
    }
    
    private func showCachedForecast() {
        guard !cachedForecasts.isEmpty else {
            loaderView.stopAnimating()
            noForecastStackView.isHidden = false
            return
        }

        showAlert(message: "Forecast loaded from cache")
        forecasts = cachedForecasts
        reloadUI()
    }
    
    private func handleForecast(_ forecast: GeneralForecast, currenLocation: Bool) {
        model.saveToCache(forecastJson: forecast)
        let forecast = Forecast(from: forecast, currentLocation: currenLocation)
        if !forecasts.contains(where: {
            $0.lat == forecast.lat && $0.lon == forecast.lon
        }) {
            forecasts.append(forecast)
        }
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
        noForecastStackView.addArrangedSubview(noForecastLabel)
        noForecastStackView.addArrangedSubview(noForecastButton)
        noForecastButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        view.addSubview(noForecastStackView)
        NSLayoutConstraint.activate([
            noForecastStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noForecastStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        searchVC.forecasts = forecasts
        show(searchVC, sender: self)
    }
    
    @objc
    private func retryButtonTapped(_ sender: UIButton) {
        showForecast()
    }
    
    //MARK: - SearchViewControllerDelegate
    func addForecast(_ sender: SearchViewController, forecast: GeneralForecast) {
        model.saveToCache(forecastJson: forecast)
        forecasts.append(Forecast(from: forecast, currentLocation: false))
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.loaderView.stopAnimating()
            self.noForecastStackView.isHidden = false
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
