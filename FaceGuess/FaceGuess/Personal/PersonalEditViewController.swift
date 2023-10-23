//
//  PersonalEditViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/22.
//

import UIKit
class PersonalEditViewController: BaseViewController {
    private var userName:String = "柳青青"
    private let avatorImageView = UIImageView.init(image:UIImage(named: "2"))
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.backgroundColor = .black
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        return table
    }()
}
extension PersonalEditViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        // 使用 SF Symbols 图标作为箭头
        let arrowImage = UIImage(systemName: "chevron.right")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let arrowImageView = UIImageView(image: arrowImage)
        cell.accessoryView = arrowImageView
        // 移除所有子视图以重用
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        if indexPath.row == 0 {
            titleLabel.text = "头像"
        } else if indexPath.row == 1 {
            titleLabel.text = "昵称"
        }
        
        cell.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16) // 16pt左边距
            make.centerY.equalToSuperview()
        }
        
        let detailLable = UILabel()
        detailLable.textColor = .white
        detailLable.font = UIFont.systemFont(ofSize: 15)
        cell.contentView.addSubview(detailLable)
        detailLable.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16) // 16pt左边距
            make.centerY.equalToSuperview()
        }
        // 如果是头像栏，我们可以添加图像视图
        if indexPath.row == 0 {
            avatorImageView.contentMode = .scaleAspectFill
            avatorImageView.clipsToBounds = true
            avatorImageView.layer.cornerRadius = 20 // 设定头像半径
            if !cell.contentView.subviews.contains(where: { $0 is UIImageView && $0.tag == 100 }) {
                avatorImageView.tag = 100 // 给 avatorImageView 设置一个唯一的标签值
                cell.contentView.addSubview(avatorImageView)
            }

            avatorImageView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16) // 16pt右边距
                make.centerY.equalToSuperview()
                make.width.height.equalTo(40) // 设定头像大小
            }
        }
        if indexPath.row == 1{
            detailLable.text = userName
        }
        
        // 添加1pt的白线在底部
        let separatorView = UIView()
        separatorView.backgroundColor = .gray
        cell.contentView.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(0.5)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 这里处理点击事件
        if indexPath.row == 0 {
            changeAvatarButtonTapped()
        } else if indexPath.row == 1 {
            let alert = TextDislogView(frame: CGRect(x: 40, y: (view.frame.height - 200) / 2, width: view.frame.width - 80, height: 150))
            view.addSubview(alert)
            alert.onSave = { [weak self] text in
                guard let self = self else { return  }
                // 在这里你可以获取到输入框的值
                if text.count > 0 {
                    self.userName = text
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 // 或其他您想要的高度
    }
}

extension PersonalEditViewController:UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    func changeAvatarButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "更改头像", message: "从哪里选择图片？", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action: UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "相机", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("相机不可用")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            avatorImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
