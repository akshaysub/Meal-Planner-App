//
//  MealPlanner.swift
//  MealPlanner
//
//  Created by Akshay Subramaniam
//

import Foundation

class Meal {
    var name: String
    var ingredients: [String]
    
    init(name: String, ingredients: [String]) {
        self.name = name
        self.ingredients = ingredients
    }
}
/*
class MealPlanner {
    var meals: [Meal] = []
    
    func addMeal(name: String, ingredients: [String]) {
        let meal = Meal(name: name, ingredients: ingredients)
        meals.append(meal)
    }
    
    func generatePlan(numMeals: Int) -> [Meal] {
        var plan: [Meal] = []
        for _ in 0..<numMeals {
            let randomIndex = Int.random(in: 0..<meals.count)
            let meal = meals[randomIndex]
            plan.append(meal)
        }
        return plan
    }
}
*/
