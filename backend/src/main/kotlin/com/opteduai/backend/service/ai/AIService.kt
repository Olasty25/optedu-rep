package com.opteduai.backend.service.ai
data class AIResponse<T>(val success: Boolean, val response: T?)

data class AIQuiz(val questions: List<String>, val topic: String, val level: String, val response: String?)

interface AIService {
    fun executePrompt(prompt: String): AIResponse<String?>

    fun generateQuiz(topic: String, level: String, numQuestions: Int, numItems: Int, language: String): AIResponse<AIQuiz>
}