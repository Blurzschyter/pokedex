//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by NM on 04/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemonDet: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var pokedexidLabel: UILabel!
    @IBOutlet weak var baseAtkLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = pokemonDet.name.capitalized
        
        let img = UIImage(named: "\(pokemonDet.pokedexId)")
        mainImage.image = img
        currentEvoImage.image = img
        pokedexidLabel.text = "\(pokemonDet.pokedexId)"
        
        pokemonDet.downloadPokemonDetail {
            
            //whatever we write will only be called after the network call is complete!
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        baseAtkLabel.text = pokemonDet.baseAttack
        defenseLabel.text = pokemonDet.defense
        heightLabel.text = pokemonDet.height
        weightLabel.text = pokemonDet.weight
        typeLabel.text = pokemonDet.type
        descriptionLabel.text = pokemonDet.description
        
        if pokemonDet.nextEvolutionId == "" {
            
            evoLabel.text = "No Evolutions"
            nextEvoImage.isHidden = true
            
        } else {
            
            nextEvoImage.isHidden = false
            nextEvoImage.image = UIImage(named: pokemonDet.nextEvolutionId)
            let str = "Next Evolution: \(pokemonDet.nextEvolutionName) - LVL \(pokemonDet.nextEvolutionLevel)"
            evoLabel.text = str
            
        }
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
