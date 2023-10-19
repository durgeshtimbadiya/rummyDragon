//
//  RummyGameModel.swift
//  Lets Card
//
//  Created by Durgesh on 23/01/23.
//

import SwiftyJSON

struct RummyCardModel: Equatable {
    
    static func ==(lhs: RummyCardModel, rhs: RummyCardModel) -> Bool {
        return lhs.id == rhs.id && lhs.card_id == rhs.card_id
    }
    
    var id = Int()
    var card = String()
    var cardNumber = -1
    var card_id = String()
    var isSelected = false
    var card_group = String()
    var card_suite = String()
    
    init() {    }
    init(_ json: JSON, jokerCardName: String = "") {
        if !jokerCardName.isEmpty {
            card_id = jokerCardName
            card = jokerCardName.lowercased()
        } else {
            id = json["id"].intValue
            if let cardstr = json["card"].string {
                card_id = cardstr
                card = cardstr.lowercased()
            } else if let cardstr1 = json["cards"].string {
                card_id = cardstr1
                card = cardstr1.lowercased()
            }
            card_group = json["card_group"].stringValue
        }
        if card.last == "_" {
            card.removeLast()
        }
        if card.count > 2 {
            switch String(card.dropFirst(2)) {
            case "j":
                cardNumber = 11
                break
            case "q":
                cardNumber = 12
                break
            case "k":
                cardNumber = 13
                break
            case "a":
                cardNumber = 1
                break
            default:
                if let isInt = Int(String(card.dropFirst(2))) {
                    cardNumber = isInt
                }
                break
            }
        }
        card_suite = String(card.prefix(2))
    }
    
    public static func isPureSequence(_ cards: [RummyCardModel]) -> Bool {
        /// Check If card is less then 3 is not a part of any sequence and sets
        if cards.count < 3 {
            return false
        }
        /// Sorting all cards
        let myCards = cards.sorted(by: { $0.cardNumber < $1.cardNumber })
        
        /// Get card suites
        let cardSuites = myCards.map({ $0.card_suite })
        // Make card suite set for same suites
        let cardSuitesSet = Set(cardSuites)
        // Check card suites are same or not
        let isSameSuites = cardSuitesSet.count <= 1

        /// Get card numbers
        var cardNumbers = myCards.map({ $0.cardNumber })
        // Check card number is in sequence
        var isSequence = cardNumbers.numbersAreConsecutive()
        
        if !isSequence {
            /// If card number is not in sequence check it is a A, K, Q sequence
            if cardNumbers.contains(1) && cardNumbers.contains(13), let aCardIdx = cardNumbers.firstIndex(of: 1) {
                // Change number of A card
                cardNumbers[aCardIdx] = 14
                // Again sort card to get sequence
                cardNumbers = cardNumbers.sorted(by: { $0 < $1 })
            }
            // Again Check card number if in sequence
            isSequence = cardNumbers.numbersAreConsecutive()
        }
        /// return card suites are same and is in sequence
        return isSameSuites && isSequence
    }
    
    public static func isImPureSequence(_ cards: [RummyCardModel], jokerCard: RummyCardModel) -> Bool {
        /// Check If card is less then 3 is not a part of any sequence and sets
        if cards.count < 3 {
            return false
        }
        /// Sorting all cards
        var myCards = cards.sorted(by: { $0.cardNumber < $1.cardNumber })
        
        /// Get total joker cards into the group
        var totalJokers = myCards.filter({ $0.cardNumber == jokerCard.cardNumber && $0.cardNumber != -1 }).count
        
        /// Check Joker as JK into the group
        if let jokerC = myCards.first(where: { $0.card_suite == "jk" }) {
            totalJokers += myCards.filter({ $0.card_suite == jokerC.card_suite }).count
            myCards.removeAll(where: { $0.card_suite == jokerC.card_suite })
        }
        
        /// Check if no total joker then it's not a impure sequence
        if totalJokers <= 0 {
            return false
        }
        
        /// Remove all the jokers from the card group
        myCards.removeAll(where: { $0.cardNumber == jokerCard.cardNumber })
        
        // After remove joker if card is lessthen 2 it's not a impure sequence
        if myCards.count < 2 {
            return false
        }
        
        /// Get card numbers
        var cardNumbers = myCards.map({ $0.cardNumber })
        // Check card is duplicates or not
        let duplicates = Array(Set(cardNumbers.filter({ (i: Int) in cardNumbers.filter({ $0 == i }).count > 1})))
        if duplicates.count > 0 {
            return false
        }
        
        /// Check card number is in sequence
        var isSequence = cardNumbers.numbersAreConsecutive()
        
        /// Get card suites
        let cardSuites = myCards.map({ $0.card_suite })
        // Make card suite set for same suites
        let cardSuitesSet = Set(cardSuites)
        // Check card suites are same or not
        let isSameSuites = cardSuitesSet.count <= 1
        
        if !isSequence {
            var totalGaps = [Int]()
            /// If card number is not in sequence check it is a A, K, Q sequence
            if cardNumbers.contains(1) && (cardNumbers.contains(13) || (cardNumbers.contains(12)) || cardNumbers.contains(11) || cardNumbers.contains(10)), let aCardIdx = cardNumbers.firstIndex(of: 1) {
                cardNumbers[aCardIdx] = 14
                cardNumbers = cardNumbers.sorted(by: { $0 < $1 })
            }
            /// Again Check card number is in sequence
            isSequence = cardNumbers.numbersAreConsecutive()
            if !isSequence {
                isSequence = true
                /// Check card gap and total joker for fill the gap
                for i in 1..<cardNumbers.count {
                    let gap = cardNumbers[i] - cardNumbers[i - 1]
                    if (gap > 2 && totalJokers == 1) || (gap > 3 && totalJokers == 2) || (gap > 4 && totalJokers == 3) || (gap > 5 && totalJokers == 4) || (gap > 6 && totalJokers == 5) || (gap > 7 && totalJokers == 6) || (gap > 8 && totalJokers == 7) {
                        isSequence = false
                        break
                    } else if gap == 2 || (gap == 12 && cardNumbers[i] == 14) {
                        totalGaps.append(gap)
                    } else if totalJokers > 1 && (gap == 3 || gap == 11) {
                        totalGaps.append(gap)
                    } else if totalJokers > 2 && gap == 4 {
                        totalGaps.append(gap)
                    } else if totalJokers > 3 && gap == 5 {
                        totalGaps.append(gap)
                    } else if totalJokers > 4 && gap == 6 {
                        totalGaps.append(gap)
                    } else if totalJokers > 5 && gap == 7 {
                        totalGaps.append(gap)
                    } else if totalJokers > 6 && gap == 8 {
                        totalGaps.append(gap)
                    }
                }
                if isSequence {
                    isSequence = totalGaps.count == 1
                }
            }
        }
        /// return card suites are same and is in sequence
        return isSequence && isSameSuites
    }
    
