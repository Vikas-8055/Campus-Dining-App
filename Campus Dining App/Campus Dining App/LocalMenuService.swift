// Updated LocalMenuService.swift with dietaryInfo added
enum LocalMenuService {
  static let all: [String: [LocalMenuItem]] = [

    "1": [
      .init(id: "1-1", restaurantID: "1", name: "Chicken (Protein Only)", description: "Humanely Raised", price: 8.99, imageName: "choolah_chicken", dietaryInfo: ["Halal"]),
      .init(id: "1-2", restaurantID: "1", name: "Lamb", description: "Halal Friendly", price: 10.49, imageName: "choolah_lamb", dietaryInfo: ["Halal"]),
      .init(id: "1-3", restaurantID: "1", name: "Salmon", description: "Non-GMO", price: 11.99, imageName: "choolah_salmon", dietaryInfo: ["Pescatarian"]),
      .init(id: "1-4", restaurantID: "1", name: "Paneer", description: "Artisan Cheese", price: 8.99, imageName: "choolah_paneer", dietaryInfo: ["Vegetarian"]),
      .init(id: "1-5", restaurantID: "1", name: "Veg Croquettes", description: "Lentils & Veggies", price: 8.99, imageName: "choolah_croquettes", dietaryInfo: ["Vegan", "Gluten-Free"]),
      .init(id: "1-6", restaurantID: "1", name: "Tofu", description: "Organic", price: 8.49, imageName: "choolah_tofu", dietaryInfo: ["Vegan"]),
      .init(id: "1-7", restaurantID: "1", name: "Roasted Veggies", description: "Fresh Cut", price: 6.99, imageName: "choolah_veggies", dietaryInfo: ["Vegan", "Gluten-Free"])
    ],

    "2": [
      .init(id: "2-1", restaurantID: "2", name: "Margherita Pizza", description: "Fresh mozzarella & basil", price: 13.00, imageName: "dangelo_margherita", dietaryInfo: ["Vegetarian"]),
      .init(id: "2-2", restaurantID: "2", name: "White Pizza", description: "Ricotta & parmesan", price: 13.00, imageName: "dangelo_white", dietaryInfo: ["Vegetarian"]),
      .init(id: "2-3", restaurantID: "2", name: "House Sicilian", description: "Sauce on top, cheese bottom", price: 15.00, imageName: "dangelo_sicilian", dietaryInfo: ["Vegetarian"]),
      .init(id: "2-4", restaurantID: "2", name: "Garbage Pie", description: "All meats & veggies", price: 19.00, imageName: "dangelo_garbage", dietaryInfo: ["Halal"]),
      .init(id: "2-5", restaurantID: "2", name: "Meat Lovers", description: "Pepperoni, bacon & sausage", price: 18.00, imageName: "dangelo_meatlovers", dietaryInfo: ["Halal"]),
      .init(id: "2-6", restaurantID: "2", name: "Mediterranean Pie", description: "Feta, olives & tomato", price: 18.00, imageName: "dangelo_mediterranean", dietaryInfo: ["Vegetarian"]),
      .init(id: "2-7", restaurantID: "2", name: "Vegetarian Pizza", description: "Mushrooms, peppers & olives", price: 18.00, imageName: "dangelo_vegetarian", dietaryInfo: ["Vegetarian"])
    ],

    "3": [
      .init(id: "3-1", restaurantID: "3", name: "Chicken", description: "175 cal", price: 11.99, imageName: "halal_chicken", dietaryInfo: ["Halal"]),
      .init(id: "3-2", restaurantID: "3", name: "Beef", description: "450 cal", price: 11.99, imageName: "halal_beef", dietaryInfo: ["Halal"]),
      .init(id: "3-3", restaurantID: "3", name: "Mix (Chicken + Beef)", description: "310 cal", price: 11.99, imageName: "halal_mix", dietaryInfo: ["Halal"]),
      .init(id: "3-4", restaurantID: "3", name: "Hot BBQ Chicken", description: "205 cal", price: 11.99, imageName: "halal_bbq", dietaryInfo: ["Halal"]),
      .init(id: "3-5", restaurantID: "3", name: "Falafel", description: "200 cal (veg)", price: 11.49, imageName: "halal_falafel", dietaryInfo: ["Vegan"]),
      .init(id: "3-6", restaurantID: "3", name: "Chickpea Korma", description: "200 cal (veg)", price: 11.99, imageName: "halal_chickpea", dietaryInfo: ["Vegan", "Gluten-Free"]),
      .init(id: "3-7", restaurantID: "3", name: "Impossible", description: "175 cal (veg)", price: 12.49, imageName: "halal_impossible", dietaryInfo: ["Vegan"])
    ],

    "4": [
      .init(id: "4-1", restaurantID: "4", name: "Ghost Pepper Chicken w/ Bacon & Cheese", description: "871–2212 cal", price: 11.99, imageName: "popeyes_ghost_bacon", dietaryInfo: ["Halal"]),
      .init(id: "4-2", restaurantID: "4", name: "Golden BBQ Chicken Sandwich Combo", description: "730–2070 cal", price: 10.49, imageName: "popeyes_bbq", dietaryInfo: ["Halal"]),
      .init(id: "4-3", restaurantID: "4", name: "Classic Chicken Sandwich Combo", description: "810–2253 cal", price: 10.49, imageName: "popeyes_classic", dietaryInfo: ["Halal"]),
      .init(id: "4-4", restaurantID: "4", name: "Spicy Chicken Sandwich Combo", description: "810–2150 cal", price: 10.49, imageName: "popeyes_spicy", dietaryInfo: ["Halal"]),
      .init(id: "4-5", restaurantID: "4", name: "Ghost Pepper Chicken Sandwich Combo", description: "741–2082 cal", price: 10.49, imageName: "popeyes_ghost", dietaryInfo: ["Halal"]),
      .init(id: "4-6", restaurantID: "4", name: "Side of Fries", description: "", price: 2.49, imageName: "popeyes_fries", dietaryInfo: ["Vegetarian", "Gluten-Free"]),
      .init(id: "4-7", restaurantID: "4", name: "Biscuits (2pcs)", description: "", price: 2.49, imageName: "popeyes_biscuits", dietaryInfo: ["Vegetarian"])
    ],

    "5": [
      .init(id: "5-1", restaurantID: "5", name: "Rotisserie-Style Chicken", description: "350 cal (6″) • 690 cal (ft)", price: 4.75, imageName: "subway_rotisserie", dietaryInfo: ["Halal"]),
      .init(id: "5-2", restaurantID: "5", name: "Carved Turkey", description: "330 cal (6″) • 670 cal", price: 4.75, imageName: "subway_turkey", dietaryInfo: ["Halal"]),
      .init(id: "5-3", restaurantID: "5", name: "Roast Beef", description: "320 cal • 630 cal", price: 4.75, imageName: "subway_roastbeef", dietaryInfo: ["Halal"]),
      .init(id: "5-4", restaurantID: "5", name: "Subway Club®", description: "310 cal • 630 cal", price: 4.25, imageName: "subway_club", dietaryInfo: ["Halal"]),
      .init(id: "5-5", restaurantID: "5", name: "Oven Roasted Chicken", description: "320 cal • 640 cal", price: 4.25, imageName: "subway_ovenroasted", dietaryInfo: ["Halal"]),
      .init(id: "5-6", restaurantID: "5", name: "Turkey Breast", description: "280 cal • 560 cal", price: 4.25, imageName: "subway_turkeybreast", dietaryInfo: ["Halal"]),
      .init(id: "5-7", restaurantID: "5", name: "Black Forest Ham", description: "290 cal • 570 cal", price: 3.75, imageName: "subway_blackforest", dietaryInfo: ["Halal"])
    ]
  ]
}
