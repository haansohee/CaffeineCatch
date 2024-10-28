//
//  RecordViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 10/22/24.
//

import Foundation
import UIKit
import FSCalendar
import RxSwift
import RxDataSources

final class RecordViewController: UIViewController {
    private let recordView = RecordView()
    private let calenderView = CalendarView()
    private let recordAddButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50.0, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.layer.cornerRadius = 25.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecordViewController()
        configureFSCalendar()
        setLayoutConstraints()
    }
}

extension RecordViewController {
    //MARK: Configure
    private func configureRecordViewController() {
        recordView.translatesAutoresizingMaskIntoConstraints = false
        calenderView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "기록"
        [calenderView, recordView, recordAddButton].forEach { view.addSubview($0) }
        recordView.nonCaffenineInTakeCollecionView.delegate = self
        recordView.nonCaffenineInTakeCollecionView.dataSource = self
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureFSCalendar() {
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.scope = .month
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            recordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            recordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            recordView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            recordView.heightAnchor.constraint(equalToConstant: 300.0),
            
            calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            calenderView.leadingAnchor.constraint(equalTo: recordView.leadingAnchor),
            calenderView.trailingAnchor.constraint(equalTo: recordView.trailingAnchor),
            calenderView.bottomAnchor.constraint(equalTo: recordView.topAnchor, constant: -48.0),
            
            recordAddButton.trailingAnchor.constraint(equalTo: recordView.trailingAnchor),
            recordAddButton.centerYAnchor.constraint(equalTo: recordView.topAnchor),
            recordAddButton.heightAnchor.constraint(equalToConstant: 50.0),
            recordAddButton.widthAnchor.constraint(equalTo: recordAddButton.heightAnchor)
        ])
    }
    
    //MARK: Create CollectionView DataSource
    private func createCollecitonViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfInTakeNonCaffeineData> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfInTakeNonCaffeineData>(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonCaffeineInTakeCollectionViewCell.reuseIdentifier, for: indexPath) as? NonCaffeineInTakeCollectionViewCell else { return UICollectionViewCell() }
            cell.label.text = item.nonCaffeine
            return cell
        })
        return dataSource
    }
    
    //MARK: Bind
    private func bindAll() {
        
    }
    
    private func bindNonCaffeineInTakeCollectionViewSection() {
        
    }
}

extension RecordViewController: FSCalendarDelegate {
    func calendarView(_ calendarView: CalendarView, didSelect date: Date) {
        print(date)
    }
}

extension RecordViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard Calendar.current.isDate(date, inSameDayAs: Date()) else { return nil }
        return "오늘"
    }
}

extension RecordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NonCaffeineInTakeCollectionViewCell.reuseIdentifier, for: indexPath) as? NonCaffeineInTakeCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    
}

extension RecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.size.width / 2.0) - 20.0, height: collectionView.bounds.size.height - 5.0)
    }
}
