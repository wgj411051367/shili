//
//  PasswordResetViewController.swift
//  重置密码页（Swift 重写，替代原 OC 版 + xib）。
//
//  UI 代码 + Auto Layout 重建（删 xib）。视觉对齐原 xib：白底、关闭按钮、
//  "重置密码"标题、账号/验证码/密码三个下划线输入框、验证码倒计时按钮、
//  全宽粉色圆角"完成"按钮。成功后回调 OC 的 UserResetDelegate（定义在 Constants.h）。
//

import UIKit

@objc(PasswordResetViewController)
final class PasswordResetViewController: UIViewController {

    /// 复用 Constants.h 里已有的 OC 协议，OC 调用方（UserGuideLoginVC）已实现
    @objc weak var delegate: UserResetDelegate?

    private let pink = UIColor(red: 1.0, green: 91.0/255.0, blue: 135.0/255.0, alpha: 1)      // colorHead 0xFF5B87
    private let underlineGray = UIColor(red: 0.902, green: 0.902, blue: 0.902, alpha: 1)
    private let codeBlue = UIColor(red: 0x20/255.0, green: 0x9D/255.0, blue: 0xFF/255.0, alpha: 1)  // 0x209DFF
    private let titleBlack = UIColor(white: 0.02, alpha: 1)

    private let mobileField = UITextField()
    private let codeField = UITextField()
    private let passwordField = UITextField()
    private let codeButton = UIButton(type: .system)
    private let finishButton = UIButton(type: .system)

    private var timer: Timer?
    private var second = 60

    deinit { timer?.invalidate() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildUI()
        configureFields()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        cleanText()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - UI

    private func buildUI() {
        let safe = view.safeAreaLayoutGuide

        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "login_close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        closeButton.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)

        let titleLabel = UILabel()
        titleLabel.text = "重置密码"
        titleLabel.textColor = titleBlack
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 24) ?? .systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let mobileRow = makeFieldRow(field: mobileField, placeholder: "请输入账号")
        let codeRow = makeFieldRow(field: codeField, placeholder: "请输入验证码")
        let passwordRow = makeFieldRow(field: passwordField, placeholder: "请输入密码")
        [mobileRow, codeRow, passwordRow].forEach { view.addSubview($0) }

        codeButton.setTitle("获取验证码", for: .normal)
        codeButton.setTitleColor(codeBlue, for: .normal)
        codeButton.titleLabel?.font = .systemFont(ofSize: 12)
        codeButton.addTarget(self, action: #selector(onGetCode), for: .touchUpInside)
        codeButton.translatesAutoresizingMaskIntoConstraints = false
        codeRow.addSubview(codeButton)

        finishButton.setTitle("完成", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 20) ?? .systemFont(ofSize: 20)
        finishButton.backgroundColor = pink
        finishButton.layer.cornerRadius = 20
        finishButton.layer.masksToBounds = true
        finishButton.addTarget(self, action: #selector(onFinish), for: .touchUpInside)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finishButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 52),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),

            mobileRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 37),
            mobileRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mobileRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -67),

            codeRow.topAnchor.constraint(equalTo: mobileRow.bottomAnchor, constant: 24),
            codeRow.leadingAnchor.constraint(equalTo: mobileRow.leadingAnchor),
            codeRow.trailingAnchor.constraint(equalTo: mobileRow.trailingAnchor),

            passwordRow.topAnchor.constraint(equalTo: codeRow.bottomAnchor, constant: 24),
            passwordRow.leadingAnchor.constraint(equalTo: mobileRow.leadingAnchor),
            passwordRow.trailingAnchor.constraint(equalTo: mobileRow.trailingAnchor),

            codeButton.trailingAnchor.constraint(equalTo: codeRow.trailingAnchor),
            codeButton.centerYAnchor.constraint(equalTo: codeField.centerYAnchor),

            // 完成按钮：全宽（leading 30 / trailing 30）
            finishButton.topAnchor.constraint(equalTo: passwordRow.bottomAnchor, constant: 45),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            finishButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func makeFieldRow(field: UITextField, placeholder: String) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false

        field.placeholder = placeholder
        field.font = .systemFont(ofSize: 15)
        field.clearButtonMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(field)

        let underline = UIView()
        underline.backgroundColor = underlineGray
        underline.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(underline)

        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: row.topAnchor),
            field.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            field.heightAnchor.constraint(equalToConstant: 21),

