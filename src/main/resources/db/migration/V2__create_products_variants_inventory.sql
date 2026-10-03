-- =============================================================================
-- MIGRATION: 002_create_products_variants_inventory.sql (UPDATED WITH DISCOUNT FORMULA)
-- DESCRIPTION: Sets up Products, Dynamic Variants, Dealers, and Auto-Calculated Inventory
-- SETUP: Single-Seller System
-- =============================================================================

BEGIN;

-- 1. DEALERS TABLE
CREATE TABLE dealers (
                         id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                         name VARCHAR(150) NOT NULL,
                         code VARCHAR(50) UNIQUE, -- e.g. 'DL-DELHI-01'
                         phone VARCHAR(20),
                         email VARCHAR(150),
                         address TEXT,
                         city VARCHAR(100),
                         state VARCHAR(100),
                         pin_code VARCHAR(20),
                         is_active BOOLEAN NOT NULL DEFAULT TRUE,
                         created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                         updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. PRODUCTS TABLE
CREATE TABLE products (
                          id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                          brand_id BIGINT REFERENCES brands(id) ON DELETE SET NULL,
                          category_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
                          sub_category_id BIGINT REFERENCES sub_categories(id) ON DELETE RESTRICT,
                          title VARCHAR(255) NOT NULL,
                          slug VARCHAR(255) NOT NULL UNIQUE,-- important
                          description TEXT,
                          is_active BOOLEAN NOT NULL DEFAULT TRUE,
                          created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                          updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. PRODUCT VARIANTS TABLE
CREATE TABLE product_variants (
                                  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                  product_id BIGINT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
                                  mpn_model_no VARCHAR(100),
                                  attributes JSONB NOT NULL DEFAULT '{}'::jsonb,
                                  is_active BOOLEAN NOT NULL DEFAULT TRUE,
                                  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                                  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

                                  CONSTRAINT uq_variant_mpn UNIQUE (mpn_model_no)
);

-- 4. INVENTORY TABLE (With Auto-Calculated Selling Price based on MRP & Discount )
CREATE TABLE inventory (
                           id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                           variant_id BIGINT NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
                           dealer_id BIGINT NOT NULL REFERENCES dealers(id) ON DELETE RESTRICT,
                           sku VARCHAR(100) NOT NULL,
                           mrp NUMERIC(12, 2) NOT NULL CHECK (mrp >= 0),

    -- Discount percentage  (0 to 100 integer)
                           discount INT NOT NULL DEFAULT 0 CHECK (discount>= 0 AND discount <= 100),

    -- Selling Price auto-generated: mrp * (100 - discount) / 100
                           selling_price NUMERIC(12,2) GENERATED ALWAYS AS(
                               ROUND((mrp * (100 - discount)::numeric / 100.00),2)
                              ) STORED ,

                           cost_price NUMERIC(12, 2) CHECK (cost_price >= 0),
                           stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
                           is_active BOOLEAN NOT NULL DEFAULT TRUE,
                           created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

                           CONSTRAINT uq_variant_dealer UNIQUE (variant_id, dealer_id),
                           CONSTRAINT uq_inventory_sku UNIQUE (sku),
                            -- PROFIT GUARD: Selling price MUST be strictly greater than cost price
                          CONSTRAINT chk_selling_price_above_cost CHECK (selling_price > cost_price)
);

-- =============================================================================
-- INDEXES FOR HIGH-PERFORMANCE SEARCH & FILTERING
-- =============================================================================

CREATE INDEX idx_products_brand_id ON products(brand_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_sub_category_id ON products(sub_category_id);
CREATE INDEX idx_products_slug ON products(slug);

CREATE INDEX idx_variants_product_id ON product_variants(product_id);
CREATE INDEX idx_inventory_variant_id ON inventory(variant_id);
CREATE INDEX idx_inventory_dealer_id ON inventory(dealer_id);
CREATE INDEX idx_inventory_sku ON inventory(sku);

-- GIN Index for fast JSON attribute filtering (color, storage, size)
CREATE INDEX idx_variants_attributes ON product_variants USING GIN (attributes);

-- =============================================================================
-- SEED DATA DEMONSTRATING AUTO-CALCULATED SELLING PRICE
-- =============================================================================

INSERT INTO dealers (name, code, city, state) VALUES
    ('Central Warehouse - Delhi', 'WH-DEL-01', 'Delhi', 'Delhi');

INSERT INTO products (brand_id, category_id, sub_category_id, title, slug, description) VALUES
    (
        (SELECT id FROM brands WHERE code = 'APL'),
        (SELECT id FROM categories WHERE slug = 'electronics'),
        (SELECT id FROM sub_categories WHERE slug = 'laptops'),
        'Apple MacBook Pro 14-Inch',
        'apple-macbook-pro-14-inch',
        'M-series powered high performance workstation laptop.'
    );

INSERT INTO product_variants (product_id, mpn_model_no, attributes) VALUES
    (
        (SELECT id FROM products WHERE slug = 'apple-macbook-pro-14-inch'),
        'MKGP3HN/A',
        '{"color": "Space Gray", "ram": "16GB", "storage": "512GB", "chip": "M3"}'::jsonb
    );

-- Insert Inventory with MRP = 100,000 and Discount  = 10%
-- The selling_price column will automatically compute to 90,000.00
INSERT INTO inventory (variant_id, dealer_id, sku, mrp, discount, cost_price, stock_quantity) VALUES
    (
        (SELECT id FROM product_variants WHERE mpn_model_no = 'MKGP3HN/A'),
        (SELECT id FROM dealers WHERE code = 'WH-DEL-01'),
        'SKU-APL-MBP14-SG16',
        100000.00,
        10, -- 10% Discount
        75000.00,
        25
    );

COMMIT;