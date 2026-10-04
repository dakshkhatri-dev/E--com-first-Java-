package com.test.ecom.user.product;


import com.test.ecom.user.product.dto.ParamFilters;
import com.test.ecom.user.product.dto.ProductResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/user/products")
public class ProductController {

    private final ProductRepository productRepository;

    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping()
    private ResponseEntity<List<ProductResponse>> products(ParamFilters filters){
        List<ProductResponse> products = productRepository. getFilteredProducts(filters);
        return ResponseEntity.status(HttpStatus.OK).body(products);
    }

}
