import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final customCacheManager = CacheManager(Config('customKey',
    stalePeriod: const Duration(days: 10), maxNrOfCacheObjects: 50));

Map<String, List<String>> interestsMap = {
  'Sports': [
    "⚽ Football",
    "🎾 Tennis",
    "🏀 Basketball",
    "🏏 Cricket",
    "⛳ Golf",
    "🏃 Athletics",
    "♟️ Chess",
    "🏑 Hockey",
    "🏋️‍♀️ weightlifting",
    "🏓 TT",
    "🏊 swimming",
    "🏐 Volleyball",
    "🏸 Squash"
  ],
  'Creativity': [
    "🎨 Art",
    "✏️ Design",
    "💄 Make-up",
    "📷 Photography",
    "📝 Writing",
    "🎤 Singing",
    "💃🏻 Dancing",
    "📌 Crafts",
    "📽️ Making videos"
  ],
  "Going out": [
    "🎙️ Stand up",
    "🎊 Festivals",
    "🎭 Theatre",
    "🕺🏻 Nightclubs",
    "🎤 Karaoke",
    "🏛️ Museums & Galleries",
    "🍸 Pubs"
  ],
  "Staying in": [
    "🎮 Video games",
    "🎲 Board games",
    "🌱 Gardening",
    "🍳 Cooking",
    "🍰 Baking"
  ],
  "Film & TV": [
    "📺 Romance",
    "📺 Comedy",
    "📺 Drama",
    "📺 Horror",
    "📺 Thriller",
    "📺 Fantasy",
    "📺 Sci-fi",
    "📺 Anime"
  ],
  "Reading": [
    "📚 Romance",
    "📚 Comedy",
    "📚 Mystery",
    "📚 Horror",
    "📚 Manga",
    "📚 Fantasy",
    "📚 Sci-fi"
  ],
  "Music": [
    "🎵 Hip hop",
    "🎵 Pop",
    "🎵 Rock",
    "🎵 Electronic",
    "🎵 R&B",
    "🎵 Classical",
    "🎵 Country",
    "🎵 Desi",
    "🎵 Jazz"
  ],
  "Food & Drink": [
    "🍷 Wine",
    "🍺 Beer",
    "☕ Coffee",
    "🍸 Cocktails",
    "🥃 Whiskey",
    "🌱 Vegan",
    "🍕 Pizza",
    "🥦 Vegetarian"
  ],
  "Travelling": [
    "🏖️ Beaches",
    "🛁 Spa weekends",
    "❄️ Winter sports",
    "🏕️ Camping",
    "🌆 City Breaks",
    "🏡 Country escapes",
    "🎒 Backpacking",
    "⛺ Hiking trips",
    "🛣️ Road trips"
  ],
  "Pets": ["🐶 Dogs", "😺 Cats", "🐦 Birds", "🐠 Fish"]
};
