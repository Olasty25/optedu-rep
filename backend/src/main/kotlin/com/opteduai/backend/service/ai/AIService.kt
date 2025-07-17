package com.opteduai.backend.service.ai
data class AIResponse(val success: Boolean, val response: String)
interface AIService {
    fun executePrompt(prompt: String): AIResponse
}