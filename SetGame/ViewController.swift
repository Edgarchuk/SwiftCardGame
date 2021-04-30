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
        let itemSize = UIScreen.main.bounds.width/2

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        cardCollectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        setGame.fillDeck()
    }
    @IBAction func dealMoreCardsTap(_ sender: Any) {
        setGame.dealThreeCards()
    }
    
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return setGame.cardsOnDeck.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playingCardCell", for: indexPath) as! PlayingCardCell
        cell.cardView.card = setGame.cardsOnDeck[indexPath.row]
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
    }
    func setGame(_ setGame: SetGame, removeCard: PlayingCard) {
        cardCollectionView.reloadData()
    }
}


