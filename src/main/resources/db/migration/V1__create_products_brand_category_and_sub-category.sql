

-- =============================================================================
-- MIGRATION: 001_create_brands_and_categories.sql
-- DESCRIPTION: Sets up Brand, Category, and Sub-Category tables for e-commerce
-- =============================================================================


BEGIN;


-- 1. BRANDS TABLE
CREATE TABLE brands (
                        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                        name VARCHAR(100) NOT NULL UNIQUE,
                        code VARCHAR(50) UNIQUE, -- e.g. 'APL' for Apple, 'LVI' for Levi's
                        logo_url VARCHAR(500),
                        is_active BOOLEAN NOT NULL DEFAULT TRUE,
                        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. CATEGORIES TABLE (Top Level: Electronics, Apparel, etc.)
CREATE TABLE categories (
                            id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                            name VARCHAR(100) NOT NULL UNIQUE,
                            slug VARCHAR(120) NOT NULL UNIQUE, -- e.g. 'electronics', 'apparel'
                            is_active BOOLEAN NOT NULL DEFAULT TRUE,
                            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- 3. SUB-CATEGORIES TABLE (Child Level: Laptops, Jeans, Shirts)
CREATE TABLE sub_categories (
                                id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                category_id BIGINT NOT NULL  REFERENCES categories(id) ON DELETE RESTRICT ,
                                name VARCHAR(100) NOT NULL,
                                slug VARCHAR(120) NOT NULL UNIQUE, -- e.g. 'laptops', 'mens-jeans'
                                is_active BOOLEAN NOT NULL DEFAULT TRUE,
                                created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- Prevent duplicate sub-category names within the same parent category
                                CONSTRAINT uq_category_subcategory_name UNIQUE (category_id, name)
);


-- =============================================================================
-- INDEXES FOR FAST LOOKUPS & SEARCH
-- =============================================================================

CREATE INDEX idx_brands_name ON brands(name);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_sub_categories_category_id ON sub_categories(category_id);
CREATE INDEX idx_sub_categories_slug ON sub_categories(slug);



-- =============================================================================
-- SEED DATA (INITIAL CATEGORIES & BRANDS)
-- =============================================================================

-- Insert Brands
INSERT INTO brands (name, code) VALUES
                                    ('Apple', 'APL'),
                                    ('Samsung', 'SSG'),
                                    ('Levi''s', 'LVI'),
                                    ('Zara', 'ZRA');

-- Insert Main Categories
INSERT INTO categories (name, slug) VALUES
                                        ('Electronics', 'electronics'),
                                        ('Apparel & Fashion', 'apparel-fashion');

-- Insert Sub-Categories linked to Categories
INSERT INTO sub_categories (category_id, name, slug) VALUES
                             ((SELECT id FROM categories WHERE slug = 'electronics'), 'Laptops', 'laptops'),
                             ((SELECT id FROM categories WHERE slug = 'electronics'), 'Smartphones', 'smartphones'),
                             ((SELECT id FROM categories WHERE slug = 'apparel-fashion'), 'Men''s Jeans', 'mens-jeans'),
                             ((SELECT id FROM categories WHERE slug = 'apparel-fashion'), 'Shirts', 'shirts');


COMMIT;