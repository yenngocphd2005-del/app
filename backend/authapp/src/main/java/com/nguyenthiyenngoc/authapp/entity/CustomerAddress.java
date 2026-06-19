package com.nguyenthiyenngoc.authapp.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.UUID;

@Entity
@Table(name = "customer_addresses")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CustomerAddress {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", nullable = false, updatable = false)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    private Customer customer;

    @Column(name = "address_line1", nullable = false, columnDefinition = "TEXT")
    private String addressLine1;

    @Column(name = "address_line2", columnDefinition = "TEXT")
    private String addressLine2;

    @Column(name = "phone_number", nullable = false, length = 255)
    private String phoneNumber;

    @Column(name = "dial_code", nullable = false, length = 100)
    private String dialCode;

    @Column(name = "country", nullable = false, length = 255)
    private String country;

    @Column(name = "postal_code", nullable = false, length = 255)
    private String postalCode;

    @Column(name = "city", nullable = false, length = 255)
    private String city;
}
