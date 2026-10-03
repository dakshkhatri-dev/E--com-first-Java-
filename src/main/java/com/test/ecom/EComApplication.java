package com.test.ecom;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EComApplication {
/**
 * Spring Starter Main method initiate application
 * Does not catch by Global Exception Handler */


    private static final Logger log =
            LoggerFactory.getLogger(EComApplication.class);


    public static void main(String[] args) {
        SpringApplication.run(EComApplication.class, args);

             log.info(" || Application Start ||");


    }

}
