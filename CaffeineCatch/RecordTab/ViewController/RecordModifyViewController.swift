//
//  RecordModifyViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 12/9/24.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

final class RecordModifyViewController: UIViewController {
    private let recordModifyViewModel: RecordModifyViewModel
    private let disposeBag = DisposeBag()
    private let recordModifyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RecordModifyCollectionViewCell.self, forCellWithReuseIdentifier: RecordModifyCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
    init(viewModel: RecordModifyViewModel = RecordModifyViewModel()) {
        self.recordModifyViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.recordModifyViewModel.fetchRecordData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecordModifyViewController()
        setLayoutConstraints()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recordModifyViewModel.fetchRecordData()
    }
}

extension RecordModifyViewController {
    //MARK: Configure
    private func configureRecordModifyViewController() {
        recordModifyCollectionView.delegate = self
        navigationItem.title = "기록 수정하기"
        view.addSubview(recordModifyCollectionView)
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            recordModifyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recordModifyCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recordModifyCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recordModifyCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Create CollectionView DataSource
    private func createCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfRecordData>{
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfRecordData>(configureCell: {dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordModifyCollectionViewCell.reuseIdentifier, for: indexPath) as? RecordModifyCollectionViewCell else { return UICollectionViewCell() }
            cell.configureCell("\(item.category) \(item.intake) \(item.unit)", item.date, item.intake != 0)
            
            // 버튼 이벤트 구독
            cell.deleteButton.rx.tap
                .subscribe(onNext: {[weak self] _ in
                    self?.recordModifyViewModel.deleteData(intakeID: item.id)
                    
                })
                .disposed(by: cell.disposeBag)
            return cell
        })
        return dataSource
    }
    
    //MARK: Bind
    private func bindAll() {
        bindRecordModifyCollectionViewSection()
        bindIsDeletedData()
    }
    
    private func bindRecordModifyCollectionViewSection() {
        recordModifyViewModel.recordSectionData
            .bind(to: recordModifyCollectionView.rx.items(dataSource: createCollectionViewDataSource())
            )
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedData() {
        recordModifyViewModel.isDeletedData
            .subscribe(onNext: {[weak self] isDeletedData in
                guard isDeletedData else { return }
                self?.recordModifyViewModel.fetchRecordData()
                self?.recordModifyViewModel.postNotificationCenter()
            })
            .disposed(by: disposeBag)
    }
}

extension RecordModifyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 20.0, height: (collectionView.bounds.size.height) / 10.0)
    }

}
