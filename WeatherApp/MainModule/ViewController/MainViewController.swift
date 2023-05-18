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
        collection.backgroundColor = .white
        collection.isHidden = true
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.tintColor = .systemGray
        loader.startAnimating()
        return loader
    }()
    
    private var model: MainModel
    private let searchVC: () -> SearchViewController
    private var forecasts = [Forecast]()
    
    init(model: MainModel,
         searchVC: @escaping () -> SearchViewController) {
        self.model = model
        self.searchVC = searchVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.requestForAuthorization { status in
            switch status {
            case .autorized:
                getForecastForCurrentLocation()
            case .denied:
                showDeniedLocationAlert()
                getForecastForCurrentLocation()
            }
        }
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }
    
    private func getForecastForCurrentLocation() {
        model.getForecastForCurrentLocation { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let forecast):
                self.forecasts.append(Forecast(from: forecast))
                print(forecast)
                self.loaderView.stopAnimating()
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            case .failure(let error):
                break
            }

        }
    }
    
    private func showDeniedLocationAlert() {
        let alertController = UIAlertController (title: "Разрешите геолокацию в настройках приложения", message: "", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        
    }

    private func setupNavigationBar() {
        
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped(_:)))
        button.tintColor = .black
        
        
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupViews() {
        view.addSubview(loaderView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: "ForecastCell")
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func addForecast(_ sender: SearchViewController, forecast: ForecastJson) {
        self.forecasts.append(Forecast(from: forecast))
        collectionView.reloadData()
        let indexPath = IndexPath(item: self.forecasts.count - 1, section: 0)
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
        let forecast = forecasts[indexPath.item]
        cell.setupViews(forecast)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
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

