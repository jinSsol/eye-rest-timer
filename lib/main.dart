import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화
  await Hive.initFlutter();

  // Google Mobile Ads 초기화
  await MobileAds.instance.initialize();

  // 한국어 날짜 포맷 초기화
  await initializeDateFormatting('ko', null);

  runApp(
    const ProviderScope(
      child: EyeRestTimerApp(),
    ),
  );
}
