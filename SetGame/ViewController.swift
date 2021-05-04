//
//  ViewController.swift
//  SetGame
//
//  Created by Finch on 27.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    let setGame: SetGame = .init()
    var needAddAnimatedCards: [IndexPath] = []
    var needDeleteAnimatadCards: [IndexPath] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        setGame.fillDeck()
        resizeCell()
    }
    override func viewDidLayoutSubviews() {
        resizeCell()
    }
    @IBAction func dealMoreCardsTap(_ sender: Any) {
        setGame.dealThreeCards()
        
    }
    
    private func getSizeCell(left: Double, right: Double) -> Double {
        let mid = (left + right) / 2
        if (right - left <= 1.0) {
            return left
        }
        if checkSizeCell(size: mid) {
            return getSizeCell(left: mid, right: right)
        }
        return getSizeCell(left: left, right: mid)
    }
    
    private let relativeSize = 1.2
    let spacing: Double = 3.0
    private func checkSizeCell(size: Double) -> Bool {
        return Int((Double(cardCollectionView.bounds.width) - spacing) / (size + spacing)) * Int((Double(cardCollectionView.bounds.height) - spacing) / (size * relativeSize + spacing)) >= setGame.cardsOnDeck.count
    }
    
    
    let layout = UICollectionViewFlowLayout()
    
    func resizeCell() {
        
        let itemSize = getSizeCell(left: 1, right: Double(cardCollectionView.bounds.width))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize * relativeSize)

        layout.minimumInteritemSpacing = CGFloat(spacing)
        layout.minimumLineSpacing = CGFloat(spacing)
        cardCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction.contains(.down) {
            setGame.dealThreeCards()
        }
    }
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        setGame.cardsOnDeck.shuffle()
        DispatchQueue.main.async { [self] in
            cardCollectionView.reloadData()
        }
    }
    @IBAction func newGame(_ sender: Any) {
        setGame.newGame()
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setGame.cardsOnDeck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playingCardCell", for: indexPath) as! PlayingCardCell
        cell.cardView.card = setGame.cardsOnDeck[indexPath.row]
        cell.cardView.addTarget(nil, action: #selector(tapCard), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if needAddAnimatedCards.contains(indexPath) {
            needAddAnimatedCards = needAddAnimatedCards.filter({$0 != indexPath})
            
            let movingCard = UIView()
            movingCard.backgroundColor = UIColor.link
            movingCard.layer.cornerRadius = 10
            movingCard.bounds = cell.bounds
            movingCard.center = dealMoreCardsButton.center
            view.addSubview(movingCard)
            cell.alpha = 0
            UIView.animate(withDuration: 2,delay: 0.0, options: .curveEaseOut) {
                movingCard.center = cell.center
            } completion: { (_) in
                cell.alpha = 1
                movingCard.removeFromSuperview()
            }
        }
        
        if needDeleteAnimatadCards.contains(indexPath) {
            needDeleteAnimatadCards = needDeleteAnimatadCards.filter({$0 != indexPath})
            
            let movingCard = UIView()
            movingCard.backgroundColor = UIColor.link
            movingCard.layer.cornerRadius = 10
            movingCard.frame = cell.frame
            view.addSubview(movingCard)
            cell.alpha = 0
            UIView.animate(withDuration: 2,delay: 0.0, options: .curveEaseOut) {
                movingCard.center = CGPoint(x: movingCard.center.x, y: movingCard.center.y + movingCard.frame.width)
            } completion: { (_) in
                cell.alpha = 1
                movingCard.removeFromSuperview()
            }
        }
    }
    
    
    @objc func tapCard(sender: PlayingCardView) {
        if let card = sender.card {
            setGame.selectCard(card: card)
        }
    }
}

extension ViewController : SetGameDelegate {
    func setGame(_ setGame: SetGame, putCardIndex indexCard: Int) {
        resizeCell()
        let index = IndexPath(row: indexCard, section: 0)
        needAddAnimatedCards.append(index)
        DispatchQueue.main.async { [self] in
            cardCollectionView.insertItems(at: [index])
        }
    }
    func setGame(_ setGame: SetGame, willRemoveCardIndex indexCard: Int) {
        let index = IndexPath(row: indexCard, section: 0)
        needDeleteAnimatadCards.append(index)
        DispatchQueue.main.async { [self] in
            cardCollectionView.reloadItems(at: [index])
        }
    }
    func setGame(_ setGame: SetGame, didRemoveCardIndex indexCard: Int) {
        resizeCell()
        let index = IndexPath(row: indexCard, section: 0)
        
        DispatchQueue.main.async { [self] in
            cardCollectionView.deleteItems(at: [index])
        }
    }
}


