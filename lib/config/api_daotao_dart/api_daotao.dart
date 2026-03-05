import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> login(String username, String password) async {
  final client = http.Client();

  try {
    print("=== STEP 1: GET SESSION ===");

    final sessionRes = await client.get(
      Uri.parse("https://daotao.vnua.edu.vn/api/auth/authconfig"),
    );

    print("SESSION STATUS: ${sessionRes.statusCode}");

    if (sessionRes.statusCode != 200) {
      print("❌ Không lấy được session");
      return false;
    }

    final rawCookie = sessionRes.headers['set-cookie'];
    if (rawCookie == null) {
      print("❌ Không có cookie");
      return false;
    }

    // Lấy toàn bộ cookie (an toàn hơn)
    final cookie = rawCookie
        .split(',')
        .map((c) => c.split(';').first)
        .join('; ');

    print("COOKIE: $cookie");

    print("=== STEP 2: CREATE PAYLOAD ===");

    final payload = {
      "username": username,
      "password": password,
      "uri": "https://daotao.vnua.edu.vn/#/home",
    };

    final base64Data =
    Uri.encodeComponent(base64Encode(utf8.encode(jsonEncode(payload))));

    print("ENCODED DATA CREATED");

    print("=== STEP 3: SEND LOGIN REQUEST ===");

    final request = http.Request(
      "GET",
      Uri.parse(
        "https://daotao.vnua.edu.vn/api/pn-signin?code=$base64Data&gopage=&mgr=1",
      ),
    );

    request.followRedirects = false;

    request.headers.addAll({
      'Cookie': cookie,
      'User-Agent':
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36',
      'Accept': '*/*',
    });

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    print("LOGIN STATUS: ${response.statusCode}");
    print("LOGIN HEADERS: ${response.headers}");

    print("=== STEP 4: CHECK REDIRECT ===");

    final location = response.headers['location'];

    if (location == null) {
      print("❌ Không có redirect");
      return false;
    }

    print("LOCATION: $location");

    final fullUrl = location.startsWith("http")
        ? location
        : "https://daotao.vnua.edu.vn$location";

    final uri = Uri.parse(fullUrl);

// 🔥 LẤY FRAGMENT
    final fragment = uri.fragment;

    if (fragment.isEmpty) {
      print("❌ Fragment rỗng");
      return false;
    }

    print("FRAGMENT: $fragment");

// 🔥 Parse fragment thành URI giả
    final fragUri = Uri.parse("https://dummy.com/$fragment");

    final currUser = fragUri.queryParameters['CurrUser'];

    print("CurrUser: $currUser");

    if (currUser == null || currUser == "null") {
      print("❌ Login thất bại");
      return false;
    }

    print("✅ LOGIN SUCCESS");
    print("");
    return true;
  } catch (e, stackTrace) {
    print("🔥 LOGIN ERROR: $e");
    print(stackTrace);
    return false;
  } finally {
    client.close();
  }
}