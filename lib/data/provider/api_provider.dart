import 'package:flutter_gpt/data/service/api_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());
final typingProvider = StateProvider<bool>((ref) => false);
