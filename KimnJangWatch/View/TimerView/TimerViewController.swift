//
//  TimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/13/24.
//

import UIKit
import SnapKit

class TimerViewController: UIViewController {
  
  private let scrollView = UIScrollView()
  
  // MARK: mainStackView 및 주요 View 영역
  private var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.alignment = .fill
    stackView.distribution = .fill
    return stackView
  }()
  
  private var mainTimerView: UIView = {
    let view = UIView()
    // view.backgroundColor = .yellow
    return view
  }()
  
  private var currentTimerView: UIView = {
    let view = UIView()
    // view.backgroundColor = .orange
    return view
  }()
  
  private var recentTimerView: UIView = {
    let view = UIView()
    // view.backgroundColor = .purple
    return view
  }()
  
  // MARK: mainTimerView UI 영역
  private lazy var timerPicker: UIDatePicker = {
    let timerPicker = UIDatePicker()
    timerPicker.datePickerMode = .countDownTimer
    return timerPicker
  }()
  
  private lazy var startButton: UIButton = {
    let button = UIButton()
    button.setTitle("시작", for: .normal)
    button.setTitleColor(.dangn, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .dangn.withAlphaComponent(0.2)
    button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.layer.cornerRadius = 35
    button.backgroundColor = .gray.withAlphaComponent(0.5)
    button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 150
    return stackView
  }()
  
  // MARK: currentTimerView 영역
  private lazy var currentTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .gray
    return tableView
  }()
  
  // MARK: recentTimerView 영역
  private lazy var recentLabel: UILabel = {
    let label = UILabel()
    label.text = "최근 항목"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()
  
  private lazy var recentTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(RecentTimerTableViewCell.self, forCellReuseIdentifier: RecentTimerTableViewCell.id)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .gray
    return tableView
  }()
  
  // MARK: 뷰 생애주기
  override func viewDidLoad() {
    super.viewDidLoad()
    configNavigationUI()
    setAllView()
  }
  
  // MARK: 버튼 액션
  @objc func editButtonTapped() {
    
  }
  
  @objc func startButtonTapped() {
    
  }
  
  @objc func cancelButtonTapped() {
    
  }
  
  // MARK: UI
  private func configNavigationUI() {
    view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    self.title = "타이머"
    
    let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
    editButton.tintColor = UIColor.dangn
    self.navigationItem.leftBarButtonItem = editButton
  }
  
  private func setAllView() {
    view.addSubview(scrollView)
    scrollView.addSubview(mainStackView)
    
    setMainTimerView()
    setRecentTimerView()
    setCurrentTimerView()
    
    [mainTimerView,
     currentTimerView,
     recentTimerView].forEach { mainStackView.addArrangedSubview($0) }
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    mainStackView.snp.makeConstraints {
      $0.edges.equalTo(scrollView)
      $0.width.equalTo(scrollView.snp.width)
    }
    
    mainTimerView.snp.makeConstraints {
      $0.height.equalTo(350)
    }
    
    currentTimerView.snp.makeConstraints {
      $0.height.equalTo(350)
    }
    
    recentTimerView.snp.makeConstraints {
      $0.height.equalTo(350)
    }    
  }
  
  private func setMainTimerView() {
    mainTimerView.addSubview(timerPicker)
    mainTimerView.addSubview(buttonStackView)
    [cancelButton, startButton].forEach { buttonStackView.addArrangedSubview($0) }
    
    timerPicker.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    cancelButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }

    startButton.snp.makeConstraints {
      $0.width.height.equalTo(70)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(timerPicker.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
  }
  
  private func setCurrentTimerView() {
    currentTimerView.addSubview(currentTableView)
    currentTableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setRecentTimerView() {
    [recentLabel, recentTableView].forEach { recentTimerView.addSubview($0)}
    
    recentLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
    
    recentTableView.snp.makeConstraints {
      $0.top.equalTo(recentLabel.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-10)
    }
    
  }
}

extension TimerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

extension TimerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = recentTableView
      .dequeueReusableCell(withIdentifier: RecentTimerTableViewCell.id, for: indexPath) as? RecentTimerTableViewCell else {
      return UITableViewCell()
    }
    return cell
  }
}
