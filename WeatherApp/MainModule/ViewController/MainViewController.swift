//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Nikita Salnikov on 16.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    private var cities = [
        CityModel(name: "Moscow", weather: WeatherModel(temperature: 30, condition: .sunny, humidity: 55)),
        CityModel(name: "Sochi", weather: WeatherModel(temperature: 35, condition: .sunny, humidity: 76)),
        CityModel(name: "Ufa", weather: WeatherModel(temperature: 24, condition: .cloudy, humidity: 61)),
        CityModel(name: "Tokyo", weather: WeatherModel(temperature: 16, condition: .rainy, humidity: 89))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Погода"
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped(_:)))
        
        
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupViews() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        for (index, city) in cities.enumerated() {
            let weatherView = WeatherView(city: city)
            weatherView.setupViews()
            scrollView.addSubview(weatherView)
            weatherView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                weatherView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: view.frame.width * CGFloat(index)),
                weatherView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                weatherView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        
        scrollView.contentSize = CGSize(width:view.frame.width * 4, height: 100)
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = cities.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .systemMint
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        view.addSubview(pageControl)
    }
    
    private func setupConstraints() {
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(window?.safeAreaInsets.bottom ?? 0)),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func searchButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc
    func pageControlTapped(_ sender: UIPageControl) {
        let ofsetX = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: ofsetX, y: 0), animated: true)
    }
    
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}

