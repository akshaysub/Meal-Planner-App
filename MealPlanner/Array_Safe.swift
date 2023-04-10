//
//  Array_Safe.swift
//  MealPlanner
//
//  Created by Akshay Subramaniam on 3/30/23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
