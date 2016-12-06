//
//  ViewController.swift
//  Pokedex
//
//  Created by NM on 02/12/2016.
//  Copyright © 2016 nizar. All rights reserved.
//

import UIKit
import AVFoundation //for audio play

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    // 3 most common protocol for UICollectionView
    // ---UICollectionViewDelegate
    // ---UICollectionViewDataSource
    // ---UICollectionViewDelegateFlowLayout
    
    // 1 most common protocol for UISearchBarDelegate
    // ---UISearchBarDelegate

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var musicPlayer: AVAudioPlayer!
    
    var pokemon = [Pokemon]()//array initiliazation| for pokemon csv storage
    
    var filteredPokemon = [Pokemon]()
    
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done //hide the keyboard when "DONE" key is selected
        
        parsePokemonCSV()
        initAudio()
    }
    
    //To create function for audio to play
    func initAudio() {
        
        let path =  Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //-1 means infinite loop
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    //------------------------------------
    
    //To create function to parse CSV data 
    func parsePokemonCSV()  {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! //define the location/path of the file
        
        //need to do do catch statement
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    //------------------------------------

    //cellForItemAt indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //- deque reusable cell can be used to reduce the load of all cell by recycle the non displayed cell.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            //@first
            //let poke = Pokemon(name: "Pokemon", pokedexId: indexPath.row)
            //cell.configureCell(pokemon: poke)
            
            //@second
            //let poke = pokemon[indexPath.row]
            //cell.configureCell(pokemon: poke)
            
            //@third
            let poke: Pokemon!
            
            if inSearchMode { //if true
                
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
                
                
            } else { //if false
                
                poke = pokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
                
            }
            
            return cell
            
        } else {
            
            return UICollectionViewCell() //this usually not happen. just for precaution.
        }
    }
    
    //didSelectItemAt indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            
            poke = filteredPokemon[indexPath.row]
            
        } else {
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    //numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //@first - this hardcoded for testing purpose in early stage only.
        //return 30 
        
        //@second
        //return pokemon.count
        
        //@third - need to be implemented bcoz of searchbar
        if inSearchMode {
            
            return filteredPokemon.count
            
        } else {
            return pokemon.count
        }
        
        
    }
    
    //numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    //sizeForItemAt indexPath
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            
            musicPlayer.pause()
            sender.alpha = 0.2 //transparent
            
        } else {
            
            musicPlayer.play()
            sender.alpha = 1.0 //fully visible
            
        }
    }
    
    //searchBarSearchButtonClicked - what happen during search btn clicked at searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    //textDidChange - to see any changes in keystroke
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil })
            collection.reloadData()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke  = sender as? Pokemon {
                    detailsVC.pokemonDet = poke
                }
            }
        }
    }
    
}

