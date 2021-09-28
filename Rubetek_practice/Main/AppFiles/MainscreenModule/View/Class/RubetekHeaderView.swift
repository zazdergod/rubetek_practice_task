//
//  RubetekHeaderView.swift
//  Rubetek_practice
//
//  Created by Ilya Buzyrev on 28.09.2021.
//

import UIKit

class RubetekHeaderView: UIView {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var firstSegment: UIButton!
    @IBOutlet weak var firstSegmentLine: UIView!
    @IBOutlet weak var secondSegment: UIButton!
    @IBOutlet weak var secondSegmentLine: UIView!
    
    private var firstSegmentTap: (() -> Void)?
    private var secondSegmentTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let viewFromXib = Bundle.main.loadNibNamed("RubetekHeaderView", owner: self, options: nil)?[0] as? UIView else { return }
        print(viewFromXib)
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }
    
    public func setupView(title: String, firstSegmentTitle: String, secondSegmentTitle: String, firstSegmentTap: @escaping () -> Void, secondSegmentTap: @escaping () -> Void) {
        headerTitle.text = title
        firstSegment.setTitle(firstSegmentTitle, for: .normal)
        secondSegment.setTitle(secondSegmentTitle, for: .normal)
        self.firstSegmentTap = firstSegmentTap
        self.secondSegmentTap = secondSegmentTap
        secondSegmentLine.isHidden = true
    }
    
    @IBAction func tapFirstSegment(_ sender: Any) {
        firstSegmentLine.isHidden = false
        secondSegmentLine.isHidden = true
        firstSegmentTap?()
    }
    
    
    @IBAction func tapSecondSegment(_ sender: Any) {
        firstSegmentLine.isHidden = true
        secondSegmentLine.isHidden = false
        secondSegmentTap?()
    }
}
