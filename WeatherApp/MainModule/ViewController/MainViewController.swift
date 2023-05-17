//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private var pageControl: UIPageControl!
    private var loaderView: UIActivityIndicatorView!
    
    private var model: MainModel!
    private var forecast = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        model = MainModel()
        
        model.getForecast { [weak self] in
            guard let self = self else { return }
            self.forecast = self.model.forecast
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
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = forecast.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        view.addSubview(pageControl)
        
        loaderView = UIActivityIndicatorView(style: .large)
        loaderView.tintColor = .white
        loaderView.startAnimating()
        view.addSubview(loaderView)
    }
    
    private func setupConstraints() {
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(window?.safeAreaInsets.bottom ?? 0)),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func searchButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    func pageControlTapped(_ sender: UIPageControl) {
//        let ofsetX = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
//        scrollView.setContentOffset(CGPoint(x: ofsetX, y: 0), animated: true)
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else { return UICollectionViewCell() }
        let forecast = forecast[indexPath.row]
        cell.setupViews(Forecast(cityName: forecast.cityName, temperature: forecast.temperature, condition: forecast.condition, humidity: forecast.humidity))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

