//
//  ViewController.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/05.
//

import UIKit
import Then
import SnapKit
import ReactorKit
import RxDataSources

class MainViewController: UIViewController, View {

    var disposeBag = DisposeBag()
    
    private let viewModel = MainViewModel()
    
    private let inputContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.layer.masksToBounds = false
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOffset = CGSize(width: 0 , height:5)
    }
    private let inputTextView = UITextView().then {
        $0.layer.addBorder([.top, .bottom], color: .black, width: 1)
    }
    private let dividLine1 = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    private let optionStackView = UIStackView().then {
        $0.addBackground(color: .white)
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    private let dataLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .left
    }
    private let confirmButton = UIButton().then {
        $0.setTitle("확인 ", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
    }
    private let dividLine2 = UIView().then {
        $0.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.5)
    }
    
    private let tableView = UITableView().then {
        $0.register(DiaryTableViewCell.self, forCellReuseIdentifier: "DiaryTableViewCell")

    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Diary>> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell", for: indexPath) as! DiaryTableViewCell
        cell.titleLabel.text = item.content
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    func bind(reactor: MainReactor) {
        confirmButton.rx.tap
            .map { Reactor.Action.saveMemo }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inputTextView.rx.text
            .map { Reactor.Action.setDiary($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        // State
        reactor.state
            .map { $0.diarySectionList }
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.date }
            .bind(to: self.dataLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: - View
extension MainViewController {
    private func setupView() {
        self.view.backgroundColor = .white
        [inputContainerView, tableView].forEach {
            self.view.addSubview($0)
        }
        [inputTextView, dividLine1, optionStackView, dividLine2].forEach {
            self.inputContainerView.addArrangedSubview($0)
        }
        [dataLabel, confirmButton].forEach {
            optionStackView.addArrangedSubview($0)
        }
        
        inputContainerView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        inputTextView.snp.makeConstraints {
            $0.height.equalTo(150)
        }
        optionStackView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        confirmButton.snp.makeConstraints {
            $0.width.equalTo(30)
        }
        dividLine1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        dividLine2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(inputContainerView.snp.bottom).offset(50)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
