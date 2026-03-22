//
//  ProductFilterStateTests.swift
//  OuluBankR1Tests
//
//  Created by Mohammad Azam on 2/26/25.
//

import Testing
@testable import OuluBankR1

struct ProductFilterStateTests {

    @Test func product_filter_state_filters_successfully()  {
        
        var productFilterState = ProductFilterState()
        productFilterState.min = 10
        productFilterState.max = 30
       
        let products = [Product(price: 12), Product(price: 34), Product(price: 20)]
        
        let expectedProducts = [Product(price: 12), Product(price: 20)]
        
        let filteredProducts = productFilterState.filteredProducts(products)
        
        #expect(filteredProducts.count == 2)
        #expect(filteredProducts == expectedProducts)
    }

}
