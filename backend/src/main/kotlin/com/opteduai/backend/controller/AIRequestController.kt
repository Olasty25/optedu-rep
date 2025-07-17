package com.opteduai.backend.controller

import com.opteduai.backend.service.ai.AIResponse
import com.opteduai.backend.service.ai.AIService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController

@RestController()
class  AIRequestController {

    @Autowired
    lateinit var aiService: AIService



    @PostMapping("/api/hello")
    fun sendPrompt(prompt: String): AIResponse {
        // zaytac AI z tym promptem, poczekać na odpowiedż, przetworzyć ją i zwrócić do user

        //val responseFromAI = AI.sendPrompt(prompt);
        return aiService.executePrompt(prompt)
    }
}