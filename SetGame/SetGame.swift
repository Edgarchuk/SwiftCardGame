//
//  SetGame.swift
//  SetGame
//
//  Created by Finch on 27.04.2021.
//

import UIKit

class SetGame{
    let startNumberCards = 12
    let maxCardsOnDeck = 81
    
    private var cards : [PlayingCard] = []
    var cardsOnDeck : [PlayingCard] = []
    var selectedCard : [PlayingCard] = []
    weak var delegate: SetGameDelegate?
    
    init() {
        fillCards()
    }
    
    func newGame(){
        selectedCard.removeAll()
        cardsOnDeck.removeAll()
        fillCards()
        putCardOnDeck(cardsCount: startNumberCards)
    }
    
    private func fillCards() {
        cards.removeAll()
        for figure in PlayingCard.Figure.allCases {
            for color in PlayingCard.Color.allCases {
                for transparency in PlayingCard.Texture.allCases {
                    for quantity in PlayingCard.Quantity.allCases {
                        cards.append(PlayingCard(figure: figure, color: color, transpatenty: transparency, quantity: quantity))
                    }
                }
            }
        }
    }
    
    func fillDeck() {
        putCardOnDeck(cardsCount: startNumberCards)
    }
    
    private func putCardOnDeck() {
        if let card = cards.randomElement() {
            cards = cards.filter({$0 != card})
            cardsOnDeck.append(card)
            delegate?.setGame(self, putCardIndex: cardsOnDeck.count - 1)
        }
    }
    func selectCard(card: PlayingCard) {
        func markCard(card: PlayingCard) {
            card.isSelected = true
            selectedCard.append(card)
        }
        
        if selectedCard.contains(card) {
            if selectedCard.count == 3 {
                deleteSelection()
                card.isSelected = true
                selectedCard.append(card)
                return
            }
            card.isSelected = false
            selectedCard = selectedCard.filter({$0 != card})
        } else if selectedCard.count < 3 {
            markCard(card: card)
        } else if selectedCard.count == 3 {
            if selectedCardIsSet() {
                removeSelectedCards()
                putCardOnDeck(cardsCount: 3)
            } else {
                deleteSelection()
            }
            markCard(card: card)
        }
        
        if selectedCard.count == 3 {
            if selectedCardIsSet() {
                for card in selectedCard {
                    card.isSetCard = true
                }
            } else {
                for card in selectedCard {
                    card.isSetCard = false
                }
            }
        }
    }
    private func removeCardFromDeck(card: PlayingCard) {
        card.isSelected = false
        if cardsOnDeck.contains(card) == false {
            return
        }
        let index = Int(cardsOnDeck.firstIndex(of: card)!)
        delegate?.setGame(self, willRemoveCardIndex: index)
        cardsOnDeck = cardsOnDeck.filter({$0 != card})
        delegate?.setGame(self, didRemoveCardIndex: index)
    }
    private func set(first: PlayingCard, second: PlayingCard, third: PlayingCard) -> Bool {
        var count = 0
        if first.color == second.color && second.color == third.color {
            count += 1
        } else if first.color != second.color && second.color != third.color && first.color != third.color{
            count += 1
        }
        if first.quantity == second.quantity && second.quantity == third.quantity {
            count += 1
        } else if first.quantity != second.quantity && second.quantity != third.quantity && first.quantity != third.quantity {
            count += 1
        }
        if first.texture == second.texture && second.texture == third.texture {
            count += 1
        } else if first.texture != second.texture && second.texture != third.texture && first.texture != third.texture {
            count += 1
        }
        if first.figure == second.figure && second.figure == third.figure {
            count += 1
        } else if first.figure != second.figure && second.figure != third.figure && first.figure != third.figure{
            count += 1
        }
        return count == 4
    }
    private func selectedCardIsSet() -> Bool {
        return set(first: selectedCard[0], second: selectedCard[1], third: selectedCard[2])
    }
    func dealThreeCards() {
        if cards.count == 0 || cardsOnDeck.count >= maxCardsOnDeck {
            return
        }
        if selectedCard.count == 3 {
            if selectedCardIsSet() == false {
                deleteSelection()
                putCardOnDeck(cardsCount: 3)
                return
            }
            removeSelectedCards()
        }
        putCardOnDeck(cardsCount: 3)
    }
    
    private func removeSelectedCards() {
        for card in selectedCard {
            removeCardFromDeck(card: card)
        }
        selectedCard.removeAll()
    }
    
    private func putCardOnDeck(cardsCount: Int) {
        for _ in 0..<cardsCount {
            putCardOnDeck()
        }
    }
    
    private func deleteSelection() {
        selectedCard.forEach({$0.isSelected = false ; $0.isSetCard = nil})
        selectedCard.removeAll()
    }
}

protocol SetGameDelegate: class {
    func setGame(_ setGame: SetGame, putCardIndex indexCard: Int)
    func setGame(_ setGame: SetGame, willRemoveCardIndex indexCard: Int)
    func setGame(_ setGame: SetGame, didRemoveCardIndex indexCard: Int)
}

