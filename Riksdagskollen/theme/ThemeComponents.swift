//
//  ThemeComponents.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-12.
//

import Foundation
import UIKit

// label used inside primary color
class AccentLabel: UILabel{}

// Label used for displaying titles
class TitleLabel: UILabel{}

// Label used for displaying body text
class BodyLabel: UILabel{}

// Label used for displaying subtitles with little significance
class SubtitleLabel: UILabel{}

// All purpose view with themed background color
class ThemedView: UIView{}

// Wrapper view for the drawer header
class DrawerHeaderView: UIView{}

// Icon that is filled with accent color
class AccentIcon: UIImageView{
    @objc dynamic var fillColor: UIColor? {
          get { return self.tintColor }
          set { self.setImageColor(color: newValue!) }
      }
}

class TabBarCollectionView: UICollectionView{}

class CurrentTabIndicatorView: UIView{}

// Separator between views with accentColor
class SeparatorView: UIView {}

class CardView: UIView {
    override var bounds: CGRect {
        didSet {
            setupView()
        }
    }
    
    private func setupView() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 16
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 16, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}



