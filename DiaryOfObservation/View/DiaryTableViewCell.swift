//
//  DiaryTableViewCell.swift
//  DiaryOfObservation
//
//  Created by 김상진 on 2021/07/10.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupView() {
        self.backgroundColor = .brown
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
