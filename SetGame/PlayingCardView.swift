//
//  PlayingCardView.swift
//  SetGame
//
//  Created by Finch on 27.04.2021.
//

import UIKit
@IBDesignable
class PlayingCardView: UIControl {

    var card : PlayingCard? {
        didSet {
            setNeedsDisplay()
            card?.delegate = self
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 10
        layer.borderWidth = 10
        layer.borderColor = UIColor.red.cgColor
        if let card = card {
            
            var drawFigur: (UIBezierPath, CGRect) -> () = drawOval
            
            switch card.figure {
            case .diamonds:
                drawFigur = drawDiamonds
            case .ovals:
                drawFigur = drawOval
            case .​squiggles:
                drawFigur = draw​Squiggles
            }
            
            var color: UIColor = .black
            switch card.color {
            case .red:
                color = UIColor.red
            case .green:
                color = UIColor.green
            case .purple:
                color = UIColor.purple
            }
            
            
            var drawRect: [CGRect] = []
            
            let heightFigure: CGFloat = 1.5 / 7
            
            switch card.quantity {
            case .one:
                drawRect.append(CGRect(x: 10, y: (1 / 2 - heightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * heightFigure))
            case .two:
                drawRect.append(CGRect(x: 10, y: (1 / 3 - heightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * heightFigure))
                drawRect.append(CGRect(x: 10, y: (2 / 3 - heightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * heightFigure))
            case .three:
                drawRect.append(CGRect(x: 10, y: (1 / 4 - heightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * heightFigure))
                drawRect.append(CGRect(x: 10, y: (2 / 4 - heightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * heightFigure))
                drawRect.append(CGRect(x: 10, y: (3 / 4 - heightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * heightFigure))
            }
            
            var isFill = false
            var isStriped = false
            
            switch card.texture {
            case .solid:
                isFill = true
            case .striped:
                isStriped = true
            case .unfilled:
                isFill = false
                isStriped = false
            }
            
            if card.isSelected {
                layer.borderWidth = 6
            } else {
                layer.borderWidth = 0
            }
            
            if let isSet = card.isSetCard {
                if isSet {
                    layer.borderColor = UIColor.green.cgColor
                } else {
                    layer.borderColor = UIColor.red.cgColor
                }
            } else {
                layer.borderColor = UIColor.black.cgColor
            }
            
            let path = UIBezierPath()
            for rect in drawRect {
                drawFigur(path,rect)
            }
            drawPath(path, color: color, isFill: isFill, isStriped: isStriped)
            
        }
    }
    
    func draw​Squiggles (path: UIBezierPath, rect: CGRect) {
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY), controlPoint1: CGPoint(x:rect.minX + rect.width / 4, y: rect.minY - rect.height / 2), controlPoint2: CGPoint(x: rect.midX, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY), controlPoint1: CGPoint(x:rect.maxX - rect.width / 4, y: rect.maxY + rect.height / 2), controlPoint2: CGPoint(x: rect.midX, y: rect.midY))
        
    }
    
    func drawOval(path: UIBezierPath, rect: CGRect) {
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        
    }
    
    func drawDiamonds(path: UIBezierPath, rect: CGRect){
        path.move(to: CGPoint (x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
    }
    
    func shading(_ path: UIBezierPath, color: UIColor) {
        let bounds = path.bounds

        let stripes = UIBezierPath()
        for x in stride(from: 0, to: bounds.size.width, by: 3){
            stripes.move(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y ))
            stripes.addLine(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y + bounds.size.height ))
        }
        
        color.setStroke()
        stripes.lineWidth = 1
        path.addClip()
        stripes.stroke()
    }
    func drawPath(_ path: UIBezierPath, color: UIColor, isFill: Bool, isStriped: Bool) {
        if isStriped
        {
            shading(path, color: color)
        }
        if isFill {
            color.setFill()
            path.fill()
            return
        }
        color.setStroke()
        path.stroke()
    }
    
}

extension PlayingCardView : PlayingCardDelegate {
    func playingCard(_ card: PlayingCard, newValueIsSelected: Bool) {
        setNeedsDisplay()
    }
    func playingCard(_ card: PlayingCard, newValueIsSetCard: Bool?) {
        setNeedsDisplay()
    }
    
    
}

