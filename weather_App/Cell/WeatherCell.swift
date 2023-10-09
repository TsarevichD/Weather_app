//
//  WeatherCell.swift
//  weather_App
//
//  Created by MacBook on 07/10/2023.
//

import Foundation
import UIKit
import SnapKit

class WeatherCell: UITableViewCell {
    
    static let reuseId = String(describing: WeatherCell.self)
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true 
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        [dayLabel, conditionLabel, maxTempLabel, iconImageView].forEach(addSubview(_:))
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.top.equalToSuperview().inset(20)
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(dayLabel.snp.trailing).offset(10)
            make.width.equalToSuperview().multipliedBy(0.35)
            make.top.equalToSuperview().inset(20)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().inset(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(4)
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = nil
        conditionLabel.text = nil
        maxTempLabel.text = nil
        iconImageView.image = nil
    }
}
