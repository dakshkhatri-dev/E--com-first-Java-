package com.test.ecom.globalException;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     *  Catch Global Exceptions
     *  Used ExceptionHandler(custom/Exception.class) ... Your Return method .
     * Log Initiator
     * Return  Response Entity. status . body */


    private static final Logger log =
            LoggerFactory.getLogger(GlobalExceptionHandler.class);


    /* Random Exception Handler */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> HandleAllExceptions(Exception ex){

                              log.error(" || Unexcpected error || ", ex);

          return ResponseEntity
                             .status(HttpStatus.INTERNAL_SERVER_ERROR)
                             .body("something went wrong ! Internal Error");

    }
}
