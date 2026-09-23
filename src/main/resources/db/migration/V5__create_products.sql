CREATE TABLE products (
                          p_id BIGSERIAL PRIMARY KEY,

                          p_name VARCHAR(150) NOT NULL,

                          p_brand VARCHAR(100) NOT NULL,

                          p_category VARCHAR(100) NOT NULL,

                          p_image_url TEXT NOT NULL,

                          p_cost_price NUMERIC(12,2) NOT NULL,

                          p_sell_price NUMERIC(12,2) NOT NULL,

                          p_quantity INTEGER NOT NULL,

                          CONSTRAINT chk_product_cost_price
                              CHECK (p_cost_price >= 0),

                          CONSTRAINT chk_product_sell_price
                              CHECK (p_sell_price >= 0),

                          CONSTRAINT chk_product_quantity
                              CHECK (p_quantity >= 0),

                          CONSTRAINT uq_product_identity
                              UNIQUE (
                                      p_name,
                                      p_brand,
                                      p_category,
                                      p_cost_price,
                                      p_sell_price
                                  )
);

CREATE INDEX idx_products_category
    ON products(p_category);

CREATE INDEX idx_products_brand
    ON products(p_brand);