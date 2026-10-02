package com.test.ecom.user.auth.controller;


import com.test.ecom.globalException.GlobalExceptionHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user/signup")
public class SignUp {

    private static final Logger log =
            LoggerFactory.getLogger(GlobalExceptionHandler.class);


    @GetMapping
    public ResponseEntity<String> CreateAccount(){

            log.info("User Returned !");

        return ResponseEntity
                .status(HttpStatus.ACCEPTED)
                .body("User Name :  and Details !") ;
    }

}
