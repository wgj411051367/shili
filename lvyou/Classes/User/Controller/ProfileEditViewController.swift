//
//  ProfileEditViewController.swift
//  编辑资料：只保留头像、昵称、ID。
//

import UIKit
import SDWebImage

@objc(ProfileEditViewController)
final class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, XYNickNameControllerDelegate {

    @objc var userInfoModel: UserInfoModel?

    private let scroll = UIScrollView()
    private let avatarImg = UIImageView()
    private var valueLabels: [Int: UILabel] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground
        buildForm()
        setUserInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUserInfo()
    }

    // MARK: - 表单 UI

    private func buildForm() {
        scroll.frame = view.bounds
        scroll.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scroll.backgroundColor = .groupTableViewBackground
        view.addSubview(scroll)

        var y: CGFloat = 8
        let avatarRow = makeRowBase(tag: 10001, y: y, height: 80)
        let titleA = UILabel(frame: CGRect(x: 15, y: 0, width: 120, height: 80))
        titleA.text = "头像"
        titleA.textColor = .darkText
        avatarRow.addSubview(titleA)
        avatarImg.frame = CGRect(x: view.bounds.width - 15 - 30 - 60, y: 10, width: 60, height: 60)
        avatarImg.contentMode = .scaleAspectFill
        avatarImg.clipsToBounds = true
        avatarImg.layer.cornerRadius = 30
        avatarRow.addSubview(avatarImg)
        addArrow(to: avatarRow, height: 80)
        y += 80 + 1

        let rows: [(Int, String)] = [
            (10002, "昵称"),
            (10003, "ID"),
        ]
        for (tag, title) in rows {
            let row = makeRowBase(tag: tag, y: y, height: 50)
            let t = UILabel(frame: CGRect(x: 15, y: 0, width: 120, height: 50))
            t.text = title
            t.textColor = .darkText
            t.font = .systemFont(ofSize: 15)
            row.addSubview(t)
            let v = UILabel(frame: CGRect(x: 130, y: 0, width: view.bounds.width - 130 - 40, height: 50))
            v.textAlignment = .right
            v.textColor = .gray
            v.font = .systemFont(ofSize: 14)
            row.addSubview(v)
            valueLabels[tag] = v
            addArrow(to: row, height: 50)
            y += 50 + 1
        }
        scroll.contentSize = CGSize(width: view.bounds.width, height: y + 20)
    }

    private func makeRowBase(tag: Int, y: CGFloat, height: CGFloat) -> UIView {
        let row = UIView(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height))
        row.backgroundColor = .white
        scroll.addSubview(row)
        let btn = UIButton(type: .custom)
        btn.frame = row.bounds
        btn.tag = tag
        btn.addTarget(self, action: #selector(onRow(_:)), for: .touchUpInside)
        row.addSubview(btn)
        return row
    }

    private func addArrow(to row: UIView, height: CGFloat) {
        let arrow = UIImageView(image: UIImage(named: "icon_user_back_gray"))
        arrow.frame = CGRect(x: row.bounds.width - 20, y: (height - 13) / 2, width: 8, height: 13)
        arrow.isUserInteractionEnabled = false
        row.addSubview(arrow)
    }

    // MARK: - 赋值

    private func setUserInfo() {
        guard let m = userInfoModel else { return }
        avatarImg.sd_setImage(with: avatarURL(m.id, m.update_avatar_time))
        valueLabels[10002]?.text = m.nickname
        let uid = (m.unique_id?.isEmpty == false) ? m.unique_id : m.haoma
        valueLabels[10003]?.text = uid
    }

    @objc private func onRow(_ sender: UIButton) {
        switch sender.tag {
        case 10001: editAvatar()
        case 10002: pushNickname()
        case 10003: editID()
        default: break
        }
    }

    // MARK: - 网络

    private func requestUserInfo() {
        RootHttpHelper.shared().achieveCommonGetURL(users_info, andController: nil, andView: nil, andParams: nil) { [weak self] data in
            self?.userInfoModel = (try? UserInfoModel(dictionary: data)) ?? self?.userInfoModel
            self?.setUserInfo()
        }
    }

    private func revamp(_ params: NSMutableDictionary) {
        RootHttpHelper.shared().achieveCommonPostURL(revamp_users, andController: nil, andView: nil, andParams: params) { [weak self] data in
            guard let self = self else { return }
            MessageHelper().showSuccessMessage(self, title: nil, sub: "上传成功")
            self.userInfoModel = (try? UserInfoModel(dictionary: data)) ?? self.userInfoModel
            self.setUserInfo()
        }
    }

    // MARK: - 头像

    private func editAvatar() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "拍照", style: .default) { _ in self.pickImage(.camera) })
        sheet.addAction(UIAlertAction(title: "从手机相册选择", style: .default) { _ in self.pickImage(.photoLibrary) })
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(sheet, animated: true)
    }

    private func pickImage(_ source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            MessageHelper().showMessage(self, title: "提示", sub: "无法访问"); return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage, let data = image.jpegData(compressionQuality: 1) else { return }
        let urlStr = "\(DATAAPI)v4/apply/tmpUpload"
        HUDHelper2.sharedInstance().syncLoading("正在上传图片")
        let part = RootHttpMultipartPart(data: data, name: "avatar", fileName: "avatar.png", mimeType: "image/png")
        RootHttpHelper.shared().uploadURL(urlStr, parameters: nil, parts: [part], success: { [weak self] _, responseObject in
            guard let self = self else { return }
            HUDHelper2.sharedInstance().syncStopLoading()
            let dict = responseObject as? [AnyHashable: Any] ?? [:]
            if (dict["api_code"] as? NSNumber)?.intValue == 200 {
                let a = UIAlertController(title: nil, message: "小主，头像审核中，审核通过后展示新的头像", preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "确定", style: .default))
                self.present(a, animated: true)
            } else {
                MessageHelper().showWarnMessage(self, title: "", sub: dict["api_msg"] as? String ?? "上传头像失败")
            }
        }, failure: { _, _ in
            HUDHelper2.sharedInstance().syncStopLoading()
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }

    // MARK: - 昵称 / ID

    private func pushNickname() {
        let vc = NicknameEditViewController()
        vc.delegate = self
        vc.navigationItem.title = "昵称"
        vc.hidesBottomBarWhenPushed = true
        vc.name = valueLabels[10002]?.text
        navigationController?.pushViewController(vc, animated: true)
    }

    private func editID() {
        let alert = UIAlertController(title: "修改ID", message: nil, preferredStyle: .alert)
        alert.addTextField { [weak self] tf in
            tf.text = self?.valueLabels[10003]?.text
            tf.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "保存", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !text.isEmpty else { return }
            self.revamp(["unique_id": text])
        })
        present(alert, animated: true)
    }

    func nickNameController(_ nickNameVC: NicknameEditViewController, withUserInfoModel model: UserInfoModel) {
        userInfoModel = model
        setUserInfo()
    }

    private func avatarURL(_ uid: String?, _ update: String?) -> URL? {
        guard let uid = uid, !uid.isEmpty else { return nil }
        let s = "\(IMAGEAPI ?? "")/apis/avatar.php?uid=\(uid)&update=\(update ?? "")"
        return URL(string: s.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? s)
    }
}
