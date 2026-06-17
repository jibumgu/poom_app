enum ListingType { request, caregiver }

class DashboardStats {
  const DashboardStats({
    required this.waitingMatches,
    required this.reviewingMatches,
    required this.handoffsReady,
  });

  final int waitingMatches;
  final int reviewingMatches;
  final int handoffsReady;

  DashboardStats copyWith({
    int? waitingMatches,
    int? reviewingMatches,
    int? handoffsReady,
  }) {
    return DashboardStats(
      waitingMatches: waitingMatches ?? this.waitingMatches,
      reviewingMatches: reviewingMatches ?? this.reviewingMatches,
      handoffsReady: handoffsReady ?? this.handoffsReady,
    );
  }
}

class CareRequest {
  const CareRequest({
    required this.id,
    required this.tag,
    required this.title,
    required this.animal,
    required this.location,
    required this.condition,
    required this.description,
    required this.progress,
    required this.createdAt,
  });

  final String id;
  final String tag;
  final String title;
  final String animal;
  final String location;
  final String condition;
  final String description;
  final double progress;
  final DateTime createdAt;

  String get meta => '$animal · $location · $condition';

  CareRequest copyWith({
    String? id,
    String? tag,
    String? title,
    String? animal,
    String? location,
    String? condition,
    String? description,
    double? progress,
    DateTime? createdAt,
  }) {
    return CareRequest(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      title: title ?? this.title,
      animal: animal ?? this.animal,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CaregiverProfile {
  const CaregiverProfile({
    required this.id,
    required this.name,
    required this.location,
    required this.availableCare,
    required this.detail,
    required this.matchScore,
    required this.verified,
  });

  final String id;
  final String name;
  final String location;
  final String availableCare;
  final String detail;
  final int matchScore;
  final bool verified;

  String get meta => '$location · $availableCare';
  String get matchLabel => '$matchScore%';

  CaregiverProfile copyWith({
    String? id,
    String? name,
    String? location,
    String? availableCare,
    String? detail,
    int? matchScore,
    bool? verified,
  }) {
    return CaregiverProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      availableCare: availableCare ?? this.availableCare,
      detail: detail ?? this.detail,
      matchScore: matchScore ?? this.matchScore,
      verified: verified ?? this.verified,
    );
  }
}

class MatchRecord {
  const MatchRecord({
    required this.id,
    required this.requestId,
    required this.caregiverId,
    required this.requesterConfirmed,
    required this.caregiverConfirmed,
  });

  final String id;
  final String requestId;
  final String caregiverId;
  final bool requesterConfirmed;
  final bool caregiverConfirmed;

  bool get chatOpen => requesterConfirmed && caregiverConfirmed;

  MatchRecord copyWith({
    String? id,
    String? requestId,
    String? caregiverId,
    bool? requesterConfirmed,
    bool? caregiverConfirmed,
  }) {
    return MatchRecord(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      caregiverId: caregiverId ?? this.caregiverId,
      requesterConfirmed: requesterConfirmed ?? this.requesterConfirmed,
      caregiverConfirmed: caregiverConfirmed ?? this.caregiverConfirmed,
    );
  }
}

class ChatMessageRecord {
  const ChatMessageRecord({
    required this.id,
    required this.matchId,
    required this.sender,
    required this.text,
    required this.mine,
  });

  final String id;
  final String matchId;
  final String sender;
  final String text;
  final bool mine;

  ChatMessageRecord copyWith({
    String? id,
    String? matchId,
    String? sender,
    String? text,
    bool? mine,
  }) {
    return ChatMessageRecord(
      id: id ?? this.id,
      matchId: matchId ?? this.matchId,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      mine: mine ?? this.mine,
    );
  }
}

class HandoffTask {
  const HandoffTask({
    required this.id,
    required this.title,
    required this.done,
  });

  final String id;
  final String title;
  final bool done;

  HandoffTask copyWith({
    String? id,
    String? title,
    bool? done,
  }) {
    return HandoffTask(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
    );
  }
}

class HomeFeed {
  const HomeFeed({
    required this.stats,
    required this.requests,
    required this.caregivers,
  });

  final DashboardStats stats;
  final List<CareRequest> requests;
  final List<CaregiverProfile> caregivers;
}

class PoomDatabase {
  PoomDatabase.seeded()
      : stats = const DashboardStats(
          waitingMatches: 4,
          reviewingMatches: 9,
          handoffsReady: 11,
        ),
        requests = [
          CareRequest(
            id: 'request-001',
            tag: '오늘',
            title: '2개월 동안 맡아줄 분을 찾고 있어요',
            animal: '강아지',
            location: '서울 마포구',
            condition: '산책 가능',
            description: '병원 기록과 사료 정보가 정리되어 있고, 기존 보호자와 인계 일정을 맞출 수 있어요.',
            progress: 0.72,
            createdAt: DateTime(2026, 6, 17, 9),
          ),
          CareRequest(
            id: 'request-002',
            tag: '오늘',
            title: '퇴근 시간이 늦어져 평일 돌봄이 필요해요',
            animal: '고양이',
            location: '서울 성동구',
            condition: '저녁 돌봄',
            description: '식사와 화장실 체크 위주로 도와줄 분을 찾고 있어요.',
            progress: 0.64,
            createdAt: DateTime(2026, 6, 17, 8),
          ),
          CareRequest(
            id: 'request-003',
            tag: '3일 전',
            title: '조용한 환경에서 돌봐줄 분이 필요해요',
            animal: '고양이',
            location: '경기 성남시',
            condition: '단독 생활',
            description: '알레르기 사료가 필요하고 낯선 환경에 천천히 적응하는 편이에요.',
            progress: 0.46,
            createdAt: DateTime(2026, 6, 14, 15),
          ),
          CareRequest(
            id: 'request-004',
            tag: '이번 주',
            title: '출국 전 임시 보호처를 찾습니다',
            animal: '소형견',
            location: '서울 강서구',
            condition: '1개월',
            description: '예방접종 기록이 있고 인계 전 만남을 원해요.',
            progress: 0.58,
            createdAt: DateTime(2026, 6, 13, 19),
          ),
          CareRequest(
            id: 'request-005',
            tag: '이번 주',
            title: '입원 기간 동안 맡아주실 분을 찾습니다',
            animal: '강아지',
            location: '경기 수원시',
            condition: '3주',
            description: '매일 복용하는 약이 있어 일정한 시간 관리가 필요해요.',
            progress: 0.52,
            createdAt: DateTime(2026, 6, 12, 11),
          ),
          CareRequest(
            id: 'request-006',
            tag: '마감 임박',
            title: '이사 일정 때문에 단기 보호가 필요해요',
            animal: '고양이',
            location: '인천 연수구',
            condition: '10일',
            description: '낯가림이 있어 분리된 방에서 천천히 적응할 수 있는 환경을 원해요.',
            progress: 0.83,
            createdAt: DateTime(2026, 6, 11, 13),
          ),
        ],
        caregivers = [
          CaregiverProfile(
            id: 'caregiver-001',
            name: '김하은',
            location: '서울 은평구',
            availableCare: '소형견 임시 보호',
            detail: '신원 확인, 거주 환경 확인, 돌봄 이력 완료',
            matchScore: 98,
            verified: true,
          ),
          CaregiverProfile(
            id: 'caregiver-002',
            name: '이서준',
            location: '경기 용인시',
            availableCare: '고양이 맡기 가능',
            detail: '반려 경험 7년, 단독 보호 가능',
            matchScore: 94,
            verified: true,
          ),
          CaregiverProfile(
            id: 'caregiver-003',
            name: '박민지',
            location: '서울 송파구',
            availableCare: '주말 단기 보호',
            detail: '소형견 산책 가능, 재택 근무, 인계 일정 유연',
            matchScore: 91,
            verified: true,
          ),
          CaregiverProfile(
            id: 'caregiver-004',
            name: '정우진',
            location: '인천 부평구',
            availableCare: '고양이 단독 보호',
            detail: '별도 방 제공 가능, 기존 반려동물 없음',
            matchScore: 89,
            verified: true,
          ),
          CaregiverProfile(
            id: 'caregiver-005',
            name: '최다은',
            location: '경기 고양시',
            availableCare: '노령견 돌봄 가능',
            detail: '복약 관리 경험, 병원 동행 가능',
            matchScore: 87,
            verified: true,
          ),
          CaregiverProfile(
            id: 'caregiver-006',
            name: '윤서아',
            location: '서울 관악구',
            availableCare: '단기 방문 돌봄',
            detail: '저녁 시간 방문 가능, 체크리스트 기록 선호',
            matchScore: 84,
            verified: false,
          ),
        ],
        matches = [
          MatchRecord(
            id: 'match-001',
            requestId: 'request-001',
            caregiverId: 'caregiver-001',
            requesterConfirmed: true,
            caregiverConfirmed: false,
          ),
        ],
        chatMessages = [
          ChatMessageRecord(
            id: 'message-001',
            matchId: 'match-001',
            sender: '요청자',
            text: '오늘 저녁에 인계가 가능할까요?',
            mine: true,
          ),
          ChatMessageRecord(
            id: 'message-002',
            matchId: 'match-001',
            sender: '보호 가능자',
            text: '가능해요. 사료와 병원 기록만 함께 부탁드려요.',
            mine: false,
          ),
          ChatMessageRecord(
            id: 'message-003',
            matchId: 'match-001',
            sender: '요청자',
            text: '체크리스트에 정리해서 전달할게요.',
            mine: true,
          ),
        ],
        handoffTasks = [
          HandoffTask(id: 'handoff-001', title: '건강 기록과 병원 정보', done: true),
          HandoffTask(id: 'handoff-002', title: '식사량과 사료 종류', done: true),
          HandoffTask(id: 'handoff-003', title: '산책, 배변, 생활 습관', done: false),
          HandoffTask(id: 'handoff-004', title: '비상 연락처와 인계 장소', done: false),
        ];

  DashboardStats stats;
  final List<CareRequest> requests;
  final List<CaregiverProfile> caregivers;
  final List<MatchRecord> matches;
  final List<ChatMessageRecord> chatMessages;
  final List<HandoffTask> handoffTasks;
}

class PoomRepository {
  const PoomRepository(this._database);

  final PoomDatabase _database;

  Future<HomeFeed> fetchHomeFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return HomeFeed(
      stats: _database.stats,
      requests: _database.requests,
      caregivers: _database.caregivers,
    );
  }

  Future<CareRequest> fetchMainRequest() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _database.requests.first;
  }

