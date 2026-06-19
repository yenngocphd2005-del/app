package com.nguyenthiyenngoc.authapp.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "countries")
@Getter
@Setter
public class Country {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(length = 2, nullable = false)
    private String iso;

    @Column(length = 80, nullable = false)
    private String name;

    @Column(name = "upper_name", length = 80, nullable = false)
    private String upperName;

    @Column(length = 3)
    private String iso3;

    @Column(name = "num_code")
    private Short numCode;

    @Column(name = "phone_code", nullable = false)
    private Integer phoneCode;
}