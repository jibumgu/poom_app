import 'package:cloud_firestore/cloud_firestore.dart';

import 'poom_database.dart';

class FirebasePoomRepository implements PoomRepositoryApi {
  FirebasePoomRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _requests =>
      _firestore.collection('care_requests');
  CollectionReference<Map<String, dynamic>> get _caregivers =>
      _firestore.collection('caregivers');
  CollectionReference<Map<String, dynamic>> get _matches =>
      _firestore.collection('matches');
  CollectionReference<Map<String, dynamic>> get _messages =>
      _firestore.collection('chat_messages');
  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('handoff_tasks');
  DocumentReference<Map<String, dynamic>> get _stats =>
      _firestore.collection('dashboard').doc('current');

  Future<void> seedIfEmpty() async {
    final existing = await _requests.limit(1).get();
    final seed = PoomDatabase.seeded();

    if (!(await _stats.get()).exists) {
      await _stats.set(_dashboardToJson(seed.stats));
    }

    if (existing.docs.isNotEmpty) return;

    final batch = _firestore.batch();
    for (final request in seed.requests) {
      batch.set(_requests.doc(request.id), _requestToJson(request));
    }
    for (final caregiver in seed.caregivers) {
      batch.set(_caregivers.doc(caregiver.id), _caregiverToJson(caregiver));
    }
    for (final match in seed.matches) {
      batch.set(_matches.doc(match.id), _matchToJson(match));
    }
    for (final message in seed.chatMessages) {
      batch.set(_messages.doc(message.id), _messageToJson(message));
    }
    for (final task in seed.handoffTasks) {
      batch.set(_tasks.doc(task.id), _taskToJson(task));
    }
    await batch.commit();
  }

  @override
  Future<HomeFeed> fetchHomeFeed() async {
    final results = await Future.wait([
      readDashboardStats(),
      readCareRequests(),
      readCaregivers(),
    ]);
    return HomeFeed(
      stats: results[0] as DashboardStats,
      requests: results[1] as List<CareRequest>,
      caregivers: results[2] as List<CaregiverProfile>,
    );
  }

  @override
  Future<CareRequest> fetchMainRequest() async {
    final requests = await readCareRequests();
    if (requests.isEmpty) {
      throw StateError('등록된 도움 요청이 없습니다.');
    }
    return requests.first;
  }

  @override
  Future<CaregiverProfile> fetchMainCaregiver() async {
    final caregivers = await readCaregivers();
    if (caregivers.isEmpty) {
      throw StateError('등록된 보호 가능자가 없습니다.');
    }
    return caregivers.first;
  }

  @override
  Future<List<ChatMessageRecord>> fetchChatMessages(String matchId) {
    return readChatMessages(matchId);
  }

  @override
  Future<List<HandoffTask>> fetchHandoffTasks() {
    return readHandoffTasks();
  }

  @override
  Future<DashboardStats> readDashboardStats() async {
    final snapshot = await _stats.get();
    if (!snapshot.exists) {
      return const DashboardStats(
        waitingMatches: 0,
        reviewingMatches: 0,
        handoffsReady: 0,
      );
    }
    return _dashboardFromJson(snapshot.data()!);
  }

  @override
  Future<DashboardStats> createDashboardStats(DashboardStats stats) async {
    await _stats.set(_dashboardToJson(stats));
    return stats;
  }

  @override
  Future<DashboardStats> updateDashboardStats(DashboardStats stats) async {
    await _stats.set(_dashboardToJson(stats), SetOptions(merge: true));
    return stats;
  }

  @override
  Future<void> deleteDashboardStats() async {
    await _stats.set(
      _dashboardToJson(
        const DashboardStats(
          waitingMatches: 0,
          reviewingMatches: 0,
          handoffsReady: 0,
        ),
      ),
    );
  }

  @override
  Future<List<CareRequest>> readCareRequests() async {
    final snapshot =
        await _requests.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => _requestFromDoc(doc)).toList();
  }

  @override
  Future<CareRequest?> readCareRequest(String id) async {
    final snapshot = await _requests.doc(id).get();
    if (!snapshot.exists) return null;
    return _requestFromDoc(snapshot);
  }

  @override
  Future<CareRequest> createCareRequest(CareRequest request) async {
    await _createUnique(_requests.doc(request.id), _requestToJson(request));
    return request;
  }

  @override
  Future<CareRequest> updateCareRequest(CareRequest request) async {
    await _updateExisting(_requests.doc(request.id), _requestToJson(request));
    return request;
  }

  @override
  Future<void> deleteCareRequest(String id) async {
    final relatedMatches =
        await _matches.where('requestId', isEqualTo: id).get();
    for (final match in relatedMatches.docs) {
      await deleteMatch(match.id);
    }
    await _deleteExisting(_requests.doc(id));
  }

  @override
  Future<List<CaregiverProfile>> readCaregivers() async {
    final snapshot =
        await _caregivers.orderBy('matchScore', descending: true).get();
    return snapshot.docs.map((doc) => _caregiverFromDoc(doc)).toList();
  }

  @override
  Future<CaregiverProfile?> readCaregiver(String id) async {
    final snapshot = await _caregivers.doc(id).get();
    if (!snapshot.exists) return null;
    return _caregiverFromDoc(snapshot);
  }

  @override
  Future<CaregiverProfile> createCaregiver(CaregiverProfile caregiver) async {
    await _createUnique(
        _caregivers.doc(caregiver.id), _caregiverToJson(caregiver));
    return caregiver;
  }

  @override
  Future<CaregiverProfile> updateCaregiver(CaregiverProfile caregiver) async {
    await _updateExisting(
      _caregivers.doc(caregiver.id),
      _caregiverToJson(caregiver),
    );
    return caregiver;
  }

  @override
  Future<void> deleteCaregiver(String id) async {
    final relatedMatches =
        await _matches.where('caregiverId', isEqualTo: id).get();
    for (final match in relatedMatches.docs) {
      await deleteMatch(match.id);
    }
    await _deleteExisting(_caregivers.doc(id));
  }

  @override
  Future<List<MatchRecord>> readMatches() async {
    final snapshot = await _matches.orderBy('id').get();
    return snapshot.docs.map((doc) => _matchFromDoc(doc)).toList();
  }

  @override
  Future<MatchRecord?> readMatch(String id) async {
    final snapshot = await _matches.doc(id).get();
    if (!snapshot.exists) return null;
    return _matchFromDoc(snapshot);
  }

  @override
  Future<MatchRecord> createMatch(MatchRecord match) async {
    await _requireDocument(_requests.doc(match.requestId));
    await _requireDocument(_caregivers.doc(match.caregiverId));
    await _createUnique(_matches.doc(match.id), _matchToJson(match));
    return match;
  }

  @override
  Future<MatchRecord> updateMatch(MatchRecord match) async {
    await _requireDocument(_requests.doc(match.requestId));
    await _requireDocument(_caregivers.doc(match.caregiverId));
    await _updateExisting(_matches.doc(match.id), _matchToJson(match));
    return match;
  }

  @override
  Future<void> deleteMatch(String id) async {
    final relatedMessages =
        await _messages.where('matchId', isEqualTo: id).get();
    final batch = _firestore.batch();
    for (final message in relatedMessages.docs) {
      batch.delete(message.reference);
    }
    batch.delete(_matches.doc(id));
    await batch.commit();
  }

  @override
  Future<List<ChatMessageRecord>> readChatMessages(String matchId) async {
    final snapshot = await _messages.where('matchId', isEqualTo: matchId).get();
    final messages = snapshot.docs.map((doc) => _messageFromDoc(doc)).toList();
    messages.sort((a, b) => a.id.compareTo(b.id));
    return messages;
  }

  @override
  Future<ChatMessageRecord?> readChatMessage(String id) async {
    final snapshot = await _messages.doc(id).get();
    if (!snapshot.exists) return null;
    return _messageFromDoc(snapshot);
  }

  @override
  Future<ChatMessageRecord> createChatMessage(ChatMessageRecord message) async {
    await _requireDocument(_matches.doc(message.matchId));
    await _createUnique(_messages.doc(message.id), _messageToJson(message));
    return message;
  }

  @override
  Future<ChatMessageRecord> updateChatMessage(ChatMessageRecord message) async {
    await _requireDocument(_matches.doc(message.matchId));
    await _updateExisting(_messages.doc(message.id), _messageToJson(message));
    return message;
  }

  @override
  Future<void> deleteChatMessage(String id) async {
    await _deleteExisting(_messages.doc(id));
  }

  @override
  Future<List<HandoffTask>> readHandoffTasks() async {
    final snapshot = await _tasks.orderBy('id').get();
    return snapshot.docs.map((doc) => _taskFromDoc(doc)).toList();
  }

  @override
  Future<HandoffTask?> readHandoffTask(String id) async {
    final snapshot = await _tasks.doc(id).get();
    if (!snapshot.exists) return null;
    return _taskFromDoc(snapshot);
  }

  @override
  Future<HandoffTask> createHandoffTask(HandoffTask task) async {
    await _createUnique(_tasks.doc(task.id), _taskToJson(task));
    return task;
  }

  @override
  Future<HandoffTask> updateHandoffTask(HandoffTask task) async {
    await _updateExisting(_tasks.doc(task.id), _taskToJson(task));
    return task;
  }

  @override
  Future<void> deleteHandoffTask(String id) async {
    await _deleteExisting(_tasks.doc(id));
  }

  Future<void> _createUnique(
    DocumentReference<Map<String, dynamic>> doc,
    Map<String, dynamic> data,
  ) async {
    final snapshot = await doc.get();
    if (snapshot.exists) {
      throw StateError('이미 존재하는 id입니다: ${doc.id}');
    }
    await doc.set(data);
  }

  Future<void> _updateExisting(
    DocumentReference<Map<String, dynamic>> doc,
    Map<String, dynamic> data,
  ) async {
    await _requireDocument(doc);
    await doc.set(data, SetOptions(merge: true));
  }

  Future<void> _deleteExisting(
    DocumentReference<Map<String, dynamic>> doc,
  ) async {
    await _requireDocument(doc);
    await doc.delete();
  }

  Future<void> _requireDocument(
    DocumentReference<Map<String, dynamic>> doc,
  ) async {
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      throw StateError('존재하지 않는 id입니다: ${doc.id}');
    }
  }
}

Map<String, dynamic> _dashboardToJson(DashboardStats stats) {
  return {
    'waitingMatches': stats.waitingMatches,
    'reviewingMatches': stats.reviewingMatches,
    'handoffsReady': stats.handoffsReady,
  };
}

DashboardStats _dashboardFromJson(Map<String, dynamic> json) {
  return DashboardStats(
    waitingMatches: (json['waitingMatches'] as num?)?.toInt() ?? 0,
    reviewingMatches: (json['reviewingMatches'] as num?)?.toInt() ?? 0,
    handoffsReady: (json['handoffsReady'] as num?)?.toInt() ?? 0,
  );
}

Map<String, dynamic> _requestToJson(CareRequest request) {
  return {
    'id': request.id,
    'tag': request.tag,
    'title': request.title,
    'animal': request.animal,
    'location': request.location,
    'condition': request.condition,
    'description': request.description,
    'progress': request.progress,
    'createdAt': Timestamp.fromDate(request.createdAt),
  };
}

CareRequest _requestFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final json = doc.data()!;
  return CareRequest(
    id: json['id'] as String? ?? doc.id,
    tag: json['tag'] as String? ?? '신규',
    title: json['title'] as String? ?? '',
    animal: json['animal'] as String? ?? '',
    location: json['location'] as String? ?? '',
    condition: json['condition'] as String? ?? '',
    description: json['description'] as String? ?? '',
    progress: (json['progress'] as num?)?.toDouble() ?? 0,
    createdAt: _dateFromJson(json['createdAt']),
  );
}

Map<String, dynamic> _caregiverToJson(CaregiverProfile caregiver) {
  return {
    'id': caregiver.id,
    'name': caregiver.name,
    'location': caregiver.location,
    'availableCare': caregiver.availableCare,
    'detail': caregiver.detail,
    'matchScore': caregiver.matchScore,
    'verified': caregiver.verified,
  };
}

CaregiverProfile _caregiverFromDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final json = doc.data()!;
  return CaregiverProfile(
    id: json['id'] as String? ?? doc.id,
    name: json['name'] as String? ?? '',
    location: json['location'] as String? ?? '',
    availableCare: json['availableCare'] as String? ?? '',
    detail: json['detail'] as String? ?? '',
    matchScore: (json['matchScore'] as num?)?.toInt() ?? 0,
    verified: json['verified'] as bool? ?? false,
  );
}

Map<String, dynamic> _matchToJson(MatchRecord match) {
  return {
    'id': match.id,
    'requestId': match.requestId,
    'caregiverId': match.caregiverId,
    'requesterConfirmed': match.requesterConfirmed,
    'caregiverConfirmed': match.caregiverConfirmed,
  };
}

MatchRecord _matchFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final json = doc.data()!;
  return MatchRecord(
    id: json['id'] as String? ?? doc.id,
    requestId: json['requestId'] as String? ?? '',
    caregiverId: json['caregiverId'] as String? ?? '',
    requesterConfirmed: json['requesterConfirmed'] as bool? ?? false,
    caregiverConfirmed: json['caregiverConfirmed'] as bool? ?? false,
  );
}

Map<String, dynamic> _messageToJson(ChatMessageRecord message) {
  return {
    'id': message.id,
    'matchId': message.matchId,
    'sender': message.sender,
    'text': message.text,
    'mine': message.mine,
  };
}

ChatMessageRecord _messageFromDoc(
  DocumentSnapshot<Map<String, dynamic>> doc,
) {
  final json = doc.data()!;
  return ChatMessageRecord(
    id: json['id'] as String? ?? doc.id,
    matchId: json['matchId'] as String? ?? '',
    sender: json['sender'] as String? ?? '',
    text: json['text'] as String? ?? '',
    mine: json['mine'] as bool? ?? false,
  );
}

Map<String, dynamic> _taskToJson(HandoffTask task) {
  return {
    'id': task.id,
    'title': task.title,
    'done': task.done,
  };
}

HandoffTask _taskFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final json = doc.data()!;
  return HandoffTask(
    id: json['id'] as String? ?? doc.id,
    title: json['title'] as String? ?? '',
    done: json['done'] as bool? ?? false,
  );
}

DateTime _dateFromJson(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}
