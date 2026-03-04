
-- 1. Bảng Người dùng (Users)
CREATE TABLE IF NOT EXISTS users (
                       user_id SERIAL PRIMARY KEY,              -- SERIAL tự động tăng ID từ 1
                       password VARCHAR(255) NOT NULL,          -- Cần đủ dài để lưu mật khẩu đã băm (hash)
                       first_name VARCHAR(50) NOT NULL,
                       middle_name VARCHAR(50),                 -- Có thể bỏ trống (NULL)
                       phone_number VARCHAR(15) UNIQUE,         -- SĐT nên là duy nhất để đăng nhập/liên hệ
                       address TEXT,
                       email VARCHAR(100) UNIQUE NOT NULL,      -- Email đăng nhập cũng phải duy nhất
                       role VARCHAR(20) NOT NULL                -- Phân quyền: 'ADMIN', 'CUSTOMER', v.v.
);

-- 2. Bảng Danh mục tin tức (News Categories)
CREATE TABLE IF NOT EXISTS news_categories (
                                 news_category_id SERIAL PRIMARY KEY,
                                 category_name VARCHAR(100) NOT NULL
);

-- 3. Bảng Vùng miền (Regions) - Phục vụ cho "Trạm Đặc Sản"
CREATE TABLE IF NOT EXISTS regions (
                         region_id SERIAL PRIMARY KEY,
                         name VARCHAR(100) NOT NULL,              -- Ví dụ: Tây Bắc, ĐBSCL...
                         description TEXT
);

-- 4. Bảng Sản phẩm (Products)
-- Phụ thuộc vào: Regions
CREATE TABLE IF NOT EXISTS products (
                          product_id SERIAL PRIMARY KEY,
                          name VARCHAR(200) NOT NULL,
                          description TEXT,
                          price DECIMAL(12, 2) NOT NULL,           -- Dùng DECIMAL cho tiền tệ để không bị sai số
                          image_url TEXT,
                          stock_quantity INT DEFAULT 0,            -- Số lượng tồn kho, mặc định là 0
                          average_rating DECIMAL(3, 2) DEFAULT 0,  -- Điểm đánh giá trung bình (ví dụ: 4.50)
                          total_sold INT DEFAULT 0,                -- Tổng số đã bán
                          region_id INT,                           -- Khóa ngoại chỉ đến vùng miền
                          FOREIGN KEY (region_id) REFERENCES regions(region_id) ON DELETE SET NULL
);

-- 5. Bảng Tin tức (News)
-- Phụ thuộc vào: Users (Tác giả) và News Categories
CREATE TABLE IF NOT EXISTS news (
                      news_id SERIAL PRIMARY KEY,
                      title VARCHAR(255) NOT NULL,             -- Linh sửa lại chữ "Tittle" trong hình thành "Title" cho đúng chính tả nhé
                      content TEXT NOT NULL,
                      published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Tự động lấy giờ hệ thống lúc tạo
                      news_category_id INT,
                      author_id INT,                           -- Nối với user_id của bảng users
                      FOREIGN KEY (news_category_id) REFERENCES news_categories(news_category_id) ON DELETE SET NULL,
                      FOREIGN KEY (author_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 6. Bảng Đánh giá (Reviews)
-- Phụ thuộc vào: Products và Users
CREATE TABLE IF NOT EXISTS reviews (
                         review_id SERIAL PRIMARY KEY,
                         content TEXT,
                         rating INT CHECK (rating >= 1 AND rating <= 5), -- Ràng buộc điểm đánh giá từ 1 đến 5 sao
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         product_id INT NOT NULL,
                         user_id INT NOT NULL,
                         FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
                         FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 7. Bảng Đơn hàng (Orders)
-- Phụ thuộc vào: Users
CREATE TABLE IF NOT EXISTS orders (
                        order_id SERIAL PRIMARY KEY,
                        subtotal DECIMAL(12, 2) NOT NULL,        -- Tổng tiền hàng chưa tính phí ship
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        status VARCHAR(50) NOT NULL,             -- Trạng thái: PENDING, SHIPPING, COMPLETED...
                        shipping_fee DECIMAL(12, 2) DEFAULT 0,
                        shipping_address TEXT NOT NULL,
                        total_amount DECIMAL(12, 2) NOT NULL,    -- Tổng tiền cuối cùng khách phải trả
                        recipient_full_name VARCHAR(100) NOT NULL,
                        recipient_phone_number VARCHAR(15) NOT NULL,
                        recipient_email VARCHAR(100),
                        note TEXT,
                        payment_method VARCHAR(50) NOT NULL,     -- Ví dụ: COD, VNPAY, MOMO
                        user_id INT NOT NULL,                    -- Người đặt hàng
                        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

-- 8. Bảng Chi tiết đơn hàng (Order Items)
-- Bảng trung gian, phụ thuộc vào: Orders và Products
CREATE TABLE IF NOT EXISTS order_items (
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL CHECK (quantity > 0), -- Mua ít nhất phải là 1 cái
                             unit_price DECIMAL(12, 2) NOT NULL,         -- Lưu lại giá lúc mua, đề phòng sau này giá sản phẩm thay đổi
                             PRIMARY KEY (order_id, product_id),         -- Khóa chính kép (Composite Key)
                             FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
                             FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);