//
//  RequestRepo.swift
//  desafio-ios
//
//  Created by Jean Carlos on 12/28/16.
//  Copyright © 2016 Jean Carlos. All rights reserved.
//

import Foundation

// Variáveis de controle;
var repoList = [Repo]()

// Função que faz o request na API do github;
func request() {
    typealias ReposResponse = [String:Any]
    let repoUrlString = "https://api.github.com/search/repositories?q=language:Java&sort=stars&page=1"
    
    let session = URLSession.shared
    (session.dataTask(with: URL(string:repoUrlString)!) { [weak self] (data, reponse, error) in
        
        //MARK: Tratamento de erro;
        guard error == nil else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? ReposResponse {
                
                // O array de repositórios se encontra na chave "itens" do JSON, portanto, precisamos pegá-lo antes;
                guard let reposJson = json["items"] as? [ReposResponse] else { return }
                
                do {
                    self?.repoList = try reposJson.flatMap(Repo.init)
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } catch let error {
                    print(error)
                }
            } else {
                print("Wrong format")
            }
        } catch let error {
            print(error)
        }
    }).resume()
}