    public static func isSets(_ cards: [RummyCardModel], jokerCard: RummyCardModel? = nil) -> Bool {
        /// Check If card is less then 3 is not a part of any sequence and sets
        if cards.count < 3 {
            return false
        }
        /// Sorting all cards
        var myCards = cards.sorted(by: { $0.cardNumber < $1.cardNumber })
        if let jokerC = jokerCard {
            /// Remove all the jokers from the card group
            myCards.removeAll(where: { $0.cardNumber == jokerC.cardNumber && $0.cardNumber != -1 })
        }
        if let jokerC1 = myCards.first(where: { $0.card_suite == "jk" }) {
            /// Remove all the jokers from the card group
            myCards.removeAll(where: { $0.card_suite == jokerC1.card_suite })
        }
            
        /// If only one card is remain after removed joker means it's a sets
        if myCards.count == 1 {
            return true
        }
        
        /// Get card numbers
        let cardNumbers = myCards.map({ $0.cardNumber })
        // Make card number set for same numbers
        let myCardSet = Set(cardNumbers)
        // Check card numbers are same or not
        let isSets = myCardSet.count <= 1
        
        /// Get card suites
        let cardSuites = myCards.map({ $0.card_suite })
        // Make card suite set for same suites
        let cardSuitesSet = Set(cardSuites)
        // Check card suites are same or not
        let isSameSuites = cardSuitesSet.count <= 1
        
        /// Return Is Sets && not the same suites
        return isSets && !isSameSuites
    }
}

extension Array where Element == Int {
    func numbersAreConsecutive() -> Bool {
        for (num, nextNum) in zip(self, dropFirst())
            where (nextNum - num) != 1 { return false }
        return true
    }
}

struct RummyGameUser: Codable {
    var user = RummyUserCard()
    
    init() {    }
    init(_ json: JSON) {
        if let dic = json["user"].dictionary {
            user = RummyUserCard(JSON(dic))
        }
    }
}

struct RummyUserCard: Codable {
    var score = String()
    var name = String()
    var user_id = Int()
    var result = Int()
    var cards = [RummyUserCardModel]()
    var packed = Int()
    var win = Int()
    var total = Int()

    init() { }
    init(_ json: JSON) {
        score = json["score"].stringValue
        name = json["name"].stringValue
        user_id = json["user_id"].intValue
        result = json["result"].intValue
        packed = json["packed"].intValue
        win = json["win"].intValue
        
        if let cardds = json["cards"].array, cardds.count > 0 {
            cardds.forEach { object in
                cards.append(RummyUserCardModel(object))
            }
        }
    }
}

struct RummyUserCardModel: Codable {
    var card_group = String()
    var cards = [String]()
    
    init() { }
    init(_ json: JSON) {
        card_group = json["card_group"].stringValue
        if let cardss = json["cards"].array, cardss.count > 0 {
            cardss.forEach { object in
                cards.append(object.stringValue)
            }
        }
    }
}

struct RummyTableRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var no_of_players = ""
    var boot_value = ""
}


struct RummyMyCardRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
}

struct RummyDropCardRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var card = ""
    var json = ""
}

struct RummyDeclareCardRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var json = ""
}
