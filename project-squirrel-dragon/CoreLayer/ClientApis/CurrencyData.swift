//
//  CurrencyData.swift
//  project-squirrel-dragon
//
//  Created by Justine Wright on 2021/12/13.
//

import Foundation

struct CurrencyData {
    let JPY: Double
    let CNY: Double
    let CHF: Double
    let CAD: Double
    let MXN: Double
    let INR: Double
    let BRL: Double
    let RUB: Double
    let KRW: Double
    let IDR: Double
    let TRY: Double
    let SAR: Double
    let SEK: Double
    let NGN: Double
    let PLN: Double
    let ARS: Double
    let NOK: Double
    let TWD: Double
    let IRR: Double
    let AED: Double
    let COP: Double
    let THB: Double
    let ZAR: Double
    let DKK: Double
    let MYR: Double
    let SGD: Double
    let ILS: Double
    let HKD: Double
    let EGP: Double
    let PHP: Double
    let CLP: Double
    let PKR: Double
    let IQD: Double
    let DZD: Double
    let KZT: Double
    let QAR: Double
    let CZK: Double
    let PEN: Double
    let RON: Double
    let VND: Double
    let BDT: Double
    let HUF: Double
    let UAH: Double
    let AOA: Double
    let MAD: Double
    let OMR: Double
    let CUC: Double
    let BYR: Double
    let AZN: Double
    let LKR: Double
    let SDG: Double
    let SYP: Double
    let MMK: Double
    let DOP: Double
    let UZS: Double
    let KES: Double
    let GTQ: Double
    let URY: Double
    let HRV: Double
    let MOP: Double
    let ETB: Double
    let CRC: Double
    let TZS: Double
    let TMT: Double
    let TND: Double
    let PAB: Double
    let LBP: Double
    let RSD: Double
    let LYD: Double
    let GHS: Double
    let YER: Double
    let BOB: Double
    let BHD: Double
    let CDF: Double
    let PYG: Double
    let UGX: Double
    let SVC: Double
    let TTD: Double
    let AFN: Double
    let NPR: Double
    let HNL: Double
    let BIH: Double
    let BND: Double
    let ISK: Double
    let KHR: Double
    let GEL: Double
    let MZN: Double
    let BWP: Double
    let PGK: Double
    let JMD: Double
    let XAF: Double
    let NAD: Double
    let ALL: Double
    let SSP: Double
    let MUR: Double
    let MNT: Double
    let NIO: Double
    let LAK: Double
    let MKD: Double
    let AMD: Double
    let MGA: Double
    let XPF: Double
    let TJS: Double
    let HTG: Double
    let BSD: Double
    let MDL: Double
    let RWF: Double
    let KGS: Double
    let GNF: Double
    let SRD: Double
    let SLL: Double
    let XOF: Double
    let MWK: Double
    let FJD: Double
    let ERN: Double
    let SZL: Double
    let GYD: Double
    let BIF: Double
    let KYD: Double
    let MVR: Double
    let LSL: Double
    let LRD: Double
    let CVE: Double
    let DJF: Double
    let SCR: Double
    let SOS: Double
    let GMD: Double
    let KMF: Double
    let STD: Double
    let XRP: Double
    let AUD: Double
    let BGN: Double
    let BTC: Double
    let JOD: Double
    let GBP: Double
    let ETH: Double
    let USD: Double
    let LTC: Double
    let NZD: Double

    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
      }
}
