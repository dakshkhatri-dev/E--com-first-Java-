CREATE TABLE profile (
                         user_id BIGINT PRIMARY KEY,

                         name VARCHAR(100) NOT NULL,

                         email VARCHAR(255) NOT NULL UNIQUE,

                         password VARCHAR(255) NOT NULL,

                         CONSTRAINT fk_profile_account
                             FOREIGN KEY (user_id)
                                 REFERENCES accounts(user_id)
                                 ON DELETE CASCADE
);