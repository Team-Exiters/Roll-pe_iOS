//
//  AutoHeightTableView.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/7/25.
//

import Foundation
import UIKit

class AutoHeightTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func setup() {
        self.rowHeight = UITableView.automaticDimension
    }
}
