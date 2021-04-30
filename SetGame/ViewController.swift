//
//  ViewController.swift
//  SetGame
//
//  Created by Finch on 27.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cardCollectionView: UICollectionView!
    let setGame: SetGame = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGame.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        setGame.fillDeck()
        resizeCell()
    }
    @IBAction func dealMoreCardsTap(_ sender: Any) {
        setGame.dealThreeCards()
    }
    
    func resizeCell() {
        let temp = (CGFloat(setGame.cardsOnDeck.count) / 1.2).squareRoot()
        let itemSize = (cardCollectionView.bounds.width - 3 * (temp - 1)) / temp
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize * 1.2)

        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 10
        cardCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction.contains(.down) {
            setGame.dealThreeCards()
        }
    }
    @IBAction func rotate(_ sender: UIRotationGestureRecognizer) {
        setGame.cardsOnDeck.shuffle()
        cardCollectionView.reloadData()
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
    
    
    @objc func tapCard(sender: PlayingCardView) {
        if let card = sender.card {
            setGame.selectCard(card: card)
        }
    }
}

extension ViewController : SetGameDelegate {
    func setGame(_ setGame: SetGame, putCard: PlayingCard) {
        cardCollectionView.reloadData()
        resizeCell()
    }
    func setGame(_ setGame: SetGame, removeCard: PlayingCard) {
        cardCollectionView.reloadData()
        resizeCell()
    }
}


