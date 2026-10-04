package com.test.ecom.user.product;

import com.test.ecom.user.product.dto.ParamFilters;
import com.test.ecom.user.product.dto.ProductResponse;
import com.test.ecom.user.product.dto.VariantResponse;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository
public class ProductRepository {

    private final NamedParameterJdbcTemplate jdbcTemplate;

    public ProductRepository(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<ProductResponse> getFilteredProducts(ParamFilters filters) {
        String sql = """
          SELECT 
                p.id AS product_id,
                p.title,
                p.description,
                p.slug AS product_slug,
                b.code AS brand_code,
                b.name AS brand_name,
                c.slug AS category_slug,
                c.name AS category_name,
                sc.slug AS sub_category_slug,
                sc.name AS sub_category_name,
                i.id AS inventory_id,
                pv.id AS variant_id,
                pv.mpn_model_no,
                i.sku,
                i.mrp,
                i.selling_price,
                i.stock_quantity,
                pv.attributes::text AS attributes_json
            FROM products p
            LEFT JOIN brands b ON p.brand_id = b.id
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN sub_categories sc ON p.sub_category_id = sc.id
            LEFT JOIN product_variants pv ON pv.product_id = p.id
            LEFT JOIN inventory i ON i.variant_id = pv.id
            WHERE 1=1
              AND (:brandCode IS NULL OR :brandCode = '' OR b.code = :brandCode)
              AND (:categorySlug IS NULL OR :categorySlug = '' OR c.slug = :categorySlug)
              AND (:subCategorySlug IS NULL OR :subCategorySlug = '' OR sc.slug = :subCategorySlug)
              AND (:title IS NULL OR :title = '' OR p.title ILIKE '%' || :title || '%')
              AND (:minPrice IS NULL OR i.selling_price >= :minPrice)
              AND (:maxPrice IS NULL OR i.selling_price <= :maxPrice)
              AND (:inStock IS NULL OR (:inStock = true AND i.stock_quantity > 0))
            ORDER BY p.id, pv.id;
            """;

        // Step A: Convert DTO params into SQL parameters
        BeanPropertySqlParameterSource params = new BeanPropertySqlParameterSource(filters);

        // Step B: Use a Map to combine duplicate product rows into a single product with multiple variants
        Map<Integer, ProductResponse> productMap = new LinkedHashMap<>();

        jdbcTemplate.query(sql, params, rs -> {
            int productId = rs.getInt("product_id");

            // Check if we already created this product object in our map
            ProductResponse product = productMap.get(productId);

            // If product isn't in map yet, create it once
            if (product == null) {
                product = new ProductResponse();
                product.setProductId(productId);
                product.setTitle(rs.getString("title"));
                product.setDescription(rs.getString("description"));
                product.setProductSlug(rs.getString("product_slug"));
                product.setBrandCode(rs.getString("brand_code"));
                product.setBrandName(rs.getString("brand_name"));
                product.setCategorySlug(rs.getString("category_slug"));
                product.setCategoryName(rs.getString("category_name"));
                product.setSubCategorySlug(rs.getString("sub_category_slug"));
                product.setSubCategoryName(rs.getString("sub_category_name"));

                // Store in map so we can reuse it when next row has same productId
                productMap.put(productId, product);
            }

            // Create variant object for current row
            VariantResponse variant = new VariantResponse();
            variant.setInventoryId(rs.getInt("inventory_id"));
            variant.setModelNo(rs.getString("mpn_model_no"));
            variant.setSku(rs.getString("sku"));
            variant.setMrp(rs.getDouble("mrp"));
            variant.setSellingPrice(rs.getDouble("selling_price"));
            variant.setStockQuantity(rs.getInt("stock_quantity"));
            variant.setAttributesJson(rs.getString("attributes_json"));

            // Add variant to product's variants list
            product.getVariants().add(variant);
        });

        // Step C: Return list of unique products containing their nested variants
        return new ArrayList<>(productMap.values());
    }
}