async function sendMessage() {
  const input = document.getElementById("userInput");
  const text = input.value.trim();
  if (!text) return;

  const messagesDiv = document.getElementById("messages");

  const userMsg = document.createElement("div");
  userMsg.className = "message user";
  userMsg.innerText = text;
  messagesDiv.appendChild(userMsg);

  input.value = "";

  const botMsg = document.createElement("div");
  botMsg.className = "message bot";
  botMsg.innerText = "Thinking...";
  messagesDiv.appendChild(botMsg);

  try {
    const res = await fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: text })
    });

    const data = await res.json();
    if (data.choices) {
      botMsg.innerText = data.choices[0].message.content;
    } else {
      botMsg.innerText = "AI Error 🙁";
    }
  } catch (err) {
    botMsg.innerText = "Server Error";
    console.error(err);
  }

  messagesDiv.scrollTop = messagesDiv.scrollHeight;
}
