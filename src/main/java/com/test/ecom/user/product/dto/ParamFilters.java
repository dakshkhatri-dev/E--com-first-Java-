package com.test.ecom.user.product.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
public class ParamFilters {
    private String brandCode;       // Fixed naming & added private
    private String categorySlug;
    private String subCategorySlug;
    private String title;
    private BigDecimal minPrice;   // Changed float -> BigDecimal
    private BigDecimal maxPrice;   // Changed float -> BigDecimal
    private Boolean inStock;       // Changed boolean -> Boolean (wrapper)
}