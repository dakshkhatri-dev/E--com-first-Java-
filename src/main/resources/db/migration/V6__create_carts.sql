CREATE TABLE carts (
                       cart_id BIGSERIAL PRIMARY KEY,

                       user_id BIGINT NOT NULL,

                       status cart_status NOT NULL DEFAULT 'ACTIVE',

                       CONSTRAINT fk_cart_user
                           FOREIGN KEY (user_id)
                               REFERENCES accounts(user_id)
                               ON DELETE CASCADE
);

CREATE INDEX idx_carts_user_id
    ON carts(user_id);

CREATE INDEX idx_carts_status
    ON carts(status);

CREATE UNIQUE INDEX uq_active_cart_per_user
    ON carts(user_id)
    WHERE status = 'ACTIVE';