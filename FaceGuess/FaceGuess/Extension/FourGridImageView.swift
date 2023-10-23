import UIKit

class FourGridImageView: UIView {
    
    // 添加一个闭包作为点击回调
    var didSelectImageView: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        let gridSize = self.bounds.size.width / 2.0
        
        for index in 0..<4 {
            let row = index / 2
            let col = index % 2
            
            let imageView = UIImageView(frame: CGRect(x: CGFloat(col) * gridSize, y: CGFloat(row) * gridSize, width: gridSize, height: gridSize))
            
            // 启用用户交互
            imageView.isUserInteractionEnabled = true
            
            // 添加点击手势
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            
            // 为了方便识别，我们将tag设置为index
            imageView.tag = index
            
            // 设置图片（这里仅为了演示，使用了背景色）
            imageView.image = UIImage(named: "\(index + 1)")
            
            // 如果不是右上角的图片，则添加高斯模糊
            if index != 1 {
                let blurEffect = UIBlurEffect(style: .light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = imageView.bounds
                imageView.addSubview(blurEffectView)
            }
            
            self.addSubview(imageView)
        }
    }
    
    @objc private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            didSelectImageView?(imageView.tag)
        }
    }
}