            underline.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 15),
            underline.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.bottomAnchor.constraint(equalTo: row.bottomAnchor),
        ])
        return row
    }

    private func configureFields() {
        mobileField.keyboardType = .numberPad
        mobileField.delegate = self
        codeField.keyboardType = .numberPad
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        passwordField.delegate = self
        codeButton.isEnabled = false
    }

    // MARK: - 校验

    /// 返回校验通过的 (mobile, pass, code)，不通过则提示并返回 nil
    private func validatedInputs() -> (String, String, String)? {
        let username = mobileField.text ?? ""
        let pass = passwordField.text ?? ""
        let code = codeField.text ?? ""
        if username.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "手机号码不能为空"); return nil
        }
        if pass.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "密码不能为空"); return nil
        }
        if pass.count < 6 {
            MessageHelper().showMessage(self, title: "", sub: "密码不能小于6位"); return nil
        }
        if code.isEmpty {
            MessageHelper().showMessage(self, title: "", sub: "短信验证码不能为空"); return nil
        }
        return (username, pass, code)
    }

    private func submitReset() {
        view.endEditing(true)
        guard let (username, pass, code) = validatedInputs() else { return }
        let params = NSMutableDictionary()
        params.setValue(username, forKey: "mobile")
        params.setValue(code, forKey: "code")
        params.setValue(pass, forKey: "password")
        RootHttpHelper.shared().achieveCommonPostURL(
            users_reset_pwd, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue == 200 {
                MessageHelper().showSuccessMessage(self, title: "", sub: "重置密码成功!")
                self.closeSelf()
                self.delegate?.userResetSucceed(username, andType: 1)
            }
        }
    }

    // MARK: - 动作

    @objc private func onClose() { closeSelf() }

    /// push 进来的页：关闭 = 返回上一级（对应原 OC dismiss = pop）
    private func closeSelf() {
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func onFinish() { submitReset() }

    @objc private func onGetCode() {
        codeField.text = ""
        guard let mobile = mobileField.text, !mobile.isEmpty else {
            MessageHelper().showMessage(self, title: "", sub: "手机号码不能为空"); return
        }
        let params = NSMutableDictionary()
        params.setValue(mobile, forKey: "mobile")
        params.setValue("findpwd", forKey: "from")   // 找回密码场景
        RootHttpHelper.shared().achieveCommonPostURL(
            users_code, andController: self, andView: view, andParams: params
        ) { [weak self] successData in
            guard let self = self else { return }
            if (successData["api_code"] as? NSNumber)?.intValue == 200 {
                MessageHelper().showSuccessMessage(self, title: "", sub: successData["data"] as? String ?? "")
                self.startCountdown()
                self.codeField.becomeFirstResponder()
            }
        }
    }

    // MARK: - 倒计时

    private func startCountdown() {
        timer?.invalidate()
        second = 60
        codeButton.isEnabled = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        second -= 1
        if second <= 0 {
            codeButton.setTitle("获取验证码", for: .normal)
            codeButton.isEnabled = true
            timer?.invalidate()
            second = 60
        } else {
            codeButton.setTitle("\(second)s", for: .normal)
            codeButton.isEnabled = false
        }
    }

    private func cleanText() {
        mobileField.text = ""
        codeField.text = ""
        passwordField.text = ""
        timer?.invalidate()
    }
}

// MARK: - UITextFieldDelegate

extension PasswordResetViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mobileField {
            if timer == nil || !(timer?.isValid ?? false) {
                codeButton.isEnabled = true
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submitReset()
        return true
    }
}
