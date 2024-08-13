//
//  AlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//

import UIKit

import SwiftUI

class AlarmViewController: UIViewController {
  
  private var alarmView = AlarmView(frame: .zero)
  
  override func loadView() {
    alarmView = AlarmView(frame: UIScreen.main.bounds)
    self.view = alarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green
    alarmView.alarmList.register(AlarmListCell.self, forCellReuseIdentifier: AlarmListCell.identifier)
  }
}

struct PreView: PreviewProvider {
 static var previews: some View {
   AlarmViewController().toPreview()
 }
}

#if DEBUG
extension UIViewController {
 private struct Preview: UIViewControllerRepresentable {
   let viewController: UIViewController
   func makeUIViewController(context: Context) -> UIViewController {
    return viewController
   }
   func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
   }
  }
  func toPreview() -> some View {
   Preview(viewController: self)
  }
}
#endif
