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
    @IBOutlet weak var deletedCard: PlayingCardView!
    let setGame: SetGame = .init()
    var needAddAnimatedCards: [IndexPath] = []
    var needDeleteAnimatadCards: [IndexPath] = []
    var cards: [PlayingCard] = []
    var lastDeletedCard: PlayingCard!
    
    var animator: UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame.delegate = self
        animator = UIDynamicAnimator(referenceView: view)
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
    
    private var lastItemSize = 0.0
    private func resizeCell(completion: @escaping (Bool) -> () = {_ in }) {
        let layout = UICollectionViewFlowLayout()
        let itemSize = getSizeCell(left: 1, right: Double(cardCollectionView.bounds.width))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize * relativeSize)

        layout.minimumInteritemSpacing = CGFloat(spacing)
        layout.minimumLineSpacing = CGFloat(spacing)
        if Int(lastItemSize) != Int(itemSize) {
            //print(itemSize)
            cardCollectionView.setCollectionViewLayout(layout, animated: true, completion: completion)
        }
        else {
            completion(true)
        }
        lastItemSize = itemSize
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction.contains(.down) {
            setGame.dealThreeCards()
        }
    }
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        setGame.cardsOnDeck.shuffle()
        cards = setGame.cardsOnDeck
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
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playingCardCell", for: indexPath) as! PlayingCardCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PlayingCardCell else {
            //print("cell is nil")
            return
        }
        
        cell.cardView.card = cards[indexPath.row]
        cell.cardView.addTarget(nil, action: #selector(tapCard), for: .touchUpInside)
        
        if needAddAnimatedCards.contains(indexPath) {
            needAddAnimatedCards = needAddAnimatedCards.filter({$0 != indexPath})
            
            let movingCard = UIView(frame: cell.frame)
            movingCard.backgroundColor = UIColor.link
            movingCard.layer.cornerRadius = 10
            movingCard.center = dealMoreCardsButton.center
            view.addSubview(movingCard)
            cell.alpha = 0
            dealMoreCardsButton.isEnabled = false
            //print(target, cell.frame)
            UIView.animate(withDuration: 0.5,delay: 0.0, options: .curveEaseOut) {
                movingCard.center = self.cardCollectionView.convert(cell.center, to: self.view)
                movingCard.bounds = cell.bounds
                //movingCard.center = CGPoint(x: cell.center.x + 20, y: cell.center.y + 64)
            } completion: { (_) in
                cell.alpha = 1
                movingCard.removeFromSuperview()
                self.dealMoreCardsButton.isEnabled = true
            }
        } else {
            //print(indexPath," is not animeted")
        }
        
        if needDeleteAnimatadCards.contains(indexPath) {
            needDeleteAnimatadCards = needDeleteAnimatadCards.filter({$0 != indexPath})
            
            let movingCard = UIView()
            movingCard.backgroundColor = UIColor.link
            movingCard.layer.cornerRadius = 10
            movingCard.bounds = cell.bounds
            movingCard.center = self.cardCollectionView.convert(cell.center, to: self.view)
            view.addSubview(movingCard)
            let gravity = UIGravityBehavior(items: [movingCard])
            animator.addBehavior(gravity)
            let collision = UICollisionBehavior(items: [movingCard])
            collision.translatesReferenceBoundsIntoBoundary = true
            animator.addBehavior(collision)
            let itemBehaviour = UIDynamicItemBehavior(items: [movingCard])
            itemBehaviour.elasticity = 0.7
            animator.addBehavior(itemBehaviour)
            let card = lastDeletedCard
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: { [self] in
                animator.removeBehavior(gravity)
                animator.removeBehavior(collision)
                animator.removeBehavior(itemBehaviour)
                UIView.animate(withDuration: 1,delay: 0.0, options: .curveEaseIn) {
                    movingCard.frame = deletedCard.frame
                } completion: { (_) in
                    movingCard.removeFromSuperview()
                    deletedCard.card = card
                }
            })
            
//            UIView.animate(withDuration: 1,delay: 0.0, options: .curveEaseIn) {
//                let center = self.cardCollectionView.convert(cell.center, to: self.view)
//                movingCard.center = CGPoint(x: center.x + self.cardCollectionView.bounds.width, y: center.y)
//            } completion: { (_) in
//                movingCard.removeFromSuperview()
//            }
        }
    }
    
    
    @objc func tapCard(sender: PlayingCardView) {
        if let card = sender.card {
            setGame.selectCard(card: card)
        }
    }
}

extension ViewController : SetGameDelegate {
    func setGame(_ setGame: SetGame, willPutCardIndex indexCard: Int) {
        let index = IndexPath(row: indexCard, section: 0)
        needAddAnimatedCards.append(index)
        //print("add ", index, " to needAddAnimatedCards")
        
    }
    func setGame(_ setGame: SetGame, willRemoveCardIndex indexCard: Int) {
        let index = IndexPath(row: indexCard, section: 0)
        needDeleteAnimatadCards.append(index)
        lastDeletedCard = setGame.cardsOnDeck[indexCard]
    }
    
    func update() {
        resizeCell() { [self] _ in
            cards = setGame.cardsOnDeck
            DispatchQueue.main.async {
                self.cardCollectionView.reloadData()
            }
        }
    }
}



