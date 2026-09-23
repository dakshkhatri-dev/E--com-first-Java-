CREATE TABLE address (
                         user_id BIGINT PRIMARY KEY,

                         pin_code VARCHAR(10) NOT NULL,

                         city VARCHAR(100) NOT NULL,

                         state VARCHAR(100) NOT NULL,

                         house_no VARCHAR(50) NOT NULL,

                         street_address VARCHAR(255) NOT NULL,

                         CONSTRAINT fk_address_account
                             FOREIGN KEY (user_id)
                                 REFERENCES accounts(user_id)
                                 ON DELETE CASCADE
);