CREATE TABLE cart_items (
                            cart_item_id BIGSERIAL PRIMARY KEY,

                            cart_id BIGINT NOT NULL,

                            p_id BIGINT NOT NULL,

                            c_quantity INTEGER NOT NULL,

                            CONSTRAINT chk_cart_item_quantity
                                CHECK (c_quantity > 0),

                            CONSTRAINT fk_cart_item_cart
                                FOREIGN KEY (cart_id)
                                    REFERENCES carts(cart_id)
                                    ON DELETE CASCADE,

                            CONSTRAINT fk_cart_item_product
                                FOREIGN KEY (p_id)
                                    REFERENCES products(p_id)
                                    ON DELETE RESTRICT,

                            CONSTRAINT uq_cart_product
                                UNIQUE (cart_id, p_id)
);

CREATE INDEX idx_cart_items_cart_id
    ON cart_items(cart_id);

CREATE INDEX idx_cart_items_product_id
    ON cart_items(p_id);