package com.opteduai.backend.controller

import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

data class AIResponse(val success: Boolean, val message: String)

@RestController()
class  AIRequestController {
    @GetMapping("/api/hello")
    fun sayHello(): AIResponse {
        return AIResponse(true, "<b>Hej - tu Olek i jego API</b>")
    }


    @GetMapping("/api/hello")
    fun sendPrompt(prompt: String): AIResponse {
        // zaytac AI z tym promptem, poczekać na odpowiedż, przetworzyć ją i zwrócić do user

        //val responseFromAI = AI.sendPrompt(prompt);
        return AIResponse(true, "<b>Hej - tu Olek i jego API</b>")
    }
}