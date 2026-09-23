CREATE TYPE account_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);

CREATE TYPE user_role AS ENUM (
    'USER',
    'ADMIN'
);

CREATE TYPE cart_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);

CREATE TYPE order_status AS ENUM (
    'PLACED',
    'CANCELLED',
    'DELIVERED'
);

CREATE TYPE payment_status AS ENUM (
    'PENDING',
    'PAID',
    'FAILED',
    'REFUNDED'
);