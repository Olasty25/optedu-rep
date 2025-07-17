package com.opteduai.backend.service.ai

import com.google.genai.Client
import com.google.genai.types.ListModelsConfig
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration


@Configuration
class GeminiAIService : AIService {
    override fun executePrompt(prompt: String): AIResponse {
        try {
            val client = Client.builder().apiKey("AIzaSyB3rweoElcrXVGNoERRD-2JyKiIJgWyyhs").build()

            val response = client.models.generateContent("gemini-2.0-flash-001",
                prompt, null)
// Gets the text string from the response by the quick accessor method `text()`.
            println("Unary response: " + response.text())

            return AIResponse(true, response.text())
            /*
            val models = client.models.list(ListModelsConfig.builder().build())
            val descList = models.map {
                Pair(it.name(), it.supportedActions())
            }

            val response1 = client.models.generateImages("gemini-2.0-flash-001", "Wygeneruj video latającej krowy, na tle Matterhornu, ze szwajcarską flagą.",
                null)


            // Gets the text string from the response by the quick accessor method `text()`.
            val uris = response1.generatedImages().map {
                it[0].image().get().gcsUri()
            }

             */


        } catch (ex: Exception) {
            ex.printStackTrace()
            throw ex
        }
    }

}