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
    private let recordViewModel: RecordViewModel
    private let disposeBag = DisposeBag()
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
    
    init(recordViewModel: RecordViewModel = RecordViewModel()) {
        self.recordViewModel = recordViewModel
        super.init(nibName: nil, bundle: nil)
        self.recordViewModel.fetchRecordCaffeineIntake(date: Date())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecordViewController()
        configureFSCalendar()
        setLayoutConstraints()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCaffeineIntakeRecord()
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
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureFSCalendar() {
        calenderView.delegate = self
        calenderView.dataSource = self
        calenderView.scope = .month
    }
    
    //MARK: Fetch Caffeine Intake Record
    private func fetchCaffeineIntakeRecord() {
        guard let selectedDate = recordViewModel.selectedDate else {
            recordViewModel.fetchRecordCaffeineIntake(date: Date())
            return
        }
        recordViewModel.fetchRecordCaffeineIntake(date: selectedDate)
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
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfInTakeNonCaffeineData>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaffeineIntakeCollectionViewCell.reuseIdentifier, for: indexPath) as? CaffeineIntakeCollectionViewCell else {
                    return UICollectionViewCell() }
                guard !item.nonCaffeine.isEmpty,
                      item.nonCaffeine != "" else {
                    cell.label.text = "기록이 없어요."
                    return cell}
                cell.label.text = item.nonCaffeine
                return cell
            })
        return dataSource
    }
    
    //MARK: Bind
    private func bindAll() {
        bindNonCaffeineInTakeCollectionViewSection()
        bindCaffeineIntakeData()
        bindRecordAddButton()
    }
    
    private func bindNonCaffeineInTakeCollectionViewSection() {
        recordViewModel.nonCaffeineSectionData
            .bind(to: recordView.nonCaffenineInTakeCollecionView.rx.items(dataSource: createCollecitonViewDataSource())
            )
            .disposed(by: disposeBag)
    }
    
    private func bindCaffeineIntakeData() {
        recordViewModel.caffeineIntakeData
            .asDriver(onErrorJustReturn: "기록이 없어요.")
            .drive(onNext: {[weak self] caffeineIntake in
                guard !caffeineIntake.isEmpty,
                      caffeineIntake != "" else {
                    self?.recordView.caffeineIntakeLabel.text = "기록이 없어요."
                    return }
                self?.recordView.caffeineIntakeLabel.text = caffeineIntake
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRecordAddButton() {
        recordAddButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let selectedDate = self?.recordViewModel.selectedDate else {
                    self?.navigationController?.pushViewController(RecordEntryViewController(selectedDate: Date()), animated: true)
                    return }
                self?.navigationController?.pushViewController(RecordEntryViewController(selectedDate: selectedDate), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension RecordViewController: FSCalendarDelegate {
}

extension RecordViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        guard Calendar.current.isDate(date, inSameDayAs: Date()) else { return nil }
        return "오늘"
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        recordViewModel.selectedDate = date
        recordViewModel.fetchRecordCaffeineIntake(date: date)
        print(date)
    }
}

// MARK: CollectionView Delegate
extension RecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / 2.0) - 20.0, height: (collectionView.bounds.size.height) - 20.0)
    }
}
