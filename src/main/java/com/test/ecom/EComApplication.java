package com.test.ecom;

import org.flywaydb.core.Flyway;
import org.flywaydb.core.internal.util.JsonUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EComApplication {

    public static void main(String[] args) {
        SpringApplication.run(EComApplication.class, args);

        System.out.println(" Migrations Setteled ! ");
    }

}
