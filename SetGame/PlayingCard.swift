//
//  PlayingCard.swift
//  SetGame
//
//  Created by Finch on 27.04.2021.
//
import UIKit

class PlayingCard: Equatable, NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return PlayingCard(figure: figure, color: color, transpatenty: texture, quantity: quantity)
    }
    
    static func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        var flag = true
        if lhs.figure != rhs.figure {
            flag = false
        }
        if lhs.color != rhs.color {
            flag = false
        }
        if lhs.texture != rhs.texture {
            flag = false
        }
        if lhs.quantity != rhs.quantity {
            flag = false
        }
        return flag
    }
    


    internal init(figure: PlayingCard.Figure = .diamonds, color: PlayingCard.Color = .purple, transpatenty: PlayingCard.Texture = .striped, quantity: PlayingCard.Quantity = .one) {
        self.figure = figure
        self.color = color
        self.texture = transpatenty
        self.quantity = quantity
    }
    
    var figure : Figure
    var color : Color
    var texture : Texture
    var quantity : Quantity
    var isSelected : Bool = false {
        didSet {
            delegate?.playingCard(self, newValueIsSelected: isSelected)
        }
    }
    var isSetCard : Bool? {
        didSet {
            delegate?.playingCard(self, newValueIsSetCard: isSetCard)
        }
    }
    
    weak var delegate: PlayingCardDelegate?
    
    enum Figure: CaseIterable {
        case ​squiggles
        case diamonds
        case ovals
    }
    
    enum Color: CaseIterable {
        case green
        case red
        case purple
    }
    
    enum Texture: CaseIterable {
        case solid
        case striped
        case unfilled
    }
    
    enum Quantity: CaseIterable {
        case one
        case two
        case three
    }
}

protocol PlayingCardDelegate : class {
    func playingCard(_ card: PlayingCard, newValueIsSelected: Bool)
    func playingCard(_ card: PlayingCard, newValueIsSetCard: Bool?)
}
