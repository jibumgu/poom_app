import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_runtime_options.dart';
import 'firebase_poom_repository.dart';
import 'poom_database.dart';

class PoomRepositoryBundle {
  const PoomRepositoryBundle({
    required this.repository,
    required this.usesFirebase,
    required this.message,
  });

  final PoomRepositoryApi repository;
  final bool usesFirebase;
  final String message;
}

Future<PoomRepositoryBundle> createPoomRepositoryBundle() async {
  final fallback = PoomRepositoryBundle(
    repository: PoomRepository(PoomDatabase.seeded()),
    usesFirebase: false,
    message: FirebaseRuntimeOptions.isConfigured
        ? 'Firebase 연결에 실패해 임시 데이터베이스로 실행 중입니다.'
        : 'Firebase 설정값이 없어 임시 데이터베이스로 실행 중입니다.',
  );

  if (!FirebaseRuntimeOptions.isConfigured) {
    return fallback;
  }

  try {
    await Firebase.initializeApp(
      options: FirebaseRuntimeOptions.currentPlatform,
    );
    final repository = FirebasePoomRepository(FirebaseFirestore.instance);
    await repository.seedIfEmpty();

    return PoomRepositoryBundle(
      repository: repository,
      usesFirebase: true,
      message: 'Firebase Firestore에 연결되었습니다.',
    );
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrint('$stackTrace');
    return fallback;
  }
}
