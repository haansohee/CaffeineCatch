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
        button.tintColor = UIColor(red: 255/255, green: 107/255, blue: 0/255, alpha: 1.0)
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.layer.cornerRadius = 25.0
        return button
    }()
    
    init(recordViewModel: RecordViewModel = RecordViewModel()) {
        self.recordViewModel = recordViewModel
        super.init(nibName: nil, bundle: nil)
        self.recordViewModel.fetchRecordCaffeineIntake(date: Date())
        self.recordViewModel.fetchDateStatus()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecordViewController()
        configureFSCalendar()
        addNotificationUpdateMyGoalCaffeineIntake()
        setLayoutConstraints()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCaffeineIntakeRecord()
        recordViewModel.fetchDateStatus()
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
        calenderView.locale = Locale(identifier: "ko_KR")
        calenderView.appearance.todayColor = UIColor(red: 255/255, green: 107/255, blue: 0/255, alpha: 1.0)
        calenderView.appearance.selectionColor = UIColor(red: 255/255, green: 107/255, blue: 0/255, alpha: 0.5)
    }
    
    // MARK: NotificationCenter
    private func addNotificationUpdateMyGoalCaffeineIntake() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyGoalCaffeineIntake), name: NSNotification.Name(NotificationCenterName.UpdateGoalCaffeineIntake.rawValue), object: nil)
    }
    
    @objc private func updateMyGoalCaffeineIntake() {
        recordViewModel.fetchDateStatus()
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
                let labelText = item.intake == 0 ? "기록이 없어요." : "\(item.category) \(item.intake) \(item.unit)"
                cell.label.text = labelText
                return cell
            })
        return dataSource
    }
    
    //MARK: Bind
    private func bindAll() {
        bindNonCaffeineInTakeCollectionViewSection()
        bindCaffeineIntakeData()
        bindRecordAddButton()
        bindIsFetchedDateStatus()
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
    
    private func bindIsFetchedDateStatus() {
        recordViewModel.isFetchedDateStatus
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isFetchedDateStatus in
                guard isFetchedDateStatus else { return }
                self?.calenderView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension RecordViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        recordViewModel.selectedDate = date
        recordViewModel.fetchRecordCaffeineIntake(date: date)
    }
}

extension RecordViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        switch date.toString() {
        case Date().toString():
            return "오늘"
        default:
            guard let isExceeded = recordViewModel.dateStatus[date] else { return nil }
            return isExceeded ? "❌" : "⭐️"
        }
    }
}

// MARK: CollectionView Delegate
extension RecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / 2.0) - 20.0, height: (collectionView.bounds.size.height) - 20.0)
    }
}
