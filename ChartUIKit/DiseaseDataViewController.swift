//
//  DiseaseDataViewController.swift
//  DI
//
//  Created by Rehnuma Reza(Deepty) on 6/2/25.
//
import UIKit
import APIKit
internal import DGCharts
import Charts

public protocol DiseaseDataFetchable {
    func fetchDiseaseData(completion: @escaping ([String: Int])-> Void) async
}

public class DiseaseDataViewController: UIViewController {
    var viewModel = DiseaseDataViewModel()
    var barChartView: BarChartView!
    var scrollView: UIScrollView!
    var contentView: UIView!
    var headline: UILabel!

    public init(diseaseFetchable: DiseaseDataFetchable) {
        super.init(nibName: nil, bundle: nil)
        viewModel.diseaseFetchable = diseaseFetchable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        
        Task {
            await viewModel.prepareData()
            prepareChart()
            prepareAxes()
        }
    }
    
    func setupUI() {
        scrollView = UIScrollView(frame: .zero)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        contentView = UIView(frame: .zero)
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        setupHeadline()
        setupChart()
    }
    
    func setupHeadline() {
        headline = UILabel()
        headline.text = "Covid Cases by Years"
        headline.font = .preferredFont(forTextStyle: .headline)
        contentView.addSubview(headline)
        headline.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headline.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            headline.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            headline.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }

    func setupChart() {
        barChartView = BarChartView(frame: .zero)
        contentView.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            barChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            barChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            barChartView.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 10),
            barChartView.heightAnchor.constraint(equalToConstant: 300),
            barChartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Important for scrolling
        ])
    }
    
    func prepareChart() {
        // [BarChartEntry] -> BarChartDataSet -> BarChartData
        let keys = viewModel.yearToCasesMap.keys.sorted()
        
        let entries = keys.enumerated().map { index, key in
            return BarChartDataEntry(x: Double(index), y: Double(viewModel.yearToCasesMap[key] ?? 0))
        }
        
        print(entries)
        
        let dataset = BarChartDataSet(entries: entries, label: "Covid Cases")
        dataset.colors = [.systemBlue]
        
        let data = BarChartData(dataSet: dataset)
        data.barWidth = 0.4
        barChartView.data = data
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: keys)
    }
    
    func prepareAxes() {
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1 // Ensure labels are shown for each bar
        xAxis.drawGridLinesEnabled = false
        xAxis.labelTextColor = .black
        
        let yAxis = barChartView.leftAxis
        yAxis.axisMinimum = 0 // if not set to 0, the Y axis will have a bit of offset from the axis
        yAxis.labelTextColor = .black
        yAxis.drawGridLinesEnabled = true
        
        // Hide Right Y-axis
        barChartView.rightAxis.enabled = false
        
    }
    
    func formatNumber(_ num: Double) -> String {
        if num >= 1_000_000_000_000 {
            return String(format: "%.2fT", num / 1_000_000_000_000)
        } else if num >= 1_000_000_000 {
            return String(format: "%.2fB", num / 1_000_000_000)
        } else if num >= 1_000_000 {
            return String(format: "%.2fM", num / 1_000_000)
        } else if num >= 1_000 {
            return String(format: "%.2fK", num / 1_000)
        } else {
            return String(format: "%.0f", num)
        }
    }
}
