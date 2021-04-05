//
//  CurrencyManager.swift
//  Sell4Bids
//
//  Created by admin on 7/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Foundation
struct currencyModel {
    var country : String?
    var threeDigitCode: String?
    var twoDigitCode: String?
    var symbol: String?
    
    init(country: String? , threeDigitCode: String?, twoDigitCode: String?, symbol:String?) {
        self.country = country
        self.threeDigitCode = threeDigitCode
        self.twoDigitCode = twoDigitCode
        self.symbol = symbol
    }
}

class  CurrencyManager {
    static var currencyArray = [currencyModel]()
    static let instance = CurrencyManager()
    
    static func setupCurrencyArray() {
      currencyArray.append(currencyModel.init(country: "Select Country", threeDigitCode: "NOT SELECTED", twoDigitCode: "NOT SELECTED", symbol: "NOT SELECTED"))
        currencyArray.append(currencyModel.init(country: "AFGHANISTAN", threeDigitCode: "AFN", twoDigitCode: "AF", symbol: "Af"))
        currencyArray.append(currencyModel.init(country: "ALAND ISLANDS", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "ALBANIA", threeDigitCode: "ALL", twoDigitCode: nil , symbol: "L"))
        currencyArray.append(currencyModel.init(country: "ALGERIA", threeDigitCode: "DZD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "AMERICAN SAMOA", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "ANDORRA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "ANGOLA", threeDigitCode: "AOA", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ANGUILLA", threeDigitCode: "XCD", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "ANTARCTICA", threeDigitCode: nil, twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ANTIGUA AND BARBUDA", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ARGENTINA", threeDigitCode: "ARS", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "ARMENIA", threeDigitCode: "AMD", twoDigitCode: nil, symbol: "֏"))
        currencyArray.append(currencyModel.init(country: "ARUBA", threeDigitCode: "AWG", twoDigitCode: nil, symbol: "ƒ"))
        currencyArray.append(currencyModel.init(country: "AUSTRALIA", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "AUSTRIA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "AZERBAIJAN", threeDigitCode: "AZN", twoDigitCode: "AZ", symbol: "₼"))
        currencyArray.append(currencyModel.init(country: "BAHAMAS", threeDigitCode: "BSD", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "BAHRAIN", threeDigitCode: "BHD", twoDigitCode: "BH", symbol: nil))
        currencyArray.append(currencyModel.init(country: "BANGLADESH", threeDigitCode: "BDT", twoDigitCode: "BD", symbol: "Tk"))
        currencyArray.append(currencyModel.init(country: "BARBADOS", threeDigitCode: "BBD", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "BELARUS", threeDigitCode: "BYN", twoDigitCode: nil, symbol: "p"))
        currencyArray.append(currencyModel.init(country: "BELGIUM", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "BELIZE", threeDigitCode: "BZD", twoDigitCode: nil, symbol: "BZ$"))
        currencyArray.append(currencyModel.init(country: "BENIN", threeDigitCode: "XOF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "BERMUDA", threeDigitCode: "BMD", twoDigitCode: nil, symbol: "Bd$"))
        currencyArray.append(currencyModel.init(country: "BHUTAN", threeDigitCode: "INR", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "BHUTAN", threeDigitCode: "BTN", twoDigitCode: nil, symbol: "Nu"))
        currencyArray.append(currencyModel.init(country: "BOLIVIA (PLURINATIONAL STATE OF)", threeDigitCode: "BOB", twoDigitCode: nil, symbol: "Bs"))
        currencyArray.append(currencyModel.init(country: "BOLIVIA (PLURINATIONAL STATE OF)", threeDigitCode: "BOV", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "BONAIRE SINT EUSTATIUS AND SABA", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "USD", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "BOSNIA AND HERZEGOVINA", threeDigitCode: "BAM", twoDigitCode: nil, symbol: "KM"))
        currencyArray.append(currencyModel.init(country: "BOTSWANA", threeDigitCode: "BWP", twoDigitCode: nil, symbol: "P"))
        currencyArray.append(currencyModel.init(country: "BOUVET ISLAND", threeDigitCode: "NOK", twoDigitCode: nil, symbol: "kr"))
        currencyArray.append(currencyModel.init(country: "BRAZIL", threeDigitCode: "BRA", twoDigitCode: "BR", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "BRITISH INDIAN OCEAN TERRITORY", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "BRUNEI DARUSSALAM", threeDigitCode: "BND", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "BULGARIA", threeDigitCode: "BGN", twoDigitCode: nil, symbol: "лв"))
        currencyArray.append(currencyModel.init(country: "BURKINA FASO", threeDigitCode: "XOF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "BURUNDI", threeDigitCode: "BIF", twoDigitCode: nil, symbol: "Fbu"))
        currencyArray.append(currencyModel.init(country: "CABO VERDE", threeDigitCode: "CVE", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "CAMBODIA", threeDigitCode: "KHR", twoDigitCode: nil, symbol: "៛"))
        currencyArray.append(currencyModel.init(country: "CAMEROON", threeDigitCode: "XAF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "CANADA", threeDigitCode: "CAD", twoDigitCode: "CA", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "CAYMAN ISLANDS", threeDigitCode: "KYD", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "CENTRAL AFRICAN REPUBLIC", threeDigitCode: "XAF", twoDigitCode: "XAF", symbol: nil))
        currencyArray.append(currencyModel.init(country: "CHAD", threeDigitCode: "XAF", twoDigitCode: nil, symbol: "FCFA"))
        currencyArray.append(currencyModel.init(country: "CHILE", threeDigitCode: "CLP", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "CHILE", threeDigitCode: "CLF", twoDigitCode: "CL", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "CHINA", threeDigitCode: "CNY", twoDigitCode: "CN", symbol: "¥"))
        currencyArray.append(currencyModel.init(country: "CHRISTMAS ISLAND", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "COCOS (KEELING) ISLANDS (THE)", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "COLOMBIA", threeDigitCode: "COP", twoDigitCode: "CO", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "COLOMBIA", threeDigitCode: "COU", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "COMOROS", threeDigitCode: "KMF", twoDigitCode: nil, symbol: "CF"))
        currencyArray.append(currencyModel.init(country: "CONGO (THE DEMOCRATIC REPUBLIC OF THE)", threeDigitCode: "CDF", twoDigitCode: nil, symbol: "FC"))
        currencyArray.append(currencyModel.init(country: "CONGO", threeDigitCode: "XAF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "COOK ISLANDS", threeDigitCode: "NZD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "COSTA RICA", threeDigitCode: "CRC", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "C╘TE D'IVOIRE", threeDigitCode: "XOF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "CROATIA", threeDigitCode: "HRK", twoDigitCode: "HR", symbol: "kn"))
        currencyArray.append(currencyModel.init(country: "CUBA", threeDigitCode: "CUP", twoDigitCode: nil, symbol: "₱"))
        currencyArray.append(currencyModel.init(country: "CUBA", threeDigitCode: "CUC", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "CURA╟AO", threeDigitCode: "ANG", twoDigitCode: nil, symbol: "f"))
        currencyArray.append(currencyModel.init(country: "CYPRUS", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "CZECHIA", threeDigitCode: "CZK", twoDigitCode: "CZ", symbol: nil))
        currencyArray.append(currencyModel.init(country: "DENMARK", threeDigitCode: "DKK", twoDigitCode: nil, symbol: "kr"))
        currencyArray.append(currencyModel.init(country: "DJIBOUTI", threeDigitCode: "DJF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "DOMINICA", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "DOMINICAN REPUBLIC", threeDigitCode: "DOP", twoDigitCode: nil, symbol: "RD$"))
        currencyArray.append(currencyModel.init(country: "ECUADOR", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "EGYPT", threeDigitCode: "EGP", twoDigitCode: "EG", symbol: "eú"))
        currencyArray.append(currencyModel.init(country: "EL SALVADOR", threeDigitCode: "SVC", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "EL SALVADOR", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "EQUATORIAL GUINEA", threeDigitCode: "XAF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ERITREA", threeDigitCode: "ERN", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ESTONIA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "ETHIOPIA", threeDigitCode: "ETB", twoDigitCode: nil, symbol: "Br"))
        currencyArray.append(currencyModel.init(country: "EUROPEAN UNION", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "FALKLAND ISLANDS", threeDigitCode: "FKP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "FAROE ISLANDS", threeDigitCode: "DKK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "FIJI", threeDigitCode: "FJD", twoDigitCode: nil, symbol: "FJ$"))
        currencyArray.append(currencyModel.init(country: "FINLAND", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "FRANCE", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SWITZERLAND", threeDigitCode: "", twoDigitCode: "", symbol: "CHF"))
        currencyArray.append(currencyModel.init(country: "FRENCH GUIANA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "FRENCH POLYNESIA", threeDigitCode: "XPF", twoDigitCode: nil, symbol: "F"))
        currencyArray.append(currencyModel.init(country: "FRENCH SOUTHERN TERRITORIES", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "GABON", threeDigitCode: "XAF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GAMBIA (THE)", threeDigitCode: "GMD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GEORGIA", threeDigitCode: "GEL", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GERMANY", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "GHANA", threeDigitCode: "GHS", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GIBRALTAR", threeDigitCode: "GIP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GREECE", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "GREENLAND", threeDigitCode: "DKK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GRENADA", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GUADELOUPE", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "GUAM", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "GUATEMALA", threeDigitCode: "GTQ", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GUERNSEY", threeDigitCode: "GBP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GUINEA", threeDigitCode: "GNF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GUINEAnilBISSAU", threeDigitCode: "XOF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "GUYANA", threeDigitCode: "GYD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "HAITI", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "HEARD ISLAND AND McDONALD ISLANDS", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "HOLY SEE", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "HONDURAS", threeDigitCode: "HNL", twoDigitCode: nil, symbol: "L"))
        currencyArray.append(currencyModel.init(country: "HONG KONG", threeDigitCode: "HKD", twoDigitCode: nil, symbol: "HK$"))
        currencyArray.append(currencyModel.init(country: "HUNGARY", threeDigitCode: "HUF", twoDigitCode: nil, symbol: "Ft"))
        currencyArray.append(currencyModel.init(country: "ICELAND", threeDigitCode: "ISK", twoDigitCode: nil, symbol: "kr"))
        currencyArray.append(currencyModel.init(country: "INDIA", threeDigitCode: "INR", twoDigitCode: "IN", symbol: "₹"))
        currencyArray.append(currencyModel.init(country: "IND", threeDigitCode: "INR", twoDigitCode: "IN", symbol: "₹"))
        currencyArray.append(currencyModel.init(country: "INDONESIA", threeDigitCode: "IDR", twoDigitCode: "ID", symbol: "Rp"))
        currencyArray.append(currencyModel.init(country: "INTERNATIONAL MONETARY FUND (IMF)á", threeDigitCode: "XDR", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "IRAN (ISLAMIC REPUBLIC OF)", threeDigitCode: "IRR", twoDigitCode: "IR", symbol: nil))
        currencyArray.append(currencyModel.init(country: "IRAQ", threeDigitCode: "IQD", twoDigitCode: nil, symbol: "kr"))
        currencyArray.append(currencyModel.init(country: "IRELAND", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "ISLE OF MAN", threeDigitCode: "GBP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ISRAEL", threeDigitCode: "ILS", twoDigitCode: nil, symbol: "₪"))
        currencyArray.append(currencyModel.init(country: "ITALY", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "JAMAICA", threeDigitCode: "JMD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "JAPAN", threeDigitCode: "JPY", twoDigitCode: "JP", symbol: "¥"))
        currencyArray.append(currencyModel.init(country: "JERSEY", threeDigitCode: "GBP", twoDigitCode: nil, symbol: "£"))
        currencyArray.append(currencyModel.init(country: "JORDAN", threeDigitCode: "JOD", twoDigitCode: "JD", symbol: nil))
        currencyArray.append(currencyModel.init(country: "KAZAKHSTAN", threeDigitCode: "KZT", twoDigitCode: "KZ", symbol: nil))
        currencyArray.append(currencyModel.init(country: "KENYA", threeDigitCode: "KES", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "KIRIBATI", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "North Korea", threeDigitCode: "KPW", twoDigitCode: "KP", symbol: nil))
        currencyArray.append(currencyModel.init(country: "South Korea", threeDigitCode: "KRW", twoDigitCode: "KR", symbol: nil))
        currencyArray.append(currencyModel.init(country: "KUWAIT", threeDigitCode: "KWD", twoDigitCode: "KW", symbol: nil))
        currencyArray.append(currencyModel.init(country: "KYRGYZSTAN", threeDigitCode: "KGS", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "LAO PEOPLEÆS DEMOCRATIC REPUBLIC", threeDigitCode: "LAK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "LATVIA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "LEBANON", threeDigitCode: "LBP", twoDigitCode: nil, symbol: "ل"))
        currencyArray.append(currencyModel.init(country: "LESOTHO", threeDigitCode: "LSL", twoDigitCode: nil, symbol: "M"))
        currencyArray.append(currencyModel.init(country: "LESOTHO", threeDigitCode: "ZAR", twoDigitCode: nil, symbol: "L"))
        currencyArray.append(currencyModel.init(country: "LIBERIA", threeDigitCode: "LRD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "LIBYA", threeDigitCode: "LYD", twoDigitCode: "LY", symbol: "LD"))
        currencyArray.append(currencyModel.init(country: "LIECHTENSTEIN", threeDigitCode: "CHF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "LITHUANIA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "LUXEMBOURG", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "MACAO", threeDigitCode: "MOP", twoDigitCode: nil, symbol: "毫"))
        currencyArray.append(currencyModel.init(country: "MACEDONIA (THE FORMER YUGOSLAV REPUBLIC OF)", threeDigitCode: "MKD", twoDigitCode: "MK", symbol: "ден"))
        currencyArray.append(currencyModel.init(country: "MADAGASCAR", threeDigitCode: "MGA", twoDigitCode: nil, symbol: "Ar"))
        currencyArray.append(currencyModel.init(country: "MALAWI", threeDigitCode: "MWK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "MALAYSIA", threeDigitCode: "MYR", twoDigitCode: "MY", symbol: "RM"))
        currencyArray.append(currencyModel.init(country: "MALDIVES", threeDigitCode: "MVR", twoDigitCode: "MV", symbol: ".ރ"))
        currencyArray.append(currencyModel.init(country: "MALI", threeDigitCode: "XOF", twoDigitCode: "ML", symbol: "CFA"))
        currencyArray.append(currencyModel.init(country: "MALTA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "MARSHALL ISLANDS", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "MARTINIQUE", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "MAURITANIA", threeDigitCode: "MRU", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "MAURITIUS", threeDigitCode: "MUR", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "MAYOTTE", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "MEMBER COUNTRIES OF THE AFRICAN DEVELOPMENT BANK GROUP", threeDigitCode: "XUA", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "MEXICO", threeDigitCode: "MXN", twoDigitCode: nil, symbol: "Mex$"))
        currencyArray.append(currencyModel.init(country: "MICRONESIA (FEDERATED STATES OF)", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "MOLDOVA (THE REPUBLIC OF)", threeDigitCode: "MDL", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "MONACO", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "MONGOLIA", threeDigitCode: "MNT", twoDigitCode: nil, symbol: "₮"))
        currencyArray.append(currencyModel.init(country: "MONTENEGRO", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "MONTSERRAT", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "MOROCCO", threeDigitCode: "MAD", twoDigitCode: nil, symbol: ".د.م"))
        currencyArray.append(currencyModel.init(country: "MOZAMBIQUE", threeDigitCode: "MZN", twoDigitCode: nil, symbol: "MT"))
        currencyArray.append(currencyModel.init(country: "MYANMAR", threeDigitCode: "MMK", twoDigitCode: nil, symbol: "K"))
        currencyArray.append(currencyModel.init(country: "NAMIBIA", threeDigitCode: "ZAR", twoDigitCode: nil, symbol: "N$"))
        currencyArray.append(currencyModel.init(country: "NAURU", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "NEPAL", threeDigitCode: "NPR", twoDigitCode: nil, symbol: "रू"))
        currencyArray.append(currencyModel.init(country: "NETHERLANDS", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "NEW CALEDONIA", threeDigitCode: "XPF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "NEW ZEALAND", threeDigitCode: "NZD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "NICARAGUA", threeDigitCode: "NIO", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "NIGER", threeDigitCode: "XOF", twoDigitCode: nil, symbol: "CFA"))
        currencyArray.append(currencyModel.init(country: "NIGERIA", threeDigitCode: "NGN", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "NIUE", threeDigitCode: "NZD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "NORFOLK ISLAND", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "NORTHERN MARIANA ISLANDS", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "NORWAY", threeDigitCode: "NOK", twoDigitCode: nil, symbol: "kr"))
        currencyArray.append(currencyModel.init(country: "OMAN", threeDigitCode: "OMR",twoDigitCode: nil, symbol: "﷼"))
        currencyArray.append(currencyModel.init(country: "PAKISTAN", threeDigitCode: "PKR", twoDigitCode: "PK", symbol: "Rs"))
        currencyArray.append(currencyModel.init(country: "PAK", threeDigitCode: "PKR", twoDigitCode: "PK", symbol: "Rs"))
        currencyArray.append(currencyModel.init(country: "PALAU", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "PALESTINE STATE OF", threeDigitCode: nil, twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "PANAMA", threeDigitCode: "PAB", twoDigitCode: nil, symbol: "B/"))
        currencyArray.append(currencyModel.init(country: "PANAMA", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "PAPUA NEW GUINEA", threeDigitCode: "PGK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "PARAGUAY", threeDigitCode: "PYG", twoDigitCode: nil, symbol: "₲"))
        currencyArray.append(currencyModel.init(country: "PERU", threeDigitCode: "PEN", twoDigitCode: nil, symbol: "S/"))
        currencyArray.append(currencyModel.init(country: "PHILIPPINES", threeDigitCode: "PHP", twoDigitCode: nil, symbol: "₱"))
        currencyArray.append(currencyModel.init(country: "PITCAIRN", threeDigitCode: "NZD", twoDigitCode: "NZ", symbol: nil))
        currencyArray.append(currencyModel.init(country: "POLAND", threeDigitCode: "PLN", twoDigitCode: nil, symbol: "zł"))
        currencyArray.append(currencyModel.init(country: "PORTUGAL", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "PUERTO RICO", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "QATAR", threeDigitCode: "QAR", twoDigitCode: "QR", symbol: "﷼"))
        currencyArray.append(currencyModel.init(country: "R╔UNION", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "ROMANIA", threeDigitCode: "RON", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "RUSSIA", threeDigitCode: "RUB", twoDigitCode: "RU", symbol: "₽"))
        currencyArray.append(currencyModel.init(country: "RWANDA", threeDigitCode: "RWF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SAINT BARTH╔LEMY", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SAINT HELENA ASCENSION AND TRISTAN DA CUNHA", threeDigitCode: "SHP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SAINT KITTS AND NEVIS", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SAINT LUCIA", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SAINT MARTIN (FRENCH PART)", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SAINT PIERRE AND MIQUELON", threeDigitCode: "EUR",twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SAINT VINCENT AND THE GRENADINES", threeDigitCode: "XCD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SAMOA", threeDigitCode: "WST", twoDigitCode: nil, symbol: "$"))
        currencyArray.append(currencyModel.init(country: "SAN MARINO", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SAO TOME AND PRINCIPE", threeDigitCode: "STN", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SAUDI ARABIA", threeDigitCode: "SAR", twoDigitCode: nil, symbol: "SR"))
        currencyArray.append(currencyModel.init(country: "SENEGAL", threeDigitCode: "XOF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SERBIA", threeDigitCode: "RSD", twoDigitCode: nil, symbol: "РСД"))
        currencyArray.append(currencyModel.init(country: "SEYCHELLES", threeDigitCode: "SCR", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SIERRA LEONE", threeDigitCode: "SLL", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SINGAPORE", threeDigitCode: "SGD", twoDigitCode: "SG", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "SINT MAARTEN (DUTCH PART)", threeDigitCode: "ANG", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SISTEMA UNITARIO DE COMPENSACION REGIONAL DE PAGOS SUCRE", threeDigitCode: "XSU", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SLOVAKIA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SLOVENIA", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SOLOMON ISLANDS", threeDigitCode: "SBD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SOMALIA", threeDigitCode: "SOS", twoDigitCode: nil, symbol: "Sh"))
        currencyArray.append(currencyModel.init(country: "SOUTH AFRICA", threeDigitCode: "ZAR", twoDigitCode: nil, symbol: "R"))
        currencyArray.append(currencyModel.init(country: "SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS", threeDigitCode: nil,twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SOUTH SUDAN", threeDigitCode: "SSP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SPAIN", threeDigitCode: "EUR", twoDigitCode: "EU", symbol: "€"))
        currencyArray.append(currencyModel.init(country: "SRI LANKA", threeDigitCode: "LKR", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SUDAN", threeDigitCode: "SDG", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SURINAME", threeDigitCode: "SRD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SVALBARD AND JAN MAYEN", threeDigitCode: "NOK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ESWATINI", threeDigitCode: "SZL", twoDigitCode: "SZ", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "SWEDEN", threeDigitCode: "SEK", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SWITZERLAND", threeDigitCode: "CHF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SWITZERLAND", threeDigitCode: "CHE", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SWITZERLAND", threeDigitCode: "CHW", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "SYRIAN ARAB REPUBLIC", threeDigitCode: "SYP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TAIWAN (PROVINCE OF CHINA)", threeDigitCode: "TWD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TAJIKISTAN", threeDigitCode: "TJS", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TANZANIA UNITED REPUBLIC OF", threeDigitCode: "TZS", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "THAILAND", threeDigitCode: "THB", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TIMORnilLESTE", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "TOGO", threeDigitCode: "XOF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TOKELAU", threeDigitCode: "NZD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TONGA", threeDigitCode: "TOP", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TRINIDAD AND TOBAGO", threeDigitCode: "TTD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TUNISIA", threeDigitCode: "TND", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TURKEY", threeDigitCode: "TRY", twoDigitCode: "TR", symbol: nil))
        currencyArray.append(currencyModel.init(country: "TURKMENISTAN", threeDigitCode: "TMT", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "TURKS AND CAICOS ISLANDS", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "TUVALU", threeDigitCode: "AUD", twoDigitCode: "AU", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "UGANDA", threeDigitCode: "UGX", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "UKRAINE", threeDigitCode: "UAH", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "UNITED ARAB EMIRATES", threeDigitCode: "AED", twoDigitCode: "AE", symbol: nil))
        currencyArray.append(currencyModel.init(country: "UNITED KINGDOM OF GREAT BRITAIN AND NORTHERN IRELAND" , threeDigitCode: "GBP", twoDigitCode: "GB", symbol: "£"))
        currencyArray.append(currencyModel.init(country: "UNITED STATES MINOR OUTLYING ISLANDS", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "UNITED STATES OF AMERICA", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "USA", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "URUGUAY", threeDigitCode: "UYU", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "URUGUAY", threeDigitCode: "UYI", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "URUGUAY", threeDigitCode: "UYW", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "UZBEKISTAN", threeDigitCode: "UZS", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "VANUATU", threeDigitCode: "VUV", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "VENEZUELA (BOLIVARIAN REPUBLIC OF)", threeDigitCode: "VES", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "VIET NAM", threeDigitCode: "VND", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "VIRGIN ISLANDS (BRITISH)", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "VIRGIN ISLANDS (U.S.)", threeDigitCode: "USD", twoDigitCode: "US", symbol: "$"))
        currencyArray.append(currencyModel.init(country: "WALLIS AND FUTUNA", threeDigitCode: "XPF", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "WESTERN SAHARA", threeDigitCode: "MAD", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "YEMEN", threeDigitCode: "YER", twoDigitCode: nil, symbol: nil))
        currencyArray.append(currencyModel.init(country: "ZAMBIA", threeDigitCode: "ZMW", twoDigitCode: nil, symbol: "ZK"))
    }
    
    func getCurrencySymbolForListing(Country: String) -> String {
        var currencySymbol = ""
        if CurrencyManager.currencyArray.count == 0 {
            CurrencyManager.setupCurrencyArray()
        }else {
            print(CurrencyManager.currencyArray.count)
        }
        
        for item in CurrencyManager.currencyArray {
            print(item)
            let itemCountry = item.country ?? ""
            if itemCountry == Country{
                print(item)
                let threeDigitCode = item.threeDigitCode ?? ""
                let twodidgitCode = item.twoDigitCode ?? ""
                let symbol = item.symbol ?? ""
                if threeDigitCode != "" {
                    currencySymbol = "\(twodidgitCode) \(symbol)"
                }else {
                   currencySymbol = "\(threeDigitCode) \(symbol)"
                }
               
            }else if itemCountry.contains(Country) {
                print(item)
                let threeDigitCode = item.threeDigitCode ?? ""
                 let twodidgitCode = item.twoDigitCode ?? ""
                let symbol = item.symbol ?? ""
                if threeDigitCode != "" {
                    currencySymbol = "\(twodidgitCode) \(symbol)"
                }else {
                    currencySymbol = "\(threeDigitCode) \(symbol)"
                }
            }else {
                print("No Item Found")
            }
        }
        return currencySymbol
    }
    
    
    func getCurrencySymbol(Country: String) -> String {
        var currencySymbol = ""
        if CurrencyManager.currencyArray.count == 0 {
            CurrencyManager.setupCurrencyArray()
        }else {
            print(CurrencyManager.currencyArray.count)
        }
        
        for item in CurrencyManager.currencyArray {
            print(item)
            let itemCountry = item.country ?? ""
            if itemCountry == Country{
                print(item)
                let symbol = item.symbol ?? ""
                currencySymbol = "\(symbol)"
                
            }else if itemCountry.contains(Country) {
                print(item)
                let symbol = item.symbol ?? ""
                currencySymbol = "\(symbol)"
            }else {
                print("No Item Found")
            }
        }
        return currencySymbol
    }
    
    func getCurrencyTwoDigitCode(Country: String) -> String {
        var currencySymbol = ""
        if CurrencyManager.currencyArray.count == 0 {
            CurrencyManager.setupCurrencyArray()
        }else {
            print(CurrencyManager.currencyArray.count)
        }
        
        for item in CurrencyManager.currencyArray {
            print(item)
            let itemCountry = item.country ?? ""
            if itemCountry == Country{
                print(item)
                let symbol = item.twoDigitCode ?? ""
                currencySymbol = "\(symbol)"
                
            }else if itemCountry.contains(Country) {
                print(item)
                let symbol = item.twoDigitCode ?? ""
                currencySymbol = "\(symbol)"
            }else {
                print("No Item Found")
            }
        }
        return currencySymbol
    }
    
    func getCurrencyThreeDigitCode(Country: String) -> String {
        var currencySymbol = ""
        if CurrencyManager.currencyArray.count == 0 {
            CurrencyManager.setupCurrencyArray()
        }else {
            print(CurrencyManager.currencyArray.count)
        }
        
        for item in CurrencyManager.currencyArray {
            print(item)
            let itemCountry = item.country ?? ""
            if itemCountry == Country{
                print(item)
                let symbol = item.threeDigitCode ?? ""
                currencySymbol = "\(symbol)"
                
            }else if itemCountry.contains(Country) {
                print(item)
                let symbol = item.threeDigitCode ?? ""
                currencySymbol = "\(symbol)"
            }else {
                print("No Item Found")
            }
        }
        return currencySymbol
    }
    
    
    
     func getCurrencySymbolForMain(Country: String, Price: String) -> String {
        var currencySymbol = ""
        if CurrencyManager.currencyArray.count == 0 {
            CurrencyManager.setupCurrencyArray()
        }else {
            print(CurrencyManager.currencyArray.count)
        }
        for item in CurrencyManager.currencyArray {
            print(item)
            let itemCountry = item.country ?? ""
            if itemCountry == Country{
                print(item)
                let threeDigitCode = item.threeDigitCode ?? ""
                let symbol = item.symbol ?? ""
                if symbol == "" {
                    currencySymbol = "\(threeDigitCode) "
                }
                else {
                    currencySymbol = "\(symbol)"
                }
                
            }else if itemCountry.contains(Country) {
                print(item)
                let threeDigitCode = item.threeDigitCode ?? ""
                let symbol = item.symbol ?? ""
                if symbol == "" {
                    currencySymbol = "\(threeDigitCode) "
                }else {
                    currencySymbol = "\(symbol)"
                }
            }else {
                print("No Item Found")
            }
        }
        return currencySymbol + Price
    }
    
    
    
}
