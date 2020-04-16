//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Giorgi Shukakidze on 1/15/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice (_ coinManager: CoinManager, price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let requestUrl = baseURL + currency
        
        if let url = URL(string: requestUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(self, price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.last
            return lastPrice
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
