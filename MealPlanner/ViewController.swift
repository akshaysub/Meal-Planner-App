//
//  ViewController.swift
//  MealPlanner
//
//  Created by Akshay Subramaniam
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mealNameField: UITextField!
    @IBOutlet weak var mealIngredientsField: UITextField!
    @IBOutlet weak var mealCountField: UITextField!
    @IBOutlet weak var mealPlanScrollView: UIScrollView!
    
    
    // for storing user's meals and authentication
    private let database = Database.database().reference()
    private let auth = Auth.auth()
    
    var meals: [String] = []
    var mealIngredients: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if the user has launched the app before and added meals
        if let user = auth.currentUser {
            let userId = user.uid
            
            // loads user's meals from the database
            database.child("users").child(userId).child("meals").observeSingleEvent(of: .value, with: {
                snapshot in
                guard snapshot.value is [String] else {
                    return
                }
                
                self.meals = snapshot.value as! [String]
            })
            
            // loads user's meal ingredients from the database
            database.child("users").child(userId).child("mealIngredients").observeSingleEvent(of: .value, with: {
                snapshot in
                guard snapshot.value is [String] else {
                    return
                }
                
                self.mealIngredients = snapshot.value as! [String]
            })
        }
        
        //if the user is launching the app for the first time
        else {
            auth.signInAnonymously { authResult, error in
                if let error = error {
                    print("Failed to sign in anonymously: \(error)")
                    return
                }
                
                // creates a new anonymous user sign-in
                
                guard let user = authResult?.user else {
                    print("Failed to retrieve user information after anonymous sign-in.")
                    return
                }
                
                let userId = user.uid
                
                self.database.child("users").child(userId).child("meals").setValue(self.meals)
                self.database.child("users").child(userId).child("mealIngredients").setValue(self.mealIngredients)
            }
        }
    }
    
    // adds a new meal to the database when the Add Meal button is clicked
    @IBAction func addMeal(_ sender: Any) {
        if let mealName = mealNameField.text, let mealIngredients = mealIngredientsField.text {
            if mealName != "" && mealIngredients != "" {
                self.meals.append(mealName)
                self.mealIngredients.append(mealIngredients)
                mealNameField.text = ""
                mealIngredientsField.text = ""
                
                guard let currentUser = auth.currentUser else {
                    return
                }
                
                let userId = currentUser.uid
                let userRef = database.child("users").child(userId)
                
                userRef.child("meals").setValue(self.meals)
                userRef.child("mealIngredients").setValue(self.mealIngredients)
  
            }
        }
    }
    
    // generates the meal plan and displays it when the Generate Plan button is clicked
    @IBAction func generateMealPlan(_ sender: Any) {
        let mealCount = Int(mealCountField.text!) ?? 0
        
        if mealCount > 0 && meals.count >= mealCount {
            var mealPlan: [String] = []
            var selectedMeals: [String] = []
            var i = 0
            
            while i < mealCount {
                let randomIndex = Int.random(in: 0..<meals.count)
                
                if randomIndex < mealIngredients.count, let randomMeal = meals[safe: randomIndex] {
                    if !selectedMeals.contains(randomMeal) {
                        selectedMeals.append(randomMeal)
                        mealPlan.append("\(randomMeal):\n\(mealIngredients[randomIndex])")
                        i += 1
                    }
                }
            }
            
            let mealPlanTextView = UITextView(frame: CGRect(x: 0, y: 0, width: mealPlanScrollView.frame.width, height: mealPlanScrollView.frame.height))
            mealPlanTextView.text = mealPlan.joined(separator: "\n\n")
            mealPlanTextView.isEditable = false
            mealPlanTextView.font = UIFont.systemFont(ofSize: 17.0)
            mealPlanTextView.textAlignment = .center
            
            mealPlanScrollView.addSubview(mealPlanTextView)
            mealPlanScrollView.contentSize = mealPlanTextView.frame.size
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: mealPlanScrollView.frame.width, height: mealPlanScrollView.frame.height))
            messageLabel.text = "Please enter a valid meal count and add at least that many meals."
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            
            mealPlanScrollView.addSubview(messageLabel)
            mealPlanScrollView.contentSize = messageLabel.frame.size
        }
    }
}
