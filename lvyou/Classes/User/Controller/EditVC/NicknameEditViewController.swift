//
//  NicknameEditViewController.swift
//  修改昵称页（Swift 重写，替代原 OC 版 + xib）。
//
//  UI 代码重建（删 xib）：导航栏右上「保存」+ 一个输入框。
//  保存 → 校验（非空、≤8字）→ revamp_users → 回传 UserInfoModel 给 delegate。
//  协议以 @objc 暴露，OC 调用方（XYEditUserInfoViewController / YinXiangViewController）
//  的 <XYNickNameControllerDelegate> 用法不变。
//

import UIKit

@objc protocol XYNickNameControllerDelegate: AnyObject {
    func nickNameController(_ nickNameVC: NicknameEditViewController, withUserInfoModel model: UserInfoModel)
}

@objc(NicknameEditViewController)
final class NicknameEditViewController: UIViewController {

    @objc weak var delegate: XYNickNameControllerDelegate?
    @objc var name: String?

    private let gray5 = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)   // colorLetterGray5
    private let yellowTint = UIColor(red: 252/255.0, green: 184/255.0, blue: 4/255.0, alpha: 1) // colorYellowTint

    private let nickNameField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        buildUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func buildUI() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("保存", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 15)
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)
        saveButton.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)

        let card = UIView()
        card.backgroundColor = .white
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        nickNameField.text = name
        nickNameField.textColor = gray5
        nickNameField.tintColor = yellowTint
        nickNameField.font = .systemFont(ofSize: 15)
        nickNameField.clearButtonMode = .always
        nickNameField.returnKeyType = .done
        nickNameField.delegate = self
        nickNameField.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(nickNameField)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            card.heightAnchor.constraint(equalToConstant: 50),

            nickNameField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            nickNameField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            nickNameField.centerYAnchor.constraint(equalTo: card.centerYAnchor),
        ])
    }

    @objc private func onSave() {
        let name = nickNameField.text ?? ""
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            MessageHelper().showWarn(forShortTime: self, title: "", sub: "请设置昵称")
            return
        }
        if name.count > 8 {
            MessageHelper().showWarn(forShortTime: self, title: "", sub: "昵称过长请小于8个字")
            return
        }
        let params = NSMutableDictionary()
        params.setValue(name, forKey: "nickname")
        RootHttpHelper.shared().achieveCommonPostURL(revamp_users, andController: self, andView: view, andParams: params) { [weak self] successData in
            guard let self = self else { return }
            // 后台返回 500 表示昵称修改错误，不做任何操作
            if (successData["api_code"] as? NSNumber)?.intValue == 500 { return }
            if let model = try? UserInfoModel(dictionary: successData as? [AnyHashable: Any]) {
                self.delegate?.nickNameController(self, withUserInfoModel: model)
            }
            if let nav = self.navigationController, nav.viewControllers.count > 1 {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension NicknameEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickNameField.resignFirstResponder()
        return true
    }
}
