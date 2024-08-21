//
//  TimerViewController.swift
//  KimnJangWatch
//
//  Created by 김승희 on 8/13/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class TimerViewController: UIViewController {
  
  private let scrollView = UIScrollView()
  private let setTimerView = SetTimerViewController()
  private let currentTimerView = CurrentTimerViewController()
  private let recentTimerView = RecentTimerViewController()
  
  // MARK: mainStackView 및 주요 View 영역
  private var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.alignment = .fill
    stackView.distribution = .fill
    return stackView
  }()
  
  // MARK: 뷰 생애주기
  override func viewDidLoad() {
    super.viewDidLoad()
    recentTimerView.view.isHidden = true // 구현 완료되지 않아 hidden 해 놓았습니다.
    TimerViewModel.shared.manageTimerState()
    configNavigationUI()
    setAllView()
  }
  
  // MARK: 버튼 액션
  @objc func editButtonTapped() {
    let isEditing = !currentTimerView.currentTableView.isEditing
    navigationItem.leftBarButtonItem?.title = isEditing ? "완료" : "편집"
    currentTimerView.currentTableView.setEditing(isEditing, animated: true)
  }
  
  // MARK: UI
  private func configNavigationUI() {
    view.backgroundColor = .white
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .automatic
    self.title = "타이머"
    
    let editButton = UIBarButtonItem(title: "편집",
                                     style: .plain,
                                     target: self,
                                     action: #selector(editButtonTapped))
    editButton.tintColor = UIColor.dangn
    self.navigationItem.leftBarButtonItem = editButton
  }
  
  private func setAllView() {
    view.addSubview(scrollView)
    scrollView.addSubview(mainStackView)
    
    [setTimerView,
     currentTimerView,
     recentTimerView].forEach {
      addChildViewController(childContoller: $0, stackView: mainStackView) }
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    mainStackView.snp.makeConstraints {
      $0.edges.equalTo(scrollView)
      $0.width.equalTo(scrollView.snp.width)
    }
    
    setTimerView.view.snp.makeConstraints {
      $0.height.equalTo(350)
    }    
  }
  
  private func addChildViewController(childContoller: UIViewController, stackView: UIStackView) {
    addChild(childContoller)
    stackView.addArrangedSubview(childContoller.view)
    childContoller.didMove(toParent: self)
  }
}
