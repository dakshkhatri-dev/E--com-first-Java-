package com.test.ecom.user.product.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class VariantResponse {
    private int inventoryId;
    private String modelNo;
    private String sku;
    private double mrp;
    private double sellingPrice;
    private int stockQuantity;
    private String attributesJson;
}