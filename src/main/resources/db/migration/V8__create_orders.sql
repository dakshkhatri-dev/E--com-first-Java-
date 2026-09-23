CREATE TABLE orders (
                        order_id BIGSERIAL PRIMARY KEY,

                        user_id BIGINT NOT NULL,

                        total_amount NUMERIC(12,2) NOT NULL,

                        status order_status NOT NULL DEFAULT 'PLACED',

                        payment_status payment_status NOT NULL DEFAULT 'PENDING',

                        created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

                        CONSTRAINT chk_order_total
                            CHECK (total_amount >= 0),

                        CONSTRAINT fk_order_user
                            FOREIGN KEY (user_id)
                                REFERENCES accounts(user_id)
                                ON DELETE RESTRICT,

                        CONSTRAINT chk_order_delivered_requires_payment
                            CHECK (
                                status <> 'DELIVERED'
                                    OR payment_status = 'PAID'
                                )
);

CREATE INDEX idx_orders_user_id
    ON orders(user_id);

CREATE INDEX idx_orders_status
    ON orders(status);