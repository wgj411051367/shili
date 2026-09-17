//
//  ProfileSetupViewController.swift
//  完善资料页（Swift 重写，替代原 OC 版 + xib）。
//
//  UI 代码 + Auto Layout 重建（删 xib）。视觉对齐原 xib：圆形头像上传、
//  昵称输入行、性别行（action sheet 选择）、生日行（底部弹出日期选择器）、
//  进入按钮。角色行原 xib 里是隐藏的，此处保留隐藏 label 以承接 revamp 回传。
//  脏活（token / 建主 TabBar / revamp_users 解析 UserInfoModel）走 LoginBridge。
//

import UIKit

@objc(ProfileSetupViewController)
final class ProfileSetupViewController: UIViewController {

    private let darkText = UIColor(red: 0.204, green: 0.204, blue: 0.204, alpha: 1)
    private let lightGray = UIColor(red: 0.737, green: 0.737, blue: 0.737, alpha: 1)
    private let separator = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)

    private let avatarImg = UIImageView()
    private let nickField = UITextField()
    private let sexLab = UILabel()
    private let birthLab = UILabel()
    private let roleLab = UILabel()       // 角色（隐藏，仅承接 revamp 回传）
    private let popupView = UIView()
    private let datePicker = UIDatePicker()

    private var birth: String = ""
    private var avatarUploaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildUI()
        setupDatePicker()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - UI

    private func buildUI() {
        let safe = view.safeAreaLayoutGuide

        avatarImg.image = UIImage(named: "icon_login_upload_img")
        avatarImg.layer.cornerRadius = 37.5
        avatarImg.layer.masksToBounds = true
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImg)

        let avatarButton = UIButton(type: .system)
        avatarButton.addTarget(self, action: #selector(onAvatar), for: .touchUpInside)
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarButton)

        let nickRow = makeRow(title: "昵称", value: nil, valueField: nickField, showArrow: false)
        let sexRow = makeRow(title: "性别", value: sexLab, valueField: nil, showArrow: true)
        let birthRow = makeRow(title: "生日", value: birthLab, valueField: nil, showArrow: true)
        [nickRow, sexRow, birthRow].forEach { view.addSubview($0) }

        // 昵称输入框
        nickField.placeholder = "请输入昵称"
        nickField.font = .systemFont(ofSize: 13)
        nickField.textColor = darkText
        nickField.clearButtonMode = .always
        nickField.returnKeyType = .done
        nickField.delegate = self

        // 性别值初始为提示文案（与原 xib 一致），选择后被 revamp 回传覆盖为 男/女
        sexLab.text = "注册成功后性别不能修改"
        sexLab.font = .systemFont(ofSize: 13)
        sexLab.textColor = lightGray

        birthLab.text = ""
        birthLab.font = .systemFont(ofSize: 11)
        birthLab.textColor = lightGray

        // 行点击（透明按钮铺满）
        addTapButton(to: sexRow, action: #selector(onSelectSex))
        addTapButton(to: birthRow, action: #selector(onSelectBirth))

        // 进入按钮
        let loginButton = UIButton(type: .system)
        loginButton.setBackgroundImage(UIImage(named: "icon_login_goin"), for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16)
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)

        buildPopup()

        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: safe.topAnchor, constant: 24),
            avatarImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImg.widthAnchor.constraint(equalToConstant: 75),
            avatarImg.heightAnchor.constraint(equalToConstant: 75),
            avatarButton.topAnchor.constraint(equalTo: avatarImg.topAnchor),
            avatarButton.leadingAnchor.constraint(equalTo: avatarImg.leadingAnchor),
            avatarButton.trailingAnchor.constraint(equalTo: avatarImg.trailingAnchor),
            avatarButton.bottomAnchor.constraint(equalTo: avatarImg.bottomAnchor),

            nickRow.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 17),
            nickRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            nickRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            nickRow.heightAnchor.constraint(equalToConstant: 40),

            sexRow.topAnchor.constraint(equalTo: nickRow.bottomAnchor, constant: 15),
            sexRow.leadingAnchor.constraint(equalTo: nickRow.leadingAnchor),
            sexRow.trailingAnchor.constraint(equalTo: nickRow.trailingAnchor),
            sexRow.heightAnchor.constraint(equalToConstant: 40),

            birthRow.topAnchor.constraint(equalTo: sexRow.bottomAnchor, constant: 15),
            birthRow.leadingAnchor.constraint(equalTo: nickRow.leadingAnchor),
            birthRow.trailingAnchor.constraint(equalTo: nickRow.trailingAnchor),
            birthRow.heightAnchor.constraint(equalToConstant: 40),

            loginButton.topAnchor.constraint(equalTo: birthRow.bottomAnchor, constant: 70),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 240),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    /// 一行：左标题 + 右值(label 或输入框) + 可选箭头 + 底部分隔线
    private func makeRow(title: String, value: UILabel?, valueField: UITextField?, showArrow: Bool) -> UIView {
        let row = UIView()
        row.backgroundColor = .white
        row.layer.cornerRadius = 4
        row.layer.masksToBounds = true
        row.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = darkText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(titleLabel)

        let valueView: UIView = value ?? valueField ?? UIView()
        valueView.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(valueView)

        let underline = UIView()
        underline.backgroundColor = separator
        underline.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(underline)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 18),
            titleLabel.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            valueView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 24),
            valueView.centerYAnchor.constraint(equalTo: row.centerYAnchor),

            underline.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 53),
            underline.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 0.5),
        ])

        if showArrow {
            let arrow = UIImageView(image: UIImage(named: "icon_user_back_gray"))
            arrow.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(arrow)
            NSLayoutConstraint.activate([
                arrow.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -18),
                arrow.centerYAnchor.constraint(equalTo: row.centerYAnchor),
                arrow.widthAnchor.constraint(equalToConstant: 8),
                arrow.heightAnchor.constraint(equalToConstant: 13),
                valueView.trailingAnchor.constraint(lessThanOrEqualTo: arrow.leadingAnchor, constant: -8),
            ])
        } else {
            valueView.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -18).isActive = true
        }
        return row
    }

    private func addTapButton(to row: UIView, action: Selector) {
        let button = UIButton(type: .system)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: row.topAnchor),
            button.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: row.bottomAnchor),
        ])
    }

    // MARK: - 底部日期弹窗

    private func buildPopup() {
        popupView.backgroundColor = .white
        popupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupView)

        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(bar)

        let cancel = UIButton(type: .system)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(darkText, for: .normal)
        cancel.addTarget(self, action: #selector(onCancelBirth), for: .touchUpInside)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(cancel)

        let confirm = UIButton(type: .system)
        confirm.setTitle("确定", for: .normal)
        confirm.setTitleColor(darkText, for: .normal)
        confirm.addTarget(self, action: #selector(onConfirmBirth), for: .touchUpInside)
        confirm.translatesAutoresizingMaskIntoConstraints = false
        bar.addSubview(confirm)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(datePicker)

        NSLayoutConstraint.activate([
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            popupView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            popupView.heightAnchor.constraint(equalToConstant: 220),

            bar.topAnchor.constraint(equalTo: popupView.topAnchor),
            bar.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            bar.heightAnchor.constraint(equalToConstant: 44),

            cancel.leadingAnchor.constraint(equalTo: bar.leadingAnchor, constant: 8),
            cancel.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            confirm.trailingAnchor.constraint(equalTo: bar.trailingAnchor, constant: -8),
            confirm.centerYAnchor.constraint(equalTo: bar.centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: bar.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // 起始隐藏（下移 + 透明）
        popupView.alpha = 0
        popupView.transform = CGAffineTransform(translationX: 0, y: 220)
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(onDateChanged), for: .valueChanged)
    }

    @objc private func onDateChanged() {
        let df = DateFormatter()
        df.locale = Locale(identifier: "zh_CN")
        df.dateFormat = TimeStyle
        birth = df.string(from: datePicker.date)
    }

    private func showPopup() {
        UIView.animate(withDuration: 0.2) {
            self.popupView.alpha = 1
            self.popupView.transform = .identity
        }
    }

    private func hidePopup() {
        UIView.animate(withDuration: 0.2) {
            self.popupView.alpha = 0
            self.popupView.transform = CGAffineTransform(translationX: 0, y: 220)
        }
    }

    // MARK: - 动作

    @objc private func onAvatar() { presentAvatarSheet() }

    @objc private func onSelectBirth() { showPopup() }

    @objc private func onCancelBirth() { hidePopup() }

    @objc private func onConfirmBirth() {
        // 未滚动过则取当前 picker 值
        if birth.isEmpty { onDateChanged() }
        revamp(["birthday": birth])
        hidePopup()
    }

    @objc private func onSelectSex() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "女", style: .default) { _ in self.revamp(["gender": "0"]) })
        sheet.addAction(UIAlertAction(title: "男", style: .default) { _ in self.revamp(["gender": "1"]) })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(sheet, animated: true)
    }

    @objc private func onLogin() {
        if (nickField.text ?? "").isEmpty {
            HudHelper.hudHepler().showShortTips(view, tips: "昵称不能为空"); return
        }
        revamp(["nickname": nickField.text ?? ""])   // 保存昵称
        if (birthLab.text ?? "").isEmpty {
            HudHelper.hudHepler().showShortTips(view, tips: "请设置生日"); return
        }
        if (sexLab.text ?? "").isEmpty {
            HudHelper.hudHepler().showShortTips(view, tips: "请设置性别"); return
        }
        if !avatarUploaded {
            HudHelper.hudHepler().showShortTips(view, tips: "请上传头像"); return
        }
        LoginBridge.enterMainApp()
    }

    // MARK: - revamp 用户资料

    private func revamp(_ params: [String: String]) {
        LoginBridge.revampUserInfo(params) { [weak self] sexText, birthday, role in
            guard let self = self else { return }
            self.sexLab.text = sexText
            self.birthLab.text = birthday
            self.roleLab.text = role
        }
    }
}

// MARK: - UITextFieldDelegate

extension ProfileSetupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nickField.resignFirstResponder()
        return true
    }
}

// MARK: - 头像选择 / 上传

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func presentAvatarSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "拍照", style: .default) { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                let a = UIAlertController(title: "提示", message: "您没有摄像头!", preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "确定", style: .cancel))
                self.present(a, animated: true); return
            }
            self.presentPicker(source: .camera)
        })
        sheet.addAction(UIAlertAction(title: "从手机相册选择", style: .default) { _ in
            self.presentPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(sheet, animated: true)
    }

    private func presentPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true); return
        }
        avatarImg.image = image
        avatarUploaded = true
        uploadAvatar(image)
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func uploadAvatar(_ image: UIImage) {
        let token = LoginBridge.currentToken() ?? ""
        let urlStr = "\(DATAAPI ?? "")iumobile/apis/index.php?action=avatar&token=\(token)"
        HUDHelper2.sharedInstance().syncLoading("正在上传头像")

        var parts: [RootHttpMultipartPart] = []
        if let data = image.jpegData(compressionQuality: 0.0) {
            parts.append(RootHttpMultipartPart(data: data, name: "avatar", fileName: "avatar.png", mimeType: "image/png"))
        }
        RootHttpHelper.shared().uploadURL(urlStr, parameters: nil, parts: parts, success: { [weak self] _, responseObject in
            guard let self = self else { return }
            let dict = responseObject as? [AnyHashable: Any]
            if (dict?["code"] as? NSNumber)?.intValue == 200 {
                let msg = dict?["api_msg"] as? String ?? "上传头像成功"
                MessageHelper().showSuccessMessage(self, title: "", sub: msg)
            } else {
                let msg = dict?["api_msg"] as? String ?? "上传头像失败"
                MessageHelper().showWarnMessage(self, title: "", sub: msg)
            }
            HUDHelper2.sharedInstance().syncStopLoading()
        }, failure: { _, _ in
            HUDHelper2.sharedInstance().syncStopLoading()
        })
    }
}
