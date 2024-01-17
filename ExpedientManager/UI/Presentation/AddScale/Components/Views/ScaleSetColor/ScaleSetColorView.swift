//
//  ScaleSetColorView.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 11/22/24.
//

import Foundation
import UIKit

enum SelectedCaseColor {
    case blue
    case pink
    case green
    case purple
    case orange
}

extension UIColor {
    static var appBlue: UIColor {
        UIColor(hex: "#0000FF")
    }
    static var appPink: UIColor {
        UIColor(hex: "#FF2D55")
    }
    static var appGreen: UIColor {
        UIColor(hex: "#00FF00")
    }
    static var appPurple: UIColor {
        UIColor(hex: "#800080")
    }
    static var appOrange: UIColor {
        UIColor(hex: "#FF8000")
    }
}

extension SelectedCaseColor: RawRepresentable {
    typealias RawValue = UIColor
    
    init?(rawValue: UIColor) {
        switch rawValue {
        case .appBlue:
            self = .blue
        case .appPink:
            self = .pink
        case .appGreen:
            self = .green
        case .appPurple:
            self = .purple
        case .appOrange:
            self = .orange
        default:
            self = .blue
        }
    }
    
    var rawValue: UIColor {
        switch self {
        case .blue:
            return .appBlue
        case .pink:
            return .appPink
        case .green:
            return .appGreen
        case .purple:
            return .appPurple
        case .orange:
            return .appOrange
        }
    }
}

class ScaleSetColorView: UIView {
    
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    @IBOutlet weak var selectedPinkView: UIView!
    @IBOutlet weak var selectedGreenView: UIView!
    @IBOutlet weak var selectedPurpleView: UIView!
    @IBOutlet weak var selectedOrangeView: UIView!
    @IBOutlet weak var selectedBlueView: UIView!

    let brandingColor: String = "brandingColor"
    var selectedColor: UIColor = .clear
    
    required init?(coder: NSCoder) {
         super.init(coder: coder)
        loadView()
        setupUI()
     }
}

extension ScaleSetColorView {
    @IBAction func selectColor(sender: UIButton){
        switch sender {
        case blueButton:
            setColor(.blue)
        case pinkButton:
            setColor(.pink)
        case greenButton:
            setColor(.green)
        case purpleButton:
            setColor(.purple)
        case orangeButton:
            setColor(.orange)
        default:
            break
        }
    }
}

extension ScaleSetColorView {
    private func setupUI() {
        blueButton.setTitle("", for: .normal)
        pinkButton.setTitle("", for: .normal)
        greenButton.setTitle("", for: .normal)
        purpleButton.setTitle("", for: .normal)
        orangeButton.setTitle("", for: .normal)
        setupSelectView()
    }
    
    private func setupSelectView(){
        selectedBlueView.layer.borderColor = UIColor.init(named: brandingColor)?.cgColor
        selectedPinkView.layer.borderColor = UIColor.init(named: brandingColor)?.cgColor
        selectedGreenView.layer.borderColor = UIColor.init(named: brandingColor)?.cgColor
        selectedPurpleView.layer.borderColor = UIColor.init(named: brandingColor)?.cgColor
        selectedOrangeView.layer.borderColor = UIColor.init(named: brandingColor)?.cgColor
        
        selectedBlueView.layer.borderWidth = 2
        selectedPinkView.layer.borderWidth = 2
        selectedGreenView.layer.borderWidth = 2
        selectedPurpleView.layer.borderWidth = 2
        selectedOrangeView.layer.borderWidth = 2
        
        selectedBlueView.isHidden = true
        selectedPinkView.isHidden = true
        selectedGreenView.isHidden = true
        selectedPurpleView.isHidden = true
        selectedOrangeView.isHidden = true
    }
    
    func setColor(_ color: SelectedCaseColor) {
        selectedColor = color.rawValue
        
        switch color  {
        case .blue:
            selectedBlueView.isHidden = false
            selectedPinkView.isHidden = true
            selectedGreenView.isHidden = true
            selectedPurpleView.isHidden = true
            selectedOrangeView.isHidden = true
        case .pink:
            selectedBlueView.isHidden = true
            selectedPinkView.isHidden = false
            selectedGreenView.isHidden = true
            selectedPurpleView.isHidden = true
            selectedOrangeView.isHidden = true
        case .green:
            selectedPinkView.isHidden = true
            selectedBlueView.isHidden = true
            selectedGreenView.isHidden = false
            selectedPurpleView.isHidden = true
            selectedOrangeView.isHidden = true
        case .purple:
            selectedBlueView.isHidden = true
            selectedPinkView.isHidden = true
            selectedGreenView.isHidden = true
            selectedPurpleView.isHidden = false
            selectedOrangeView.isHidden = true
        case .orange:
            selectedBlueView.isHidden = true
            selectedPinkView.isHidden = true
            selectedGreenView.isHidden = true
            selectedPurpleView.isHidden = true
            selectedOrangeView.isHidden = false
        }
    }
    
    private func loadView() {
        let bundle = Bundle(for: ScaleSetColorView.self)
        let nib = UINib(nibName: "ScaleSetColorView", bundle: bundle)
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
