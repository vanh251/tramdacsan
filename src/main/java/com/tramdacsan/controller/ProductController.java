package com.tramdacsan.controller;

import com.tramdacsan.entity.Product;
import com.tramdacsan.repository.ProductRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    // Nhờ Spring Boot tự động tiêm (inject) cái Repository ở Bước 2 vào đây để dùng
    private final ProductRepository productRepository;

    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping
    //Lấy toàn bộ danh sách sản phẩm (GET)
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    //Lấy 1 sản phẩm theo ID (GET)
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductByID(@PathVariable Integer id){
        Optional<Product> productOptional = productRepository.findById(id);
        if(productOptional.isPresent()){
            return ResponseEntity.ok(productOptional.get());
        }else {
            return ResponseEntity.notFound().build();
        }
    }

    //Thêm mới sản phẩm vào kho (POST)
    @PostMapping
    public Product createProduct (@RequestBody Product product){  //RequestBody chuyển JSON thành 1 Object
        return productRepository.save(product);
    }

    //Cập nhật thông tin sản phẩm (PUT)
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct (@PathVariable Integer id,@RequestBody Product productDetails){
        Optional<Product> productOptional = productRepository.findById(id);
        if(productOptional.isPresent()){
            Product exsitingProduct = productOptional.get();
            exsitingProduct.setName(productDetails.getName());
            exsitingProduct.setDescription(productDetails.getDescription());
            exsitingProduct.setPrice(productDetails.getPrice());
            exsitingProduct.setImageUrl(productDetails.getImageUrl());
            exsitingProduct.setStockQuantity(productDetails.getStockQuantity());

            Product updatedProduct = productRepository.save(exsitingProduct);
            return ResponseEntity.ok(updatedProduct);
        }else {
            return ResponseEntity.notFound().build();
        }
    }

    //xoa 1 sam pham (DELETE)
    @DeleteMapping("/{id}")
    public ResponseEntity<Product> deleteProduct (@PathVariable Integer id){
        Optional<Product> productOptional = productRepository.findById(id);
        if(productOptional.isPresent()){
            productRepository.deleteById(id);
            return ResponseEntity.ok().build();
        }else {
            return ResponseEntity.notFound().build();
        }
    }
}