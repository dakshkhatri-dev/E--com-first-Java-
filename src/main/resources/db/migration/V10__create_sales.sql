CREATE TABLE sales (
                       sale_id BIGSERIAL PRIMARY KEY,

                       product_id BIGINT NOT NULL,

                       selling_price NUMERIC(12,2) NOT NULL,

                       cost_price NUMERIC(12,2) NOT NULL,

                       quantity_sold INTEGER NOT NULL,

                       sold_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

                       CONSTRAINT chk_sale_selling_price
                           CHECK (selling_price >= 0),

                       CONSTRAINT chk_sale_cost_price
                           CHECK (cost_price >= 0),

                       CONSTRAINT chk_sale_quantity
                           CHECK (quantity_sold > 0),

                       CONSTRAINT fk_sale_product
                           FOREIGN KEY (product_id)
                               REFERENCES products(p_id)
                               ON DELETE RESTRICT
);

CREATE INDEX idx_sales_product_id
    ON sales(product_id);

CREATE INDEX idx_sales_sold_at
    ON sales(sold_at);