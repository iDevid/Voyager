//
//  PokeApi.swift
//  Demo
//
//  Created by Davide Sibilio on 03/11/22.
//

import Foundation
import Voyager
import VoyagerMock

protocol PokemonListServiceProtocol: NetworkService where ResponseModel == PokemonListResponse {}
extension PokemonListServiceProtocol {
    var rootEndpoint: String { "https://pokeapi.co/api/v2/" }
    var endpoint: String { "pokemon" }
}


struct PokemonListService: PokemonListServiceProtocol {}



class PokemonListMockService: MockedService, PokemonListServiceProtocol {}

func test() {
    let service = PokemonListMockService()
    service.setNextResponse(.model(PokemonListResponse(count: 0, results: [])))
}

class ClassToTest {
    let service: any PokemonListServiceProtocol
    
    init(service: any PokemonListServiceProtocol) {
        self.service = service
    }
}

struct PokemonListQueryRequest: NetworkRequest {
    let limit: Int
    let offset: Int
}

struct PokemonListResponse: Decodable {
    let count: Int
    let results: [PokemonReference]
}

struct PokemonReference: Decodable {
    let name: String
    let url: String
}
