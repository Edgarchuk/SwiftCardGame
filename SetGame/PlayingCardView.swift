//
//  PlayingCardView.swift
//  SetGame
//
//  Created by Finch on 27.04.2021.
//

import UIKit
@IBDesignable
class PlayingCardView: UIControl {

    
    
    let figureLayer = CAShapeLayer()
    
    var card : PlayingCard? {
        didSet {
            backgroundColor = .link
            updateBorder()
            drawCard(rect: layer.frame)
            card?.delegate = self
        }
    }
    
    override var bounds: CGRect {
        didSet {
            drawCard(rect: bounds)
        }
    }
    
    func drawCard(rect: CGRect) {
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
            
            let relativeHeightFigure: CGFloat = 1.5 / 7
            
            switch card.quantity {
            case .one:
                drawRect.append(CGRect(x: 10, y: (1 / 2 - relativeHeightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * relativeHeightFigure))
            case .two:
                drawRect.append(CGRect(x: 10, y: (1 / 3 - relativeHeightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * relativeHeightFigure))
                drawRect.append(CGRect(x: 10, y: (2 / 3 - relativeHeightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * relativeHeightFigure))
            case .three:
                drawRect.append(CGRect(x: 10, y: (1 / 4 - relativeHeightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * relativeHeightFigure))
                drawRect.append(CGRect(x: 10, y: (2 / 4 - relativeHeightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * relativeHeightFigure))
                drawRect.append(CGRect(x: 10, y: (3 / 4 - relativeHeightFigure / 2) * rect.height, width: rect.width - 20, height: rect.height * relativeHeightFigure))
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
            
            
            let path = UIBezierPath()
            for rect in drawRect {
                drawFigur(path,rect)
            }
            
            
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            
            if isStriped {
                shadingPath(path)
            }
            
            figureLayer.path = path.cgPath
            figureLayer.mask = mask
            figureLayer.lineWidth = 1
            if !isFill {
                figureLayer.fillColor = backgroundColor!.cgColor
            } else {
                figureLayer.fillColor = color.cgColor
            }
            figureLayer.strokeColor = color.cgColor
            
            
            
            layer.addSublayer(figureLayer)
            setNeedsDisplay()
            
        }
    }
    private func updateBorder() {
        layer.cornerRadius = 10
        
        guard let card = card else {
            return
        }
        if card.isSelected {
            layer.borderWidth = bounds.width * 0.05
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
    }

    
    private func draw​Squiggles (path: UIBezierPath, rect: CGRect) {
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY), controlPoint1: CGPoint(x:rect.minX + rect.width / 4, y: rect.minY - rect.height / 2), controlPoint2: CGPoint(x: rect.midX, y: rect.midY))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY), controlPoint1: CGPoint(x:rect.maxX - rect.width / 4, y: rect.maxY + rect.height / 2), controlPoint2: CGPoint(x: rect.midX, y: rect.midY))
        
    }
    
    private func drawOval(path: UIBezierPath, rect: CGRect) {
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), controlPoint: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), controlPoint: CGPoint(x: rect.minX, y: rect.maxY))
        
    }
    
    private func drawDiamonds(path: UIBezierPath, rect: CGRect){
        path.move(to: CGPoint (x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.close()
    }
    
    private func shadingPath(_ path: UIBezierPath) {
        let bounds = path.bounds

        let stripes = UIBezierPath()
        for x in stride(from: 0, to: bounds.size.width, by: 3){
            stripes.move(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y ))
            stripes.addLine(to: CGPoint(x: bounds.origin.x + x, y: bounds.origin.y + bounds.size.height ))
        }
        path.append(stripes)
    }
    
}

extension PlayingCardView : PlayingCardDelegate {
    func playingCard(_ card: PlayingCard, newValueIsSelected: Bool) {
        updateBorder()
    }
    func playingCard(_ card: PlayingCard, newValueIsSetCard: Bool?) {
        updateBorder()
        
    }
    
    
}

