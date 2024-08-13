//
//  StopWatchController.swift
//  KimnJangWatch
//
//  Created by bloom on 8/12/24.
//

import UIKit
import SnapKit
final class StopWatchController: UIViewController {

  
  let timeStackView = {
    let x = UIStackView()
    x.axis = .vertical
    x.distribution = .fillProportionally
    x.spacing = 0
    return x
  }()
  let buttonStackView = {
    let x = UIStackView()
    x.axis = .horizontal
    x.distribution = .fillProportionally
    x.spacing = 200
    return x
  }()
  
  lazy var timerLabel = {
    let x = UILabel()
    x.font = UIFont.systemFont(ofSize: 48, weight: .bold)
    x.textAlignment = .center
    x.textColor = .black
    x.text = "00:00.00"
    return x
  }()
  lazy var resetButton = {
    let x = UIButton()
    x.setTitle("랩", for: .normal)
    x.setTitleColor(.red, for: .normal)
    x.layer.cornerRadius = 25
    x.backgroundColor = UIColor.lightGray
    return x
  }()
  lazy var startButton = {
    let x = UIButton()
    x.setTitle("시작", for: .normal)
    x.setTitleColor(.green, for: .normal)
    x.layer.cornerRadius = 25
    x.backgroundColor = UIColor.lightGray
    return x
  }()

  
  
  lazy var timeLabCollectionView = {
    let x = UITableView()
    x.register(LapViewCell.self, forCellReuseIdentifier: LapViewCell.id)
    x.dataSource = self
    x.delegate = self
    return x
  }()
  // halfLine

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    navigationItem.title = "스톱워치"
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    self.configureUI()
    self.makeConstraints()
  }
    private func configureUI(){
      [
        timeStackView,
        timeLabCollectionView
      ].forEach{self.view.addSubview($0)}
      [
        timerLabel,
       buttonStackView
      ].forEach{self.timeStackView.addArrangedSubview($0)}
      [
        resetButton,
        startButton
      ].forEach{self.buttonStackView.addArrangedSubview($0)}
    }
    
    private func makeConstraints(){
      timeStackView.snp.makeConstraints{
        $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
        $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        $0.height.equalTo(250)
      }
      timeLabCollectionView.snp.makeConstraints{
        $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(30)
        $0.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        $0.height.equalTo(300)
      }
//      timerLabel.snp.makeConstraints{
//        $0.height.equalTo(100)
//      }
      resetButton.snp.makeConstraints{
        $0.height.width.equalTo(50)
      }
      startButton.snp.makeConstraints{
        $0.height.width.equalTo(50)
      }
    }
    
  
  
}
extension StopWatchController {
  @objc func resetButtonDidTap(){
    
  }
  @objc func startButtonDidTap(){
    
  }
  
  
}

extension StopWatchController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LapViewCell.id, for: indexPath) as? LapViewCell
    
    guard let safecell = cell
    else { return UITableViewCell() }
    return safecell
  }
  
  
}

final class LapViewCell: UITableViewCell {
  static let id = "LabViewCell"
  let lapCountLabel = {
    let x = UILabel()
    x.text = "랩1"
    x.textAlignment = .left
    x.font = UIFont.systemFont(ofSize: 18)
    return x
  }()
  let timeLabel = {
    let x = UILabel()
    x.text = "00:00.00"
    x.textAlignment = .right
    x.font = UIFont.systemFont(ofSize: 18)
    return x
  }()
//half line
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  private func configureUI(){
    self.addSubview(lapCountLabel)
    self.addSubview(timeLabel)
    lapCountLabel.snp.makeConstraints{
      $0.leading.equalTo(contentView).inset(20)
      $0.centerY.equalToSuperview()
      
    }
    timeLabel.snp.makeConstraints{
      $0.trailing.equalTo(contentView).inset(20)
      $0.centerY.equalToSuperview()
    }
    
  }

  
}

