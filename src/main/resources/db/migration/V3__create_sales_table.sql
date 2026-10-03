-- =============================================================================
-- MIGRATION: 003_create_sales_table.sql
-- DESCRIPTION: Sets up Sales/Order Line Items table with auto-calculated revenue & profit
-- =============================================================================

BEGIN;

CREATE TABLE sales (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    -- Foreign Keys for relationship tracking
    product_id BIGINT REFERENCES products(id) ON DELETE SET NULL,
    variant_id BIGINT REFERENCES product_variants(id) ON DELETE SET NULL,
    dealer_id BIGINT REFERENCES dealers(id) ON DELETE SET NULL,

    -- Snapshot fields (preserves record accuracy even if titles/SKUs update later)
    product_title VARCHAR(255) NOT NULL,
    sku VARCHAR(100),

    -- Unit Pricing & Volume
    cost_price NUMERIC(12, 2) NOT NULL CHECK (cost_price >= 0),
    selling_price NUMERIC(12, 2) NOT NULL CHECK (selling_price >= 0),
    quantity_sold INT NOT NULL CHECK (quantity_sold > 0),

    -- AUTO-CALCULATED FINANCIAL TOTALS
   total_cost NUMERIC(12,2) GENERATED  ALWAYS AS (
       ROUND((cost_price * quantity_sold)::numeric,2)
   )STORED,

    total_revenue NUMERIC(12, 2) GENERATED ALWAYS AS (
        ROUND((selling_price * quantity_sold)::numeric, 2)
    ) STORED,

    -- Auto-calculated total profit: (selling_price - cost_price) * quantity_sold
    profit NUMERIC(12, 2) GENERATED ALWAYS AS (
        ROUND(((selling_price - cost_price) * quantity_sold)::numeric, 2)
    ) STORED,

    sold_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- GUARD: Prevent recording sales sold at or below cost
    CONSTRAINT chk_sales_selling_above_cost CHECK (selling_price > cost_price)
);

-- =============================================================================
-- INDEXES FOR FAST REPORTING & ANALYTICS
-- =============================================================================

CREATE INDEX idx_sales_product_id ON sales(product_id);
CREATE INDEX idx_sales_variant_id ON sales(variant_id);
CREATE INDEX idx_sales_dealer_id ON sales(dealer_id);
CREATE INDEX idx_sales_sold_at ON sales(sold_at);

-- =============================================================================
-- SEED DATA DEMONSTRATION
-- =============================================================================

-- Record a sale of 2 units
-- Cost = 75,000.00, Selling = 90,000.00, Quantity = 2
-- Database will automatically compute:
--   total_cost = 150,000.00
--   total_revenue = 180,000.00
--   profit = 30,000.00
INSERT INTO sales (
    product_id,
    variant_id,
    dealer_id,
    product_title,
    sku,
    cost_price,
    selling_price,
    quantity_sold
) VALUES (
    (SELECT id FROM products WHERE slug = 'apple-macbook-pro-14-inch'),
    (SELECT id FROM product_variants WHERE mpn_model_no = 'MKGP3HN/A'),
    (SELECT id FROM dealers WHERE code = 'WH-DEL-01'),
    'Apple MacBook Pro 14-Inch',
    'SKU-APL-MBP14-SG16',
    75000.00,
    90000.00,
    2
);

COMMIT;