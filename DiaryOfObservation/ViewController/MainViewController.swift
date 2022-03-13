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
        $0.text = " \(DateFactory.getCurrentDate())"
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }

    func bind(reactor: MainReactor) {
        confirmButton.rx.tap
            .map { Reactor.Action.saveMemo(self.getCurrentDiary()) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 배운거2 - 리액터킷에서 tableView는 RxDataSource를 활용한다.
        // TODO: - section이 여러개인 경우는 어떻게 처리?
        reactor.state
            .map { $0.diaryList }
            .bind(to: self.tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell", for: indexPath) as! DiaryTableViewCell
                cell.titleLabel.text = item.content
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func getCurrentDiary() -> Diary {
        let diary = Diary(content: inputTextView.text, date: DateFactory.getCurrentDate())
        return diary
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
