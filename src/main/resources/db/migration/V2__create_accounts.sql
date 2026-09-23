CREATE TABLE accounts (
                          user_id BIGSERIAL PRIMARY KEY,

                          account_status account_status NOT NULL DEFAULT 'ACTIVE',

                          role user_role NOT NULL DEFAULT 'USER'
);