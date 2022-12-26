//
//  APIcaller.swift
//  AIBot
//
//  Created by TTGMOTSF on 18/12/2022.
//

import Foundation
import OpenAISwift

class APICaller {
    
    static let share = APICaller()
    private var client: OpenAISwift?

    public func setup(){
        self.client = OpenAISwift(authToken: K.key)
        
    }
    public func getResponse(input: String, completion: @escaping(Result<String, Error>)-> Void){
        client?.sendCompletion(with: input, model: .gpt3(.curie), maxTokens: 1500 ,completionHandler: { result in
            switch result{
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                print("Success")
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
