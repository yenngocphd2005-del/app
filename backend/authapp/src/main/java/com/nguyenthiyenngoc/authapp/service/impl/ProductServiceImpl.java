package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Category;
import com.nguyenthiyenngoc.authapp.entity.Product;
import com.nguyenthiyenngoc.authapp.entity.Tag;
import com.nguyenthiyenngoc.authapp.repository.CategoryRepository;
import com.nguyenthiyenngoc.authapp.repository.ProductRepository;
import com.nguyenthiyenngoc.authapp.repository.TagRepository;
import com.nguyenthiyenngoc.authapp.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final TagRepository tagRepository;
    private final CategoryRepository categoryRepository;

    @Autowired
    public ProductServiceImpl(ProductRepository productRepository, TagRepository tagRepository, CategoryRepository categoryRepository) {
        this.productRepository = productRepository;
        this.tagRepository = tagRepository;
        this.categoryRepository = categoryRepository;
    }

    @Override
    public Product createProduct(Product product) {
        if (productRepository.findBySlug(product.getSlug()).isPresent()) {
            throw new RuntimeException("Product with slug already exists: " + product.getSlug());
        }
        resolveAssociations(product);
        return productRepository.save(product);
    }

    @Override
    public Product getProductById(UUID id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with ID: " + id));
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public List<Product> getProductsByTagName(String tagName) {
        return productRepository.findByTagsTagNameIgnoreCase(tagName);
    }

    @Override
    public List<Product> getProductsByCategoryId(UUID categoryId) {
        return productRepository.findByCategoriesId(categoryId);
    }

    @Override
    public List<Product> getProductsByCategoryName(String categoryName) {
        return productRepository.findByCategoriesCategoryNameIgnoreCase(categoryName);
    }

    @Override
    public Product updateProduct(UUID id, Product product) {

        Product existing = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with ID: " + id));

        existing.setSlug(product.getSlug());
        existing.setProductName(product.getProductName());
        existing.setSku(product.getSku());
        existing.setSalePrice(product.getSalePrice());
        existing.setComparePrice(product.getComparePrice());
        existing.setBuyingPrice(product.getBuyingPrice());
        existing.setQuantity(product.getQuantity());
        existing.setShortDescription(product.getShortDescription());
        existing.setProductDescription(product.getProductDescription());
        existing.setProductType(product.getProductType());
        existing.setPublished(product.getPublished());
        existing.setDisableOutOfStock(product.getDisableOutOfStock());
        existing.setNote(product.getNote());
        existing.setImage(product.getImage());

        resolveAssociations(product);
        existing.setTags(product.getTags());
        existing.setCategories(product.getCategories());

        return productRepository.save(existing);
    }

    @Override
    public void deleteProduct(UUID id) {
        productRepository.deleteById(id);
    }

    private void resolveAssociations(Product product) {
        if (product.getTags() != null) {
            Set<Tag> resolvedTags = new HashSet<>();
            for (Tag tag : product.getTags()) {
                if (tag.getId() != null) {
                    tagRepository.findById(tag.getId()).ifPresent(resolvedTags::add);
                } else if (tag.getTagName() != null) {
                    tagRepository.findByTagName(tag.getTagName()).ifPresent(resolvedTags::add);
                }
            }
            product.setTags(resolvedTags);
        }
        if (product.getCategories() != null) {
            Set<Category> resolvedCategories = new HashSet<>();
            for (Category cat : product.getCategories()) {
                if (cat.getId() != null) {
                    categoryRepository.findById(cat.getId()).ifPresent(resolvedCategories::add);
                } else if (cat.getCategoryName() != null) {
                    categoryRepository.findByCategoryNameIgnoreCase(cat.getCategoryName()).ifPresent(resolvedCategories::add);
                }
            }
            product.setCategories(resolvedCategories);
        }
    }
}
