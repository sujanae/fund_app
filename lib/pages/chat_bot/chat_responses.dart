// chat_responses.dart
Map<String, String> predefinedReplies = {
  "hello": "Hello! How can I help you today?",
  "help": "Sure, let me know how I can assist!",
  "how are you": "I'm just a bot, but I'm here to help you!",
  "default": "I didn’t quite understand that. Can you rephrase?",
  "weather": "I can't predict the weather, but you can check a weather app!",
  "bye": "Goodbye! Have a nice day!",
  "ajithuu": "kadavulae!! ",
};

String generateReply(String userMessage) {
  userMessage = userMessage.toLowerCase().trim();

  // Look for an exact match in predefined replies
  for (String key in predefinedReplies.keys) {
    if (userMessage.contains(key)) {
      return predefinedReplies[key]!;
    }
  }

  // Default response if no match found
  return predefinedReplies["default"]!;
}
