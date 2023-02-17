import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Types/token.dart';
import '../Types/user.dart';

class TeamsRepository {
  static const String baseUrl = "https://team-dinner-jib-2341.vercel.app";
  static final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const String repositoryName = "teams";

  
}
