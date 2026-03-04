package com.tramdacsan.repository;

import com.tramdacsan.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;

// Kế thừa JpaRepository, truyền vào tên Entity (Product) và kiểu dữ liệu của Khóa chính (Integer)
public interface ProductRepository extends JpaRepository<com.tramdacsan.entity.Product, Integer> {
    // Không cần viết gì ở đây cả, Spring Boot đã cho cậu mượn sẵn hàm findAll(), findById(), save()... rồi!
}