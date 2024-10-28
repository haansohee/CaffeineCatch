//
//  MyPageViewController.swift
//  CaffeineCatch
//
//  Created by 한소희 on 9/24/24.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

final class MyGoalViewController: UIViewController {
    private let myGoalView = MyGoalView()
    private let myPageViewModel: MyGoalViewModel
    private let disposeBag = DisposeBag()
    
    init(myPageViewModel: MyGoalViewModel = MyGoalViewModel()) {
        self.myPageViewModel = myPageViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMyPageViewController()
        setLayoutConstraints()
        bindAll()
    }
}

extension MyGoalViewController {
    //MARK: Configure
    private func configureMyPageViewController() {
        myGoalView.translatesAutoresizingMaskIntoConstraints = false
        myGoalView.averageCaffeineCollectionView.delegate = self
        navigationItem.title = "My Goal"
        view.addSubview(myGoalView)
        view.backgroundColor = .secondarySystemBackground
    }
    
    //MARK: Set Layout Constraint
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            myGoalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myGoalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myGoalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myGoalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Create CollectionView DataSource
    private func createCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>{
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: {dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AverageCaffeineCollectionViewCell.reuseIdentifier, for: indexPath) as? AverageCaffeineCollectionViewCell else { return UICollectionViewCell() }
            cell.configureAverageCaffeineLabel(item.caffeineData, item.mgData)
            return cell
        })
        return dataSource
    }
    
    //MARK: Bind
    private func bindAll() {
        bindAverageCaffeineCollectionViewSection()
    }
    
    private func bindAverageCaffeineCollectionViewSection() {
        myPageViewModel.section
            .bind(to: myGoalView.averageCaffeineCollectionView.rx.items(dataSource: createCollectionViewDataSource()))
            .disposed(by: disposeBag)
    }
}

extension MyGoalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }
}
