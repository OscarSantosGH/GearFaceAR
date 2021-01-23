//
//  FilterButton.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 1/22/21.
//

import UIKit

enum FilterType{
    case skin
    case chin
    case eyes
    case circle
    case nose
    case mouth
}

class FilterButton: UIButton {

    var filterValue: Float = 0.0
    var filterType: FilterType = FilterType.skin

}
