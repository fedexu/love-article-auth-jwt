package com.love.article.auth.domain;

import java.util.UUID;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name="application_role")
@Getter
@Setter
public class ApplicationRole {

    @Id
    @GeneratedValue(strategy= GenerationType.AUTO)
    private UUID id;
    private String name;
    private String description;

}