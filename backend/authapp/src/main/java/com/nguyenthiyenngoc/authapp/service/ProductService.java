package com.nguyenthiyenngoc.authapp.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nguyenthiyenngoc.authapp.entity.Category;
import com.nguyenthiyenngoc.authapp.entity.Product;
import com.nguyenthiyenngoc.authapp.entity.Tag;
import com.nguyenthiyenngoc.authapp.repository.CategoryRepository;
import com.nguyenthiyenngoc.authapp.repository.ProductRepository;
import com.nguyenthiyenngoc.authapp.repository.TagRepository;
import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

public interface ProductService {
    Product createProduct(Product product);
    Product getProductById(UUID id);
    List<Product> getAllProducts();
    List<Product> getProductsByTagName(String tagName);
    List<Product> getProductsByCategoryId(UUID categoryId);
    List<Product> getProductsByCategoryName(String categoryName);
    Product updateProduct(UUID id, Product product);
    void deleteProduct(UUID id);
}

@Component
class DataSeeder implements CommandLineRunner {

    private final ProductRepository productRepository;
    private final TagRepository tagRepository;
    private final CategoryRepository categoryRepository;
    private final com.nguyenthiyenngoc.authapp.repository.ReviewRepository reviewRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    public DataSeeder(
            ProductRepository productRepository,
            TagRepository tagRepository,
            CategoryRepository categoryRepository,
            com.nguyenthiyenngoc.authapp.repository.ReviewRepository reviewRepository) {

        this.productRepository = productRepository;
        this.tagRepository = tagRepository;
        this.categoryRepository = categoryRepository;
        this.reviewRepository = reviewRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        System.out.println("Checking and seeding database...");

        if (categoryRepository.count() == 0) {
            System.out.println("Seeding categories...");
            try (InputStream is = new ClassPathResource("data/categories.json").getInputStream()) {
                List<CategorySeedDto> dtos = objectMapper.readValue(is, new TypeReference<List<CategorySeedDto>>() {});
                List<Category> categoriesToSave = new ArrayList<>();
                Map<String, Category> categoryMap = new HashMap<>();

                for (CategorySeedDto dto : dtos) {
                    Category cat = Category.builder()
                            .categoryName(dto.getCategoryName())
                            .categoryDescription(dto.getCategoryDescription())
                            .icon(dto.getIcon())
                            .image(dto.getImage())
                            .placeholder(dto.getPlaceholder())
                            .active(dto.getActive() != null ? dto.getActive() : true)
                            .build();
                    categoryMap.put(cat.getCategoryName(), cat);
                    categoriesToSave.add(cat);
                }

                categoryRepository.saveAll(categoriesToSave);

                for (CategorySeedDto dto : dtos) {
                    if (dto.getParentCategoryName() != null && !dto.getParentCategoryName().equals("null")) {
                        Category child = categoryMap.get(dto.getCategoryName());
                        Category parent = categoryMap.get(dto.getParentCategoryName());
                        if (child != null && parent != null) {
                            child.setParent(parent);
                        }
                    }
                }
                categoryRepository.saveAll(categoriesToSave);
            }
        }

        if (tagRepository.count() == 0) {
            System.out.println("Seeding tags...");
            try (InputStream is = new ClassPathResource("data/tags.json").getInputStream()) {
                List<TagSeedDto> dtos = objectMapper.readValue(is, new TypeReference<List<TagSeedDto>>() {});
                List<Tag> tagsToSave = new ArrayList<>();
                for (TagSeedDto dto : dtos) {
                    tagsToSave.add(Tag.builder()
                            .tagName(dto.getTagName())
                            .icon(dto.getIcon())
                            .build());
                }
                tagRepository.saveAll(tagsToSave);
            }
        }

        if (productRepository.count() == 0) {
            System.out.println("Seeding products...");
            Map<String, Category> categoryMapDB = new HashMap<>();
            categoryRepository.findAll().forEach(c -> categoryMapDB.put(c.getCategoryName(), c));

            Map<String, Tag> tagMapDB = new HashMap<>();
            tagRepository.findAll().forEach(t -> tagMapDB.put(t.getTagName(), t));

            try (InputStream is = new ClassPathResource("data/products.json").getInputStream()) {
                List<ProductSeedDto> dtos = objectMapper.readValue(is, new TypeReference<List<ProductSeedDto>>() {});
                List<Product> productsToSave = new ArrayList<>();

                for (ProductSeedDto dto : dtos) {
                    Set<Category> productCategories = new HashSet<>();
                    if (dto.getCategoryNames() != null) {
                        for (String catName : dto.getCategoryNames()) {
                            Category cat = categoryMapDB.get(catName);
                            if (cat != null) {
                                productCategories.add(cat);
                            }
                        }
                    }

                    Set<Tag> productTags = new HashSet<>();
                    if (dto.getTagNames() != null) {
                        for (String tagName : dto.getTagNames()) {
                            Tag tag = tagMapDB.get(tagName);
                            if (tag != null) {
                                productTags.add(tag);
                            }
                        }
                    }

                    Product p = Product.builder()
                            .productName(dto.getProductName())
                            .slug(dto.getSlug())
                            .sku(dto.getSku())
                            .salePrice(dto.getSalePrice())
                            .comparePrice(dto.getComparePrice())
                            .buyingPrice(dto.getBuyingPrice())
                            .quantity(dto.getQuantity())
                            .shortDescription(dto.getShortDescription())
                            .productDescription(dto.getProductDescription())
                            .productType(dto.getProductType())
                            .published(dto.getPublished() != null ? dto.getPublished() : true)
                            .disableOutOfStock(dto.getDisableOutOfStock() != null ? dto.getDisableOutOfStock() : true)
                            .image(dto.getImage())
                            .image2(dto.getImage2())
                            .note(dto.getNote())
                            .categories(productCategories)
                            .tags(productTags)
                            .build();

                    productsToSave.add(p);
                }

                productRepository.saveAll(productsToSave);
            }
        }

        // Seed reviews if none exist
        if (reviewRepository.count() == 0) {
            System.out.println("Seeding reviews...");
            try (InputStream is = new ClassPathResource("data/reviews.json").getInputStream()) {
                List<ReviewSeedDto> dtos = objectMapper.readValue(is, new TypeReference<List<ReviewSeedDto>>() {});
                List<com.nguyenthiyenngoc.authapp.entity.Review> reviewsToSave = new ArrayList<>();

                // Build slug -> product map
                Map<String, Product> productSlugMap = new HashMap<>();
                productRepository.findAll().forEach(p -> productSlugMap.put(p.getSlug(), p));

                for (ReviewSeedDto dto : dtos) {
                    Product product = productSlugMap.get(dto.getProductSlug());
                    if (product == null) {
                        System.out.println("Product not found for slug: " + dto.getProductSlug() + ", skipping review.");
                        continue;
                    }

                    com.nguyenthiyenngoc.authapp.entity.Review review =
                            com.nguyenthiyenngoc.authapp.entity.Review.builder()
                                    .productId(product.getId())
                                    .userId(UUID.fromString(dto.getUserId()))
                                    .rating(dto.getRating())
                                    .comment(dto.getComment())
                                    .build();

                    reviewsToSave.add(review);
                }
                reviewRepository.saveAll(reviewsToSave);
            }
        }

        System.out.println("Database seeding completed successfully!");
    }
}

@Data
class CategorySeedDto {
    private String categoryName;
    private String categoryDescription;
    private String icon;
    private String image;
    private String placeholder;
    private Boolean active;
    private String parentCategoryName;
}

@Data
class ProductSeedDto {
    private String productName;
    private String slug;
    private String sku;
    private BigDecimal salePrice;
    private BigDecimal comparePrice;
    private BigDecimal buyingPrice;
    private Integer quantity;
    private String shortDescription;
    private String productDescription;
    private String productType;
    private Boolean published;
    private Boolean disableOutOfStock;
    private String image;
    private String image2;
    private String note;
    private List<String> categoryNames;
    private List<String> tagNames;
}

@Data
class TagSeedDto {
    private String tagName;
    private String icon;
}

@Data
class ReviewSeedDto {
    private String productSlug;
    private String userName;
    private String userId;
    private Integer rating;
    private String comment;
    private List<String> images;
}
