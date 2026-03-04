-- =========================================================================
-- 1. NẠP DỮ LIỆU BẢNG ĐỘC LẬP
-- =========================================================================

-- Nạp Người dùng (Users)
-- Mật khẩu ở đây Linh để text nháp (123456), thực tế khi làm code Java cậu nhớ dùng BCrypt để mã hóa (hash) nhé!
INSERT INTO users (user_id, password, first_name, middle_name, phone_number, address, email, role) VALUES
                                                                                                       (1, 'hashed_password_123', 'Anh', 'Việt Nguyễn', '0987654321', 'Hà Nội', 'vanh.admin@tramdacsan.vn', 'ADMIN'),
                                                                                                       (2, 'hashed_password_456', 'Linh', 'Thị', '0912345678', 'Đà Nẵng', 'linh.khachhang@gmail.com', 'CUSTOMER'),
                                                                                                       (3, 'hashed_password_789', 'Thắng', 'Duy', '0909090909', 'TP.HCM', 'thang.khachhang@gmail.com', 'CUSTOMER');

-- Nạp Vùng miền (Regions)
INSERT INTO regions (region_id, name, description) VALUES
                                                       (1, 'Tây Bắc', 'Vùng núi cao với các món nướng, gác bếp đậm vị mắc khén, hạt dổi.'),
                                                       (2, 'Miền Trung', 'Xứ sở của các loại mắm, hải sản khô nắng gió và trái cây nhiệt đới.'),
                                                       (3, 'Tây Nguyên', 'Thủ phủ cà phê, ca cao và các loại hạt dinh dưỡng thiên nhiên.'),
                                                       (4, 'Đồng Bằng Sông Cửu Long', 'Vựa lúa và trái cây lớn nhất cả nước, nổi tiếng với các loại bánh kẹo truyền thống.');

-- Nạp Danh mục tin tức (News Categories)
INSERT INTO news_categories (news_category_id, category_name) VALUES
                                                                  (1, 'Khuyến mãi - Ưu đãi'),
                                                                  (2, 'Câu chuyện đặc sản'),
                                                                  (3, 'Mẹo bảo quản thực phẩm');

-- =========================================================================
-- 2. NẠP DỮ LIỆU BẢNG PHỤ THUỘC (Có Khóa Ngoại)
-- =========================================================================

-- Nạp Sản phẩm (Products)
INSERT INTO products (product_id, name, description, price, image_url, stock_quantity, average_rating, total_sold, region_id) VALUES
                                                                                                                                  (1, 'Thịt Trâu Gác Bếp Sơn La', 'Thịt trâu bản sấy than củi, tẩm ướp chuẩn vị Tây Bắc. Hút chân không 500g.', 450000.00, 'url_thit_trau.jpg', 50, 4.8, 120, 1),
                                                                                                                                  (2, 'Lạp Xưởng Hun Khói', 'Lạp xưởng làm từ thịt lợn bản đen, dai ngon sần sật. Gói 500g.', 250000.00, 'url_lap_xuong.jpg', 100, 4.5, 85, 1),
                                                                                                                                  (3, 'Mực Một Nắng Phan Thiết', 'Mực ống size lớn, phơi đúng 1 nắng to, dẻo và ngọt thịt. Túi 1kg.', 850000.00, 'url_muc.jpg', 30, 4.9, 45, 2),
                                                                                                                                  (4, 'Cà Phê Chồn Buôn Ma Thuột', 'Cà phê nguyên chất 100%, rang mộc mộc, thơm nồng nàn. Gói 250g.', 350000.00, 'url_cafe.jpg', 200, 5.0, 300, 3);

-- Nạp Tin tức (News) (Do Admin Vanh viết)
INSERT INTO news (news_id, title, content, news_category_id, author_id) VALUES
                                                                            (1, 'Săn sale đặc sản tháng 3: Giảm giá lên tới 50%', 'Nội dung bài viết khuyến mãi siêu hấp dẫn cho dịp Lễ...', 1, 1),
                                                                            (2, 'Cách bảo quản thịt trâu gác bếp không bị mốc', 'Để thịt trâu luôn ngon, các bạn cần bọc kín và để ngăn đá tủ lạnh...', 3, 1);

-- Nạp Đánh giá (Reviews) (Khách hàng đánh giá sản phẩm)
INSERT INTO reviews (review_id, content, rating, product_id, user_id) VALUES
                                                                          (1, 'Thịt trâu rất ngon, cay vừa phải, giao hàng nhanh.', 5, 1, 2),
                                                                          (2, 'Mực dẻo nhưng hơi mặn một chút so với khẩu vị của mình.', 4, 3, 3);

-- Nạp Đơn hàng (Orders) (Khách hàng ID 2 đặt mua)
INSERT INTO orders (order_id, subtotal, status, shipping_fee, shipping_address, total_amount, recipient_full_name, recipient_phone_number, recipient_email, note, payment_method, user_id) VALUES
    (1, 900000.00, 'COMPLETED', 30000.00, '123 Đường ABC, Quận Hải Châu, Đà Nẵng', 930000.00, 'Linh Thị', '0912345678', 'linh.khachhang@gmail.com', 'Giao trong giờ hành chính giúp mình', 'VNPAY', 2);

-- Nạp Chi tiết đơn hàng (Order Items) (Đơn hàng 1 mua 2 gói thịt trâu)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 2, 450000.00);

-- =========================================================================
-- 3. RESET LẠI AUTO-INCREMENT (SERIAL SEQUENCES)
-- Giúp các câu lệnh INSERT từ API Java sau này không bị lỗi đụng ID
-- =========================================================================
SELECT setval('users_user_id_seq', (SELECT MAX(user_id) FROM users));
SELECT setval('regions_region_id_seq', (SELECT MAX(region_id) FROM regions));
SELECT setval('news_categories_news_category_id_seq', (SELECT MAX(news_category_id) FROM news_categories));
SELECT setval('products_product_id_seq', (SELECT MAX(product_id) FROM products));
SELECT setval('news_news_id_seq', (SELECT MAX(news_id) FROM news));
SELECT setval('reviews_review_id_seq', (SELECT MAX(review_id) FROM reviews));
SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));