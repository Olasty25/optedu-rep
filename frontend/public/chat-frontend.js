async function sendMessage() {
  const input = document.getElementById("userInput");
  const text = input.value.trim();
  if (!text) return;

  const messagesDiv = document.getElementById("messages");

  // Dodaj wiadomość usera
  const userMsg = document.createElement("div");
  userMsg.className = "message user";
  userMsg.textContent = text;
  messagesDiv.appendChild(userMsg);

  input.value = "";

  // Placeholder dla bota
  const botMsg = document.createElement("div");
  botMsg.className = "message bot";
  botMsg.textContent = "Thinking...";
  messagesDiv.appendChild(botMsg);

  try {
    const res = await fetch("http://localhost:3000/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: text })
    });

    const data = await res.json();

    if (data.choices?.[0]?.message?.content) {
      botMsg.textContent = data.choices[0].message.content;
    } else {
      botMsg.textContent = "⚠️ Error: AI did not respond";
    }
  } catch (err) {
    botMsg.textContent = "⚠️ Server error";
    console.error(err);
  }

  messagesDiv.scrollTop = messagesDiv.scrollHeight;
}
