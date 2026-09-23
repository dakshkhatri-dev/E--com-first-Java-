CREATE TABLE order_items (
                             order_item_id BIGSERIAL PRIMARY KEY,

                             order_id BIGINT NOT NULL,

                             product_id BIGINT NOT NULL,

                             quantity INTEGER NOT NULL,

                             unit_price NUMERIC(12,2) NOT NULL,

                             CONSTRAINT chk_order_item_quantity
                                 CHECK (quantity > 0),

                             CONSTRAINT chk_order_item_price
                                 CHECK (unit_price >= 0),

                             CONSTRAINT fk_order_item_order
                                 FOREIGN KEY (order_id)
                                     REFERENCES orders(order_id)
                                     ON DELETE CASCADE,

                             CONSTRAINT fk_order_item_product
                                 FOREIGN KEY (product_id)
                                     REFERENCES products(p_id)
                                     ON DELETE RESTRICT
);

CREATE INDEX idx_order_items_order_id
    ON order_items(order_id);

CREATE INDEX idx_order_items_product_id
    ON order_items(product_id);