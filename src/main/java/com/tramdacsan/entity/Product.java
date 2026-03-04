package com.tramdacsan.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "products")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {

    @Id // Đánh dấu đây là Khóa chính (Primary Key)
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Tự động tăng ID giống như SERIAL trong SQL
    private Integer productId;

    private String name;
    private String description;
    private Double price;
    private String imageUrl;
    private Integer stockQuantity;
    private Double averageRating;
    private Integer totalSold;

}