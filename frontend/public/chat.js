// Funkcja wysyłania wiadomości do czatu
async function sendMessage() {
  const input = document.getElementById("userInput");
  const text = input.value.trim();
  if (!text) return;

  // Element do wiadomości
  const messagesDiv = document.getElementById("messages");

  // Dodaj wiadomość użytkownika
  const userMsg = document.createElement("div");
  userMsg.classList.add("message", "user");
  userMsg.innerText = text;
  messagesDiv.appendChild(userMsg);

  input.value = "";

  // Dodaj placeholder odpowiedzi bota
  const botMsg = document.createElement("div");
  botMsg.classList.add("message", "bot");
  botMsg.innerText = "Thinking...";
  messagesDiv.appendChild(botMsg);

  try {
    // 🟢 Tutaj odwołanie do API (np. OpenAI)
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer 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" // ❗️Podmień na swój API Key
      },
      body: JSON.stringify({
        model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: text }]
      })
    });

    const data = await response.json();

    // Wyświetlamy odpowiedź bota
    botMsg.innerText = data.choices[0].message.content;

  } catch (e) {
    botMsg.innerText = "Error: could not connect to AI 😢";
    console.error(e);
  }

  // scroll na dół czatu
  messagesDiv.scrollTop = messagesDiv.scrollHeight;
}