  Future<CaregiverProfile> fetchMainCaregiver() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _database.caregivers.first;
  }

  Future<List<ChatMessageRecord>> fetchChatMessages(String matchId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _database.chatMessages
        .where((message) => message.matchId == matchId)
        .toList(growable: false);
  }

  Future<List<HandoffTask>> fetchHandoffTasks() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List.unmodifiable(_database.handoffTasks);
  }

  Future<DashboardStats> readDashboardStats() async {
    await _simulateLatency();
    return _database.stats;
  }

  Future<DashboardStats> createDashboardStats(DashboardStats stats) async {
    await _simulateLatency();
    _database.stats = stats;
    return _database.stats;
  }

  Future<DashboardStats> updateDashboardStats(DashboardStats stats) async {
    await _simulateLatency();
    _database.stats = stats;
    return _database.stats;
  }

  Future<void> deleteDashboardStats() async {
    await _simulateLatency();
    _database.stats = const DashboardStats(
      waitingMatches: 0,
      reviewingMatches: 0,
      handoffsReady: 0,
    );
  }

  Future<List<CareRequest>> readCareRequests() async {
    await _simulateLatency();
    return List.unmodifiable(_database.requests);
  }

  Future<CareRequest?> readCareRequest(String id) async {
    await _simulateLatency();
    return _findById(_database.requests, id, (request) => request.id);
  }

  Future<CareRequest> createCareRequest(CareRequest request) async {
    await _simulateLatency();
    _ensureUniqueId(_database.requests, request.id, (item) => item.id);
    _database.requests.insert(0, request);
    return request;
  }

  Future<CareRequest> updateCareRequest(CareRequest request) async {
    await _simulateLatency();
    _replaceById(_database.requests, request, request.id, (item) => item.id);
    return request;
  }

  Future<void> deleteCareRequest(String id) async {
    await _simulateLatency();
    _deleteById(_database.requests, id, (item) => item.id);
    _database.matches.removeWhere((match) => match.requestId == id);
  }

  Future<List<CaregiverProfile>> readCaregivers() async {
    await _simulateLatency();
    return List.unmodifiable(_database.caregivers);
  }

  Future<CaregiverProfile?> readCaregiver(String id) async {
    await _simulateLatency();
    return _findById(_database.caregivers, id, (caregiver) => caregiver.id);
  }

  Future<CaregiverProfile> createCaregiver(CaregiverProfile caregiver) async {
    await _simulateLatency();
    _ensureUniqueId(_database.caregivers, caregiver.id, (item) => item.id);
    _database.caregivers.insert(0, caregiver);
    return caregiver;
  }

  Future<CaregiverProfile> updateCaregiver(CaregiverProfile caregiver) async {
    await _simulateLatency();
    _replaceById(
      _database.caregivers,
      caregiver,
      caregiver.id,
      (item) => item.id,
    );
    return caregiver;
  }

  Future<void> deleteCaregiver(String id) async {
    await _simulateLatency();
    _deleteById(_database.caregivers, id, (item) => item.id);
    _database.matches.removeWhere((match) => match.caregiverId == id);
  }

  Future<List<MatchRecord>> readMatches() async {
    await _simulateLatency();
    return List.unmodifiable(_database.matches);
  }

  Future<MatchRecord?> readMatch(String id) async {
    await _simulateLatency();
    return _findById(_database.matches, id, (match) => match.id);
  }

  Future<MatchRecord> createMatch(MatchRecord match) async {
    await _simulateLatency();
    _ensureUniqueId(_database.matches, match.id, (item) => item.id);
    _requireExists(_database.requests, match.requestId, (item) => item.id);
    _requireExists(_database.caregivers, match.caregiverId, (item) => item.id);
    _database.matches.insert(0, match);
    return match;
  }

  Future<MatchRecord> updateMatch(MatchRecord match) async {
    await _simulateLatency();
    _requireExists(_database.requests, match.requestId, (item) => item.id);
    _requireExists(_database.caregivers, match.caregiverId, (item) => item.id);
    _replaceById(_database.matches, match, match.id, (item) => item.id);
    return match;
  }

  Future<void> deleteMatch(String id) async {
    await _simulateLatency();
    _deleteById(_database.matches, id, (item) => item.id);
    _database.chatMessages.removeWhere((message) => message.matchId == id);
  }

  Future<List<ChatMessageRecord>> readChatMessages(String matchId) async {
    await _simulateLatency();
    return _database.chatMessages
        .where((message) => message.matchId == matchId)
        .toList(growable: false);
  }

  Future<ChatMessageRecord?> readChatMessage(String id) async {
    await _simulateLatency();
    return _findById(_database.chatMessages, id, (message) => message.id);
  }

  Future<ChatMessageRecord> createChatMessage(
    ChatMessageRecord message,
  ) async {
    await _simulateLatency();
    _ensureUniqueId(_database.chatMessages, message.id, (item) => item.id);
    _requireExists(_database.matches, message.matchId, (item) => item.id);
    _database.chatMessages.add(message);
    return message;
  }

  Future<ChatMessageRecord> updateChatMessage(
    ChatMessageRecord message,
  ) async {
    await _simulateLatency();
    _requireExists(_database.matches, message.matchId, (item) => item.id);
    _replaceById(_database.chatMessages, message, message.id, (item) => item.id);
    return message;
  }

  Future<void> deleteChatMessage(String id) async {
    await _simulateLatency();
    _deleteById(_database.chatMessages, id, (item) => item.id);
  }

  Future<List<HandoffTask>> readHandoffTasks() async {
    await _simulateLatency();
    return List.unmodifiable(_database.handoffTasks);
  }

  Future<HandoffTask?> readHandoffTask(String id) async {
    await _simulateLatency();
    return _findById(_database.handoffTasks, id, (task) => task.id);
  }

  Future<HandoffTask> createHandoffTask(HandoffTask task) async {
    await _simulateLatency();
    _ensureUniqueId(_database.handoffTasks, task.id, (item) => item.id);
    _database.handoffTasks.add(task);
    return task;
  }

  Future<HandoffTask> updateHandoffTask(HandoffTask task) async {
    await _simulateLatency();
    _replaceById(_database.handoffTasks, task, task.id, (item) => item.id);
    return task;
  }

  Future<void> deleteHandoffTask(String id) async {
    await _simulateLatency();
    _deleteById(_database.handoffTasks, id, (item) => item.id);
  }

  Future<void> _simulateLatency() {
    return Future<void>.delayed(const Duration(milliseconds: 80));
  }

  T? _findById<T>(List<T> items, String id, String Function(T item) getId) {
    for (final item in items) {
      if (getId(item) == id) {
        return item;
      }
    }
    return null;
  }

  void _ensureUniqueId<T>(
    List<T> items,
    String id,
    String Function(T item) getId,
  ) {
    if (_findById(items, id, getId) != null) {
      throw StateError('이미 존재하는 id입니다: $id');
    }
  }

  void _requireExists<T>(
    List<T> items,
    String id,
    String Function(T item) getId,
  ) {
    if (_findById(items, id, getId) == null) {
      throw StateError('존재하지 않는 id입니다: $id');
    }
  }

  void _replaceById<T>(
    List<T> items,
    T nextItem,
    String id,
    String Function(T item) getId,
  ) {
    final index = items.indexWhere((item) => getId(item) == id);
    if (index == -1) {
      throw StateError('수정할 데이터를 찾을 수 없습니다: $id');
    }
    items[index] = nextItem;
  }

  void _deleteById<T>(
    List<T> items,
    String id,
    String Function(T item) getId,
  ) {
    final removedCount = items.length;
    items.removeWhere((item) => getId(item) == id);
    if (items.length == removedCount) {
      throw StateError('삭제할 데이터를 찾을 수 없습니다: $id');
    }
  }
}
