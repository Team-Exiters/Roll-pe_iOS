//
//  LoadingView.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/13/25.
//

import UIKit
import SnapKit

class LoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        
        let gifImageView: UIImageView = UIImageView()
        
        guard
            let gifURL = Bundle.main.url(forResource: "LoadingAnimation", withExtension: "gif"),
            let gifData = try? Data(contentsOf: gifURL),
            let source = CGImageSourceCreateWithData(gifData as CFData, nil),
            let firstFrame = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else { return }
        
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()

        (0..<frameCount)
            .compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
            .forEach { images.append(UIImage(cgImage: $0)) }

        gifImageView.animationImages = images
        gifImageView.animationDuration = 1
        gifImageView.animationRepeatCount = 0
        gifImageView.startAnimating()
        
        let gifWidth = CGFloat(firstFrame.width)
        let gifHeight = CGFloat(firstFrame.height)
        let gifAspectRatio = gifHeight / gifWidth
        
        self.addSubview(gifImageView)
        
        gifImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalTo(gifImageView.snp.width).multipliedBy(gifAspectRatio)
            make.center.equalToSuperview()
        }
    }
}
