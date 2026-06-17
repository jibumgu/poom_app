import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/poom_database.dart';

void main() {
  runApp(const PoomApp());
}

final _poomRepository = PoomRepository(PoomDatabase.seeded());

const _brand = Color(0xFF256D5D);
const _brandDark = Color(0xFF1F4F44);
const _ink = Color(0xFF26312D);
const _muted = Color(0xFF66736E);
const _bg = Color(0xFFF6F7F3);
const _softGreen = Color(0xFFEDF7F2);
const _line = Color(0xFFE2E8E1);
const _notice = Color(0xFFFFF6E6);

enum AppRole {
  requester('요청자'),
  caregiver('보호 가능자');

  const AppRole(this.label);

  final String label;
}

enum FeedSort {
  recommended('추천순'),
  newest('최신순'),
  progress('진행도순'),
  name('이름순');

  const FeedSort(this.label);

  final String label;
}

enum RegistrationMode {
  request('도움 요청'),
  caregiver('보호 가능');

  const RegistrationMode(this.label);

  final String label;
}

class LocalAppStore {
  static const _roleKey = 'poom.role';
  static const _matchNotiKey = 'poom.matchNotifications';
  static const _chatNotiKey = 'poom.chatNotifications';
  static const _favoritesKey = 'poom.favoriteIds';
  static const _requestDraftKey = 'poom.requestDraft';
  static const _caregiverDraftKey = 'poom.caregiverDraft';

  static Future<AppRole> readRole() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_roleKey);
    return AppRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => AppRole.requester,
    );
  }

  static Future<void> saveRole(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.name);
  }

  static Future<bool> readBool(String key, {required bool fallback}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? fallback;
  }

  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> readMatchNotifications() {
    return readBool(_matchNotiKey, fallback: true);
  }

  static Future<void> saveMatchNotifications(bool value) {
    return saveBool(_matchNotiKey, value);
  }

  static Future<bool> readChatNotifications() {
    return readBool(_chatNotiKey, fallback: true);
  }

  static Future<void> saveChatNotifications(bool value) {
    return saveBool(_chatNotiKey, value);
  }

  static Future<Set<String>> readFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_favoritesKey) ?? const <String>[]).toSet();
  }

  static Future<void> saveFavorites(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, ids.toList()..sort());
  }

  static Future<List<String>?> readRequestDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_requestDraftKey);
    return values != null && values.length == 5 ? values : null;
  }

  static Future<void> saveRequestDraft(List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_requestDraftKey, values);
  }

  static Future<List<String>?> readCaregiverDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_caregiverDraftKey);
    return values != null && values.length == 4 ? values : null;
  }

  static Future<void> saveCaregiverDraft(List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_caregiverDraftKey, values);
  }
}

class PoomApp extends StatelessWidget {
  const PoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '품',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brand,
          surface: _bg,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: _ink,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            height: 1.18,
          ),
          titleLarge: TextStyle(
            color: _ink,
            fontSize: 21,
            fontWeight: FontWeight.w900,
          ),
          titleMedium: TextStyle(
            color: _ink,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
          bodyMedium: TextStyle(
            color: _ink,
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ),
      home: const IntroGate(),
    );
  }
}

class IntroGate extends StatefulWidget {
  const IntroGate({super.key});

  @override
  State<IntroGate> createState() => _IntroGateState();
}

class _IntroGateState extends State<IntroGate> {
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4300), () {
      if (mounted) {
        setState(() => _showIntro = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      child: _showIntro ? const IntroScreen() : const ShellScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const _title = '품 : 평생의 반려(伴侶)';
  static const _subtitle = '평생을 함께하다';

  bool _logoVisible = false;
  String _visibleTitle = '';
  String _visibleSubtitle = '';

  @override
  void initState() {
    super.initState();
    _startIntro();
  }

  Future<void> _startIntro() async {
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;
    setState(() => _logoVisible = true);

    await Future<void>.delayed(const Duration(milliseconds: 520));
    for (var i = 0; i <= _title.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 58));
      if (!mounted) return;
      setState(() => _visibleTitle = _title.substring(0, i));
    }

    await Future<void>.delayed(const Duration(milliseconds: 280));
    for (var i = 0; i <= _subtitle.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 56));
      if (!mounted) return;
      setState(() => _visibleSubtitle = _subtitle.substring(0, i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedOpacity(
                      opacity: _logoVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 360),
                      child:
                          const BrandMark(size: 78, radius: 18, fontSize: 32),
                    ),
                    const SizedBox(width: 14),
                    IntrinsicWidth(
                      child: Text(
                        _visibleTitle,
                        maxLines: 1,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 260),
                  offset: _visibleSubtitle.isEmpty
                      ? const Offset(0, 0.22)
                      : Offset.zero,
                  child: SizedBox(
                    height: 28,
                    child: Text(
                      _visibleSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;
  bool _requesterConfirmed = true;
  bool _caregiverConfirmed = false;
  bool _matchNotifications = true;
  bool _chatNotifications = true;
  AppRole _role = AppRole.requester;

  bool get _chatOpen => _requesterConfirmed && _caregiverConfirmed;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final role = await LocalAppStore.readRole();
    final matchNotifications = await LocalAppStore.readMatchNotifications();
    final chatNotifications = await LocalAppStore.readChatNotifications();
    if (!mounted) return;
    setState(() {
      _role = role;
      _matchNotifications = matchNotifications;
      _chatNotifications = chatNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        onOpenRegistration: () => setState(() => _index = 1),
        onOpenMatch: () => setState(() => _index = 2),
      ),
      const RequestPage(),
      MatchPage(
        requesterConfirmed: _requesterConfirmed,
        caregiverConfirmed: _caregiverConfirmed,
        onRequesterChanged: (value) {
          setState(() => _requesterConfirmed = value);
        },
        onCaregiverChanged: (value) {
          setState(() => _caregiverConfirmed = value);
        },
      ),
      ChatPage(chatOpen: _chatOpen),
      HandoffPage(chatOpen: _chatOpen),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandMark(size: 34, radius: 9, fontSize: 17),
            SizedBox(width: 10),
            Text(
              '품',
              style: TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '알림함',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => NotificationCenterPage(
                    chatOpen: _chatOpen,
                    matchNotifications: _matchNotifications,
                    chatNotifications: _chatNotifications,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none, color: _brand),
          ),
          IconButton(
            tooltip: '역할과 알림 설정',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SettingsPage(
                    role: _role,
                    matchNotifications: _matchNotifications,
                    chatNotifications: _chatNotifications,
                    onRoleChanged: (role) {
                      setState(() => _role = role);
                      LocalAppStore.saveRole(role);
                    },
                    onMatchNotificationsChanged: (value) {
                      setState(() => _matchNotifications = value);
                      LocalAppStore.saveMatchNotifications(value);
                    },
                    onChatNotificationsChanged: (value) {
                      setState(() => _chatNotifications = value);
                      LocalAppStore.saveChatNotifications(value);
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.person_outline, color: _brand),
          ),
          IconButton(
            tooltip: '개발용 데이터 관리',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CrudConsolePage(),
                ),
              );
            },
            icon: const Icon(Icons.storage_outlined, color: _brand),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ResponsivePage(child: pages[_index]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        height: 68,
        indicatorColor: _softGreen,
        backgroundColor: Colors.white,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(
              icon: Icon(Icons.edit_note_outlined), label: '등록'),
          NavigationDestination(
              icon: Icon(Icons.handshake_outlined), label: '매칭'),
          NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          NavigationDestination(
              icon: Icon(Icons.fact_check_outlined), label: '인계'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    required this.onOpenRegistration,
    required this.onOpenMatch,
    super.key,
  });

  final VoidCallback onOpenRegistration;
  final VoidCallback onOpenMatch;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showRequests = true;
  String _query = '';
  String _region = '전체';
  FeedSort _sort = FeedSort.recommended;
  final Set<String> _favoriteIds = <String>{};
  late final Future<HomeFeed> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _poomRepository.fetchHomeFeed();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await LocalAppStore.readFavorites();
    if (!mounted) return;
    setState(() {
      _favoriteIds
        ..clear()
        ..addAll(favorites);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Text(
          '오늘 필요한 연결',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          '사정이 생긴 보호자와 도움을 줄 수 있는 사람이 서로 확인한 뒤 대화를 시작합니다.',
          style: TextStyle(color: _muted, fontSize: 16),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: widget.onOpenRegistration,
          style: FilledButton.styleFrom(
            backgroundColor: _brand,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            '도움 요청 또는 보호 가능 등록',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(height: 18),
        FutureBuilder<HomeFeed>(
          future: _feedFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const FeedLoadingState();
            }

            final feed = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickStatusStrip(stats: feed.stats),
                const SizedBox(height: 14),
                const SafetyOverviewCard(),
                const SizedBox(height: 20),
                FeedSearchBar(
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 10),
                RegionFilterBar(
                  selected: _region,
                  onChanged: (value) => setState(() => _region = value),
                ),
                const SizedBox(height: 10),
                FeedSortBar(
                  selected: _sort,
                  onChanged: (value) => setState(() => _sort = value),
                ),
                const SizedBox(height: 18),
                FeedToggle(
                  showRequests: _showRequests,
                  onChanged: (value) => setState(() => _showRequests = value),
                ),
                const SizedBox(height: 16),
                SectionHeader(
                  title: _showRequests ? '도움이 필요한 요청' : '보호 가능자',
                  action: _showRequests ? '가까운 순' : '적합도 순',
                ),
                if (_showRequests)
                  ..._buildRequestResults(context, feed.requests)
                else
                  ..._buildCaregiverResults(context, feed.caregivers),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildRequestResults(
    BuildContext context,
    List<CareRequest> requests,
  ) {
    final filtered = _filterRequests(requests);
    if (filtered.isEmpty) {
      return const [
        EmptyResultCard(
          title: '조건에 맞는 요청이 없어요',
          copy: '검색어를 줄이거나 지역 필터를 전체로 바꿔보세요.',
        ),
      ];
    }

    return [
      for (final request in filtered)
        RequestFeedCard(
          id: request.id,
          tag: request.tag,
          title: request.title,
          meta: request.meta,
          description: request.description,
          progress: request.progress,
          favorite: _favoriteIds.contains(request.id),
          onFavorite: () => _toggleFavorite(request.id),
          onTap: () => _showRequestDetail(context, request),
        ),
    ];
  }

  List<Widget> _buildCaregiverResults(
    BuildContext context,
    List<CaregiverProfile> caregivers,
  ) {
    final filtered = _filterCaregivers(caregivers);
    if (filtered.isEmpty) {
      return const [
        EmptyResultCard(
          title: '조건에 맞는 보호 가능자가 없어요',
          copy: '검색어를 줄이거나 지역 필터를 전체로 바꿔보세요.',
        ),
      ];
    }

    return [
      for (final caregiver in filtered)
        CaregiverFeedCard(
          id: caregiver.id,
          name: caregiver.name,
          meta: caregiver.meta,
          detail: caregiver.detail,
          match: caregiver.matchLabel,
          favorite: _favoriteIds.contains(caregiver.id),
          onFavorite: () => _toggleFavorite(caregiver.id),
          onTap: () => _showCaregiverDetail(context, caregiver),
        ),
    ];
  }

  List<CareRequest> _filterRequests(List<CareRequest> requests) {
    final query = _query.trim().toLowerCase();
    final filtered = requests.where((request) {
      final matchesRegion =
          _region == '전체' || request.location.contains(_region);
      final text = '${request.title} ${request.meta} ${request.description}'
          .toLowerCase();
      final matchesQuery = query.isEmpty || text.contains(query);
      return matchesRegion && matchesQuery;
    }).toList(growable: false);
    _sortRequests(filtered);
    return filtered;
  }

  List<CaregiverProfile> _filterCaregivers(List<CaregiverProfile> caregivers) {
    final query = _query.trim().toLowerCase();
    final filtered = caregivers.where((caregiver) {
      final matchesRegion =
          _region == '전체' || caregiver.location.contains(_region);
      final text = '${caregiver.name} ${caregiver.meta} ${caregiver.detail}'
          .toLowerCase();
      final matchesQuery = query.isEmpty || text.contains(query);
      return matchesRegion && matchesQuery;
    }).toList(growable: false);
    _sortCaregivers(filtered);
    return filtered;
  }

  void _sortRequests(List<CareRequest> requests) {
    switch (_sort) {
      case FeedSort.recommended:
        requests.sort((a, b) => b.progress.compareTo(a.progress));
      case FeedSort.newest:
        requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case FeedSort.progress:
        requests.sort((a, b) => b.progress.compareTo(a.progress));
      case FeedSort.name:
        requests.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void _sortCaregivers(List<CaregiverProfile> caregivers) {
    switch (_sort) {
      case FeedSort.recommended:
        caregivers.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      case FeedSort.newest:
        caregivers.sort((a, b) => a.name.compareTo(b.name));
      case FeedSort.progress:
        caregivers.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      case FeedSort.name:
        caregivers.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  void _toggleFavorite(String id) {
    setState(() {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
    });
    LocalAppStore.saveFavorites(_favoriteIds);
  }

  void _showRequestDetail(BuildContext context, CareRequest request) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DetailSheet(
          title: request.title,
          subtitle: request.meta,
          primaryLabel: '보호 가능자 선택하기',
          onPrimary: () async {
            Navigator.of(context).pop();
            await _chooseCaregiverForRequest(request);
          },
          rows: [
            DetailRow(label: '요청 ID', value: request.id),
            DetailRow(label: '상태', value: request.tag),
            DetailRow(label: '조건', value: request.condition),
            DetailRow(label: '설명', value: request.description),
          ],
        );
      },
    );
  }

  void _showCaregiverDetail(BuildContext context, CaregiverProfile caregiver) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DetailSheet(
          title: caregiver.name,
          subtitle: caregiver.meta,
          primaryLabel: '도움 요청 선택하기',
          onPrimary: () async {
            Navigator.of(context).pop();
            await _chooseRequestForCaregiver(caregiver);
          },
          rows: [
            DetailRow(label: '프로필 ID', value: caregiver.id),
            DetailRow(label: '적합도', value: caregiver.matchLabel),
            DetailRow(
                label: '확인 상태', value: caregiver.verified ? '확인 완료' : '확인 대기'),
            DetailRow(label: '상세', value: caregiver.detail),
          ],
        );
      },
    );
  }

  Future<void> _chooseCaregiverForRequest(CareRequest request) async {
    final caregivers = await _poomRepository.readCaregivers();
    if (caregivers.isEmpty) {
      _showSnack('매칭할 보호 가능자가 아직 없어요.');
      return;
    }

    if (!mounted) return;
    final selected = await showModalBottomSheet<CaregiverProfile>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return MatchChoiceSheet<CaregiverProfile>(
          title: '보호 가능자 선택',
          subtitle: '요청 조건과 가장 잘 맞는 사람을 직접 선택해 주세요.',
          items: caregivers,
          itemBuilder: (context, caregiver) => MatchChoiceTile(
            title: caregiver.name,
            subtitle: caregiver.meta,
            trailing: '${caregiver.matchScore}%',
            body: caregiver.detail,
            verified: caregiver.verified,
            onTap: () => Navigator.of(context).pop(caregiver),
          ),
        );
      },
    );

    if (selected == null) return;
    await _createMatch(
      requestId: request.id,
      caregiverId: selected.id,
      requesterConfirmed: true,
      caregiverConfirmed: false,
    );
  }

  Future<void> _chooseRequestForCaregiver(CaregiverProfile caregiver) async {
    final requests = await _poomRepository.readCareRequests();
    if (requests.isEmpty) {
      _showSnack('매칭할 도움 요청이 아직 없어요.');
      return;
    }

    if (!mounted) return;
    final selected = await showModalBottomSheet<CareRequest>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return MatchChoiceSheet<CareRequest>(
          title: '도움 요청 선택',
          subtitle: '보호 가능 조건에 맞는 요청을 직접 선택해 주세요.',
          items: requests,
          itemBuilder: (context, request) => MatchChoiceTile(
            title: request.title,
            subtitle: request.meta,
            trailing: request.tag,
            body: request.description,
            verified: true,
            onTap: () => Navigator.of(context).pop(request),
          ),
        );
      },
    );

    if (selected == null) return;
    await _createMatch(
      requestId: selected.id,
      caregiverId: caregiver.id,
      requesterConfirmed: false,
      caregiverConfirmed: true,
    );
  }

  Future<void> _createMatch({
    required String requestId,
    required String caregiverId,
    required bool requesterConfirmed,
    required bool caregiverConfirmed,
  }) async {
    await _poomRepository.createMatch(
      MatchRecord(
        id: 'match-${DateTime.now().millisecondsSinceEpoch}',
        requestId: requestId,
        caregiverId: caregiverId,
        requesterConfirmed: requesterConfirmed,
        caregiverConfirmed: caregiverConfirmed,
      ),
    );
    _showSnack('1대1 매칭 검토가 생성됐어요.');
    widget.onOpenMatch();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class FeedLoadingState extends StatelessWidget {
  const FeedLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AppCard(
          child: SizedBox(
            height: 88,
            child: Center(
              child: CircularProgressIndicator(color: _brand),
            ),
          ),
        ),
        AppCard(
          child: SizedBox(height: 120),
        ),
        AppCard(
          child: SizedBox(height: 120),
        ),
      ],
    );
  }
}

class FeedSearchBar extends StatelessWidget {
  const FeedSearchBar({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: '지역, 조건, 키워드 검색',
        prefixIcon: const Icon(Icons.search, color: _muted),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: _brand, width: 1.4),
        ),
      ),
    );
  }
}

class RegionFilterBar extends StatelessWidget {
  const RegionFilterBar({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _regions = ['전체', '서울', '경기', '인천'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final region in _regions)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(region),
                selected: selected == region,
                selectedColor: _softGreen,
                checkmarkColor: _brand,
                side: const BorderSide(color: _line),
                onSelected: (_) => onChanged(region),
              ),
            ),
        ],
      ),
    );
  }
}

class FeedSortBar extends StatelessWidget {
  const FeedSortBar({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final FeedSort selected;
  final ValueChanged<FeedSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.sort, color: _muted, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<FeedSort>(
            initialValue: selected,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _line),
              ),
            ),
            items: [
              for (final sort in FeedSort.values)
                DropdownMenuItem(value: sort, child: Text(sort.label)),
            ],
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class FeedToggle extends StatelessWidget {
  const FeedToggle({
    required this.showRequests,
    required this.onChanged,
    super.key,
  });

  final bool showRequests;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Expanded(
            child: FeedToggleButton(
              label: '도움 요청',
              selected: showRequests,
              onTap: () => onChanged(true),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: FeedToggleButton(
              label: '보호 가능자',
              selected: !showRequests,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyResultCard extends StatelessWidget {
  const EmptyResultCard({
    required this.title,
    required this.copy,
    super.key,
  });

  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          const Icon(Icons.search_off_outlined, color: _brand, size: 34),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            copy,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
        ],
      ),
    );
  }
}

class FeedToggleButton extends StatelessWidget {
  const FeedToggleButton({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? _brand : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : _muted,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  RegistrationMode _mode = RegistrationMode.request;
  String? _lastCreatedMessage;
  bool _loadingDrafts = true;

  final _animal = TextEditingController(text: '강아지');
  final _type = TextEditingController(text: '임시 보호');
  final _location = TextEditingController(text: '서울 마포구');
  final _period = TextEditingController(text: '2개월');
  final _condition = TextEditingController(
    text: '매일 산책 가능, 병원 기록 확인, 기존 보호자와 사전 조건 확인',
  );
  final _caregiverName = TextEditingController(text: '김하은');
  final _caregiverLocation = TextEditingController(text: '서울 마포구');
  final _availableCare = TextEditingController(text: '2개월 임시 보호');
  final _caregiverDetail = TextEditingController(
    text: '재택 근무 중이라 평일 낮 돌봄 가능, 산책과 병원 동행 가능',
  );

  @override
  void initState() {
    super.initState();
    _attachDraftListeners();
    _loadDrafts();
  }

  void _attachDraftListeners() {
    _animal.addListener(_saveRequestDraft);
    _type.addListener(_saveRequestDraft);
    _location.addListener(_saveRequestDraft);
    _period.addListener(_saveRequestDraft);
    _condition.addListener(_saveRequestDraft);
    _caregiverName.addListener(_saveCaregiverDraft);
    _caregiverLocation.addListener(_saveCaregiverDraft);
    _availableCare.addListener(_saveCaregiverDraft);
    _caregiverDetail.addListener(_saveCaregiverDraft);
  }

  Future<void> _loadDrafts() async {
    final requestDraft = await LocalAppStore.readRequestDraft();
    final caregiverDraft = await LocalAppStore.readCaregiverDraft();
    if (!mounted) return;

    if (requestDraft != null) {
      _animal.text = requestDraft[0];
      _type.text = requestDraft[1];
      _location.text = requestDraft[2];
      _period.text = requestDraft[3];
      _condition.text = requestDraft[4];
    }

    if (caregiverDraft != null) {
      _caregiverName.text = caregiverDraft[0];
      _caregiverLocation.text = caregiverDraft[1];
      _availableCare.text = caregiverDraft[2];
      _caregiverDetail.text = caregiverDraft[3];
    }

    setState(() {
      _loadingDrafts = false;
    });
  }

  void _saveRequestDraft() {
    if (_loadingDrafts) return;
    LocalAppStore.saveRequestDraft([
      _animal.text,
      _type.text,
      _location.text,
      _period.text,
      _condition.text,
    ]);
  }

  void _saveCaregiverDraft() {
    if (_loadingDrafts) return;
    LocalAppStore.saveCaregiverDraft([
      _caregiverName.text,
      _caregiverLocation.text,
      _availableCare.text,
      _caregiverDetail.text,
    ]);
  }

  @override
  void dispose() {
    _animal.removeListener(_saveRequestDraft);
    _type.removeListener(_saveRequestDraft);
    _location.removeListener(_saveRequestDraft);
    _period.removeListener(_saveRequestDraft);
    _condition.removeListener(_saveRequestDraft);
    _caregiverName.removeListener(_saveCaregiverDraft);
    _caregiverLocation.removeListener(_saveCaregiverDraft);
    _availableCare.removeListener(_saveCaregiverDraft);
    _caregiverDetail.removeListener(_saveCaregiverDraft);
    _animal.dispose();
    _type.dispose();
    _location.dispose();
    _period.dispose();
    _condition.dispose();
    _caregiverName.dispose();
    _caregiverLocation.dispose();
    _availableCare.dispose();
    _caregiverDetail.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    final animal = _animal.text.trim();
    final type = _type.text.trim();
    final location = _location.text.trim();
    final period = _period.text.trim();
    final condition = _condition.text.trim();

    if ([animal, type, location, period, condition]
        .any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 내용을 모두 입력해 주세요.')),
      );
      return;
    }

    final request = CareRequest(
      id: 'request-${DateTime.now().millisecondsSinceEpoch}',
      tag: '신규',
      title: '$period 동안 도움을 요청합니다',
      animal: animal,
      location: location,
      condition: type,
      description: condition,
      progress: 0.25,
      createdAt: DateTime.now(),
    );

    await _poomRepository.createCareRequest(request);
    if (!mounted) return;
    setState(() {
      _lastCreatedMessage = '도움 요청이 홈 피드에 등록됐어요.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('도움 요청이 등록됐어요. 홈 피드에서 확인할 수 있어요.')),
    );
  }

  Future<void> _submitCaregiver() async {
    final name = _caregiverName.text.trim();
    final location = _caregiverLocation.text.trim();
    final availableCare = _availableCare.text.trim();
    final detail = _caregiverDetail.text.trim();

    if ([name, location, availableCare, detail].any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 내용을 모두 입력해 주세요.')),
      );
      return;
    }

    final caregiver = CaregiverProfile(
      id: 'caregiver-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      location: location,
      availableCare: availableCare,
      detail: detail,
      matchScore: 82,
      verified: false,
    );

    await _poomRepository.createCaregiver(caregiver);
    if (!mounted) return;
    setState(() {
      _lastCreatedMessage = '보호 가능 프로필이 홈 피드에 등록됐어요.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('보호 가능 프로필이 등록됐어요. 홈 피드에서 확인할 수 있어요.')),
    );
  }

  void _changeMode(RegistrationMode mode) {
    setState(() {
      _mode = mode;
      _lastCreatedMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        PageTitle(
          title: _mode == RegistrationMode.request ? '도움 등록' : '보호 가능 등록',
          subtitle: _mode == RegistrationMode.request
              ? '공개 목록에는 꼭 필요한 정보만 보여줍니다.'
              : '도움을 줄 수 있는 조건을 간단히 남겨주세요.',
        ),
        RegistrationModeSwitch(
          selected: _mode,
          onChanged: _changeMode,
        ),
        const SizedBox(height: 14),
        if (_lastCreatedMessage != null)
          NoticeBox(
            title: '등록 완료',
            copy: '$_lastCreatedMessage 홈에서 조건에 맞는 상대를 확인하고 1대1 매칭을 시작할 수 있어요.',
          ),
        AppCard(
          child: _mode == RegistrationMode.request
              ? RequestRegistrationForm(
                  animal: _animal,
                  type: _type,
                  location: _location,
                  period: _period,
                  condition: _condition,
                  onSubmit: _submitRequest,
                )
              : CaregiverRegistrationForm(
                  name: _caregiverName,
                  location: _caregiverLocation,
                  availableCare: _availableCare,
                  detail: _caregiverDetail,
                  onSubmit: _submitCaregiver,
                ),
        ),
        RegistrationGuideCard(mode: _mode),
        NoticeBox(
          title: _mode == RegistrationMode.request
              ? '민감한 정보는 바로 공개되지 않아요'
              : '도움 가능 조건만 먼저 보여줘요',
          copy: _mode == RegistrationMode.request
              ? '상호 매칭이 확정된 뒤 앱 채팅에서 필요한 내용만 나눌 수 있어요. 입력 중인 내용은 이 기기에 임시 저장됩니다.'
              : '상세 주소나 연락처는 상호 확정 후 채팅에서 필요한 만큼만 공유합니다. 입력 중인 내용은 이 기기에 임시 저장됩니다.',
        ),
      ],
    );
  }
}

class RegistrationGuideCard extends StatelessWidget {
  const RegistrationGuideCard({
    required this.mode,
    super.key,
  });

  final RegistrationMode mode;

  @override
  Widget build(BuildContext context) {
    final isRequest = mode == RegistrationMode.request;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isRequest ? '등록 후 흐름' : '프로필 등록 후 흐름',
            style: const TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          RegistrationStepRow(
            number: '1',
            title: isRequest ? '홈 피드에 요청 표시' : '홈 피드에 보호 가능 표시',
            copy: isRequest ? '지역과 조건 중심으로 보여줍니다.' : '가능한 도움과 지역 중심으로 보여줍니다.',
          ),
          RegistrationStepRow(
            number: '2',
            title: '서로 선택하면 매칭 검토',
            copy: '한쪽 선택만으로는 채팅이 열리지 않습니다.',
          ),
          const RegistrationStepRow(
            number: '3',
            title: '상호 확정 후 비공개 채팅',
            copy: '인계에 필요한 내용만 앱 안에서 조율합니다.',
            last: true,
          ),
        ],
      ),
    );
  }
}

class RegistrationStepRow extends StatelessWidget {
  const RegistrationStepRow({
    required this.number,
    required this.title,
    required this.copy,
    this.last = false,
    super.key,
  });

  final String number;
  final String title;
  final String copy;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _softGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: _brand,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(copy, style: const TextStyle(color: _muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RegistrationModeSwitch extends StatelessWidget {
  const RegistrationModeSwitch({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final RegistrationMode selected;
  final ValueChanged<RegistrationMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          for (final mode in RegistrationMode.values) ...[
            Expanded(
              child: FeedToggleButton(
                label: mode.label,
                selected: selected == mode,
                onTap: () => onChanged(mode),
              ),
            ),
            if (mode != RegistrationMode.values.last) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class RequestRegistrationForm extends StatelessWidget {
  const RequestRegistrationForm({
    required this.animal,
    required this.type,
    required this.location,
    required this.period,
    required this.condition,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController animal;
  final TextEditingController type;
  final TextEditingController location;
  final TextEditingController period;
  final TextEditingController condition;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CrudTextField(label: '동물 구분', controller: animal),
        _CrudTextField(label: '도움 유형', controller: type),
        _CrudTextField(label: '지역', controller: location),
        _CrudTextField(label: '필요 기간', controller: period),
        _CrudTextField(
          label: '꼭 필요한 조건',
          controller: condition,
          maxLines: 3,
        ),
        const SizedBox(height: 6),
        FilledButton.icon(
          onPressed: onSubmit,
          icon: const Icon(Icons.edit_note_outlined),
          label: const Text('도움 요청 등록'),
          style: FilledButton.styleFrom(
            backgroundColor: _brand,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

class CaregiverRegistrationForm extends StatelessWidget {
  const CaregiverRegistrationForm({
    required this.name,
    required this.location,
    required this.availableCare,
    required this.detail,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController name;
  final TextEditingController location;
  final TextEditingController availableCare;
  final TextEditingController detail;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CrudTextField(label: '이름 또는 닉네임', controller: name),
        _CrudTextField(label: '지역', controller: location),
        _CrudTextField(label: '가능한 도움', controller: availableCare),
        _CrudTextField(
          label: '상세 조건',
          controller: detail,
          maxLines: 3,
        ),
        const SizedBox(height: 6),
        FilledButton.icon(
          onPressed: onSubmit,
          icon: const Icon(Icons.volunteer_activism_outlined),
          label: const Text('보호 가능 등록'),
          style: FilledButton.styleFrom(
            backgroundColor: _brand,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

class MatchPage extends StatelessWidget {
  const MatchPage({
    required this.requesterConfirmed,
    required this.caregiverConfirmed,
    required this.onRequesterChanged,
    required this.onCaregiverChanged,
    super.key,
  });

  final bool requesterConfirmed;
  final bool caregiverConfirmed;
  final ValueChanged<bool> onRequesterChanged;
  final ValueChanged<bool> onCaregiverChanged;

  @override
  Widget build(BuildContext context) {
    final chatOpen = requesterConfirmed && caregiverConfirmed;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        const PageTitle(
          title: '1대1 매칭',
          subtitle: '양쪽이 모두 선택해야 비공개 채팅이 열립니다.',
        ),
        FutureBuilder<List<MatchBundle>>(
          future: _loadMatchBundles(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const AppCard(
                child: SizedBox(
                  height: 92,
                  child:
                      Center(child: CircularProgressIndicator(color: _brand)),
                ),
              );
            }

            final bundles = snapshot.data!;
            if (bundles.isEmpty) {
              return const EmptyResultCard(
                title: '진행 중인 매칭이 없어요',
                copy: '등록을 마친 뒤 홈 피드에서 상대를 선택하면 매칭 검토가 시작됩니다.',
              );
            }

            return Column(
              children: [
                for (final bundle in bundles.take(3))
                  MatchSummaryCard(
                    bundle: bundle,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              MatchDetailPage(matchId: bundle.match.id),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
        FutureBuilder<List<MatchRecord>>(
          future: _poomRepository.readMatches(),
          builder: (context, snapshot) {
            final count = snapshot.data?.length ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NoticeBox(
                  title: '진행 중인 매칭 $count건',
                  copy: '매칭은 요청자와 보호 가능자가 모두 확정해야 채팅으로 이어집니다.',
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const MatchHistoryPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('매칭 이력 보기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _brand,
                    side: const BorderSide(color: _line),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
        ConfirmCard(
          label: '요청자',
          name: '모카 보호자',
          value: requesterConfirmed,
          onChanged: onRequesterChanged,
        ),
        ConfirmCard(
          label: '보호 가능자',
          name: '김하은',
          value: caregiverConfirmed,
          onChanged: onCaregiverChanged,
        ),
        NoticeBox(
          title: chatOpen ? '채팅방이 열렸어요' : '아직 채팅방이 닫혀 있어요',
          copy: chatOpen
              ? '이제 앱 안에서 인계 일정과 필요한 정보를 조율할 수 있어요.'
              : '서로 확정하면 비공개 채팅이 시작됩니다.',
          success: chatOpen,
        ),
      ],
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({required this.chatOpen, super.key});

  final bool chatOpen;

  @override
  Widget build(BuildContext context) {
    return ChatRoomList(
      onOpenRoom: (matchId) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ChatRoomPage(
              matchId: matchId,
            ),
          ),
        );
      },
    );
  }
}

class ChatRoomList extends StatelessWidget {
  const ChatRoomList({
    required this.onOpenRoom,
    super.key,
  });

  final ValueChanged<String> onOpenRoom;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchBundle>>(
      future: _loadMatchBundles(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: _brand));
        }

        final bundles = snapshot.data!;
        final openRoomCount =
            bundles.where((bundle) => bundle.match.chatOpen).length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            PageTitle(
              title: '채팅방',
              subtitle: openRoomCount > 0
                  ? '상호 확정된 매칭에서 대화를 이어갑니다.'
                  : '양쪽이 모두 확정되면 채팅방이 열립니다.',
            ),
            if (openRoomCount == 0)
              const NoticeBox(
                title: '채팅은 아직 열리지 않았어요',
                copy: '요청자와 보호 가능자가 모두 확정하면 대화할 수 있어요.',
                success: false,
              ),
            if (bundles.isEmpty)
              const EmptyResultCard(
                title: '아직 채팅방이 없어요',
                copy: '매칭을 먼저 생성하고 양쪽 확정을 진행해 주세요.',
              )
            else
              for (final bundle in bundles)
                ChatRoomCard(
                  bundle: bundle,
                  enabled: bundle.match.chatOpen,
                  onTap: () => onOpenRoom(bundle.match.id),
                ),
          ],
        );
      },
    );
  }
}

class ChatRoomCard extends StatelessWidget {
  const ChatRoomCard({
    required this.bundle,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final MatchBundle bundle;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: enabled ? _softGreen : _bg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                enabled ? Icons.chat_bubble_outline : Icons.lock_outline,
                color: enabled ? _brand : _muted,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bundle.requestTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bundle.caregiverName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: _muted),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    bundle.match.id,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              enabled ? '열림' : '대기',
              style: TextStyle(
                color: enabled ? _brand : _muted,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({
    required this.matchId,
    super.key,
  });

  final String matchId;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late Future<List<ChatMessageRecord>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _poomRepository.fetchChatMessages(widget.matchId);
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    await _poomRepository.createChatMessage(
      ChatMessageRecord(
        id: 'message-${DateTime.now().millisecondsSinceEpoch}',
        matchId: widget.matchId,
        sender: '요청자',
        text: trimmed,
        mine: true,
      ),
    );

    setState(() {
      _messagesFuture = _poomRepository.fetchChatMessages(widget.matchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.matchId,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ChatMessageRecord>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                final messages = snapshot.data ?? const <ChatMessageRecord>[];

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  children: [
                    const PageTitle(
                        title: '비공개 대화', subtitle: '인계 일정과 필요한 정보를 조율합니다.'),
                    if (!snapshot.hasData)
                      const AppCard(
                        child: SizedBox(
                          height: 82,
                          child: Center(
                            child: CircularProgressIndicator(color: _brand),
                          ),
                        ),
                      )
                    else if (messages.isEmpty)
                      const EmptyResultCard(
                        title: '아직 대화가 없어요',
                        copy: '인계 가능한 일정이나 꼭 확인할 조건부터 남겨보세요.',
                      )
                    else
                      for (final message in messages)
                        ChatBubble(
                          mine: message.mine,
                          sender: message.sender,
                          text: message.text,
                        ),
                  ],
                );
              },
            ),
          ),
          ChatInputBar(onSend: _sendMessage),
        ],
      ),
    );
  }
}

class MatchSummaryCard extends StatelessWidget {
  const MatchSummaryCard({
    required this.bundle,
    required this.onTap,
    super.key,
  });

  final MatchBundle bundle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BadgeLabel(text: bundle.statusLabel),
                const Spacer(),
                const Icon(Icons.chevron_right, color: _muted),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              bundle.requestTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              bundle.caregiverName,
              style: const TextStyle(
                color: _brand,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: bundle.progress,
                backgroundColor: _bg,
                color: _brand,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                MatchStateChip(
                  label: '요청자',
                  confirmed: bundle.match.requesterConfirmed,
                ),
                const SizedBox(width: 8),
                MatchStateChip(
                  label: '보호 가능자',
                  confirmed: bundle.match.caregiverConfirmed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MatchDetailPage extends StatefulWidget {
  const MatchDetailPage({required this.matchId, super.key});

  final String matchId;

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  late Future<MatchBundle?> _bundleFuture;

  @override
  void initState() {
    super.initState();
    _bundleFuture = _loadMatchBundle(widget.matchId);
  }

  Future<void> _confirmRequester(MatchBundle bundle) async {
    await _poomRepository.updateMatch(
      bundle.match.copyWith(requesterConfirmed: true),
    );
    _refresh();
  }

  Future<void> _confirmCaregiver(MatchBundle bundle) async {
    await _poomRepository.updateMatch(
      bundle.match.copyWith(caregiverConfirmed: true),
    );
    _refresh();
  }

  void _refresh() {
    setState(() {
      _bundleFuture = _loadMatchBundle(widget.matchId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          '매칭 상세',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w900),
        ),
      ),
      body: ResponsivePage(
        child: FutureBuilder<MatchBundle?>(
          future: _bundleFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: _brand),
              );
            }

            final bundle = snapshot.data;
            if (bundle == null) {
              return const EmptyState(
                icon: Icons.search_off_outlined,
                title: '매칭을 찾을 수 없어요',
                copy: '삭제되었거나 더 이상 진행 중이 아닌 매칭입니다.',
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              children: [
                PageTitle(
                  title: bundle.statusLabel,
                  subtitle: '서로 확인한 뒤에만 비공개 채팅이 열립니다.',
                ),
                MatchProgressCard(bundle: bundle),
                MatchInfoCard(
                  icon: Icons.edit_note_outlined,
                  title: '도움 요청',
                  headline: bundle.requestTitle,
                  meta: bundle.requestMeta,
                  body: bundle.request?.description ?? '요청 상세 정보를 확인할 수 없어요.',
                ),
                MatchInfoCard(
                  icon: Icons.volunteer_activism_outlined,
                  title: '보호 가능자',
                  headline: bundle.caregiverName,
                  meta: bundle.caregiverMeta,
                  body: bundle.caregiver?.detail ?? '보호 가능자 정보를 확인할 수 없어요.',
                ),
                if (!bundle.match.chatOpen)
                  MatchActionCard(
                    bundle: bundle,
                    onConfirmRequester: () => _confirmRequester(bundle),
                    onConfirmCaregiver: () => _confirmCaregiver(bundle),
                  )
                else
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ChatRoomPage(matchId: bundle.match.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('채팅방 열기'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _brand,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                const NoticeBox(
                  title: '민감한 정보는 채팅방에서만 다뤄요',
                  copy: '주소, 연락처, 인계 시간처럼 개인적인 내용은 상호 확정 후 필요한 범위에서만 공유합니다.',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MatchProgressCard extends StatelessWidget {
  const MatchProgressCard({required this.bundle, super.key});

  final MatchBundle bundle;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '진행 상태',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          MatchStepRow(
            label: '요청자 확정',
            done: bundle.match.requesterConfirmed,
          ),
          MatchStepRow(
            label: '보호 가능자 확정',
            done: bundle.match.caregiverConfirmed,
          ),
          MatchStepRow(
            label: '비공개 채팅 열림',
            done: bundle.match.chatOpen,
            last: true,
          ),
        ],
      ),
    );
  }
}

class MatchStepRow extends StatelessWidget {
  const MatchStepRow({
    required this.label,
    required this.done,
    this.last = false,
    super.key,
  });

  final String label;
  final bool done;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? _brand : _muted,
            ),
            if (!last)
              Container(
                width: 2,
                height: 24,
                color: done ? _brand : _line,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            label,
            style: TextStyle(
              color: done ? _ink : _muted,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class MatchInfoCard extends StatelessWidget {
  const MatchInfoCard({
    required this.icon,
    required this.title,
    required this.headline,
    required this.meta,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String headline;
  final String meta;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _softGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: _brand),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _brand,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  headline,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(meta, style: const TextStyle(color: _muted)),
                const SizedBox(height: 9),
                Text(body, style: const TextStyle(color: _muted, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatchActionCard extends StatelessWidget {
  const MatchActionCard({
    required this.bundle,
    required this.onConfirmRequester,
    required this.onConfirmCaregiver,
    super.key,
  });

  final MatchBundle bundle;
  final VoidCallback onConfirmRequester;
  final VoidCallback onConfirmCaregiver;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '다음 행동',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '아직 확정하지 않은 쪽이 선택하면 채팅방이 열립니다.',
            style: TextStyle(color: _muted),
          ),
          const SizedBox(height: 14),
          if (!bundle.match.requesterConfirmed)
            OutlinedButton.icon(
              onPressed: onConfirmRequester,
              icon: const Icon(Icons.person_outline),
              label: const Text('요청자 확정'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _brand,
                side: const BorderSide(color: _line),
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          if (!bundle.match.caregiverConfirmed) ...[
            if (!bundle.match.requesterConfirmed) const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: onConfirmCaregiver,
              icon: const Icon(Icons.volunteer_activism_outlined),
              label: const Text('보호 가능자 확정'),
              style: FilledButton.styleFrom(
                backgroundColor: _brand,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class MatchHistoryPage extends StatefulWidget {
  const MatchHistoryPage({super.key});

  @override
  State<MatchHistoryPage> createState() => _MatchHistoryPageState();
}

class _MatchHistoryPageState extends State<MatchHistoryPage> {
  late Future<List<MatchBundle>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = _loadMatchBundles();
  }

  Future<void> _confirmRequester(MatchBundle bundle) async {
    await _poomRepository.updateMatch(
      bundle.match.copyWith(requesterConfirmed: true),
    );
    _refresh();
  }

  Future<void> _confirmCaregiver(MatchBundle bundle) async {
    await _poomRepository.updateMatch(
      bundle.match.copyWith(caregiverConfirmed: true),
    );
    _refresh();
  }

  void _refresh() {
    setState(() {
      _matchesFuture = _loadMatchBundles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          '매칭 이력',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w900),
        ),
      ),
      body: ResponsivePage(
        child: FutureBuilder<List<MatchBundle>>(
          future: _matchesFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(color: _brand));
            }

            final matches = snapshot.data!;
            if (matches.isEmpty) {
              return const EmptyState(
                icon: Icons.handshake_outlined,
                title: '아직 매칭 이력이 없어요',
                copy: '등록을 마친 뒤 홈 피드에서 요청과 보호 가능자를 확인해 보세요.',
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              children: [
                const PageTitle(
                  title: '진행 중인 연결',
                  subtitle: '상호 확정 여부와 채팅 가능 상태를 확인합니다.',
                ),
                for (final bundle in matches)
                  AppCard(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                MatchDetailPage(matchId: bundle.match.id),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  bundle.requestTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: _muted),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            bundle.caregiverName,
                            style: const TextStyle(
                              color: _brand,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${bundle.match.requestId} · ${bundle.match.caregiverId}',
                            style: const TextStyle(color: _muted),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              MatchStateChip(
                                label: '요청자',
                                confirmed: bundle.match.requesterConfirmed,
                              ),
                              const SizedBox(width: 8),
                              MatchStateChip(
                                label: '보호 가능자',
                                confirmed: bundle.match.caregiverConfirmed,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            bundle.match.chatOpen ? '채팅 가능' : '상호 확정 대기',
                            style: const TextStyle(
                              color: _brand,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (!bundle.match.chatOpen) ...[
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (!bundle.match.requesterConfirmed)
                                  OutlinedButton.icon(
                                    onPressed: () => _confirmRequester(bundle),
                                    icon: const Icon(Icons.person_outline),
                                    label: const Text('요청자 확정'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: _brand,
                                      side: const BorderSide(color: _line),
                                    ),
                                  ),
                                if (!bundle.match.caregiverConfirmed)
                                  FilledButton.icon(
                                    onPressed: () => _confirmCaregiver(bundle),
                                    icon: const Icon(
                                        Icons.volunteer_activism_outlined),
                                    label: const Text('보호 가능자 확정'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: _brand,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MatchStateChip extends StatelessWidget {
  const MatchStateChip({
    required this.label,
    required this.confirmed,
    super.key,
  });

  final String label;
  final bool confirmed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: confirmed ? _softGreen : _notice,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: confirmed ? _line : const Color(0xFFFFDFAB)),
      ),
      child: Text(
        '$label ${confirmed ? '확정' : '대기'}',
        style: TextStyle(
          color: confirmed ? _brandDark : _ink,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class MatchBundle {
  const MatchBundle({
    required this.match,
    required this.request,
    required this.caregiver,
  });

  final MatchRecord match;
  final CareRequest? request;
  final CaregiverProfile? caregiver;

  String get requestTitle => request?.title ?? match.requestId;
  String get requestMeta => request?.meta ?? '요청 정보를 확인하는 중';
  String get caregiverName => caregiver?.name ?? match.caregiverId;
  String get caregiverMeta => caregiver?.meta ?? '보호 가능자 정보를 확인하는 중';
  String get statusLabel => match.chatOpen ? '채팅 가능' : '상호 확정 대기';
  double get progress {
    final done = [
      match.requesterConfirmed,
      match.caregiverConfirmed,
      match.chatOpen,
    ].where((value) => value).length;
    return done / 3;
  }
}

Future<List<MatchBundle>> _loadMatchBundles() async {
  final matches = await _poomRepository.readMatches();
  final requests = await _poomRepository.readCareRequests();
  final caregivers = await _poomRepository.readCaregivers();

  CareRequest? findRequest(String id) {
    for (final request in requests) {
      if (request.id == id) return request;
    }
    return null;
  }

  CaregiverProfile? findCaregiver(String id) {
    for (final caregiver in caregivers) {
      if (caregiver.id == id) return caregiver;
    }
    return null;
  }

  return [
    for (final match in matches)
      MatchBundle(
        match: match,
        request: findRequest(match.requestId),
        caregiver: findCaregiver(match.caregiverId),
      ),
  ];
}

Future<MatchBundle?> _loadMatchBundle(String matchId) async {
  final bundles = await _loadMatchBundles();
  for (final bundle in bundles) {
    if (bundle.match.id == matchId) return bundle;
  }
  return null;
}

class HandoffPage extends StatefulWidget {
  const HandoffPage({required this.chatOpen, super.key});

  final bool chatOpen;

  @override
  State<HandoffPage> createState() => _HandoffPageState();
}

class _HandoffPageState extends State<HandoffPage> {
  late Future<_HandoffOverview> _overviewFuture;

  @override
  void initState() {
    super.initState();
    _overviewFuture = _loadOverview();
  }

  Future<_HandoffOverview> _loadOverview() async {
    final tasks = await _poomRepository.fetchHandoffTasks();
    final matches = await _poomRepository.readMatches();
    return _HandoffOverview(
      tasks: tasks,
      hasOpenMatch: widget.chatOpen || matches.any((match) => match.chatOpen),
    );
  }

  Future<void> _toggleTask(HandoffTask task) async {
    await _poomRepository.updateHandoffTask(task.copyWith(done: !task.done));
    setState(() {
      _overviewFuture = _loadOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        const PageTitle(
          title: '인계 준비',
          subtitle: '빠뜨리면 안 되는 것만 간단히 확인해요.',
        ),
        FutureBuilder<_HandoffOverview>(
          future: _overviewFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const AppCard(
                child: SizedBox(
                  height: 82,
                  child: Center(
                    child: CircularProgressIndicator(color: _brand),
                  ),
                ),
              );
            }

            final overview = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NoticeBox(
                  title: overview.hasOpenMatch
                      ? '인계 정보를 정리 중이에요'
                      : '매칭 확정 후 시작할 수 있어요',
                  copy: overview.hasOpenMatch
                      ? '채팅 내용과 체크리스트를 바탕으로 필요한 정보를 정리합니다.'
                      : '먼저 1대1 매칭을 확정해 주세요.',
                  success: overview.hasOpenMatch,
                ),
                _HandoffProgressCard(overview: overview),
                for (final task in overview.tasks)
                  ChecklistCard(
                    title: task.title,
                    done: task.done,
                    onTap: () => _toggleTask(task),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _HandoffOverview {
  const _HandoffOverview({
    required this.tasks,
    required this.hasOpenMatch,
  });

  final List<HandoffTask> tasks;
  final bool hasOpenMatch;

  int get doneCount => tasks.where((task) => task.done).length;
  int get totalCount => tasks.length;
  double get progress => totalCount == 0 ? 0 : doneCount / totalCount;
}

class _HandoffProgressCard extends StatelessWidget {
  const _HandoffProgressCard({required this.overview});

  final _HandoffOverview overview;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '준비율',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '${overview.doneCount}/${overview.totalCount}',
                style: const TextStyle(
                  color: _brand,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: overview.progress,
              backgroundColor: _bg,
              color: _brand,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            overview.progress >= 1
                ? '필수 인계 항목이 모두 준비됐어요.'
                : '남은 항목을 하나씩 확인하면 인계가 더 안정적입니다.',
            style: const TextStyle(color: _muted),
          ),
        ],
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({
    required this.size,
    required this.radius,
    required this.fontSize,
    super.key,
  });

  final double size;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _brand,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        '품',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class NotificationCenterPage extends StatelessWidget {
  const NotificationCenterPage({
    required this.chatOpen,
    required this.matchNotifications,
    required this.chatNotifications,
    super.key,
  });

  final bool chatOpen;
  final bool matchNotifications;
  final bool chatNotifications;

  Future<List<_NotificationItem>> _loadItems() async {
    final matches = await _poomRepository.readMatches();
    final tasks = await _poomRepository.readHandoffTasks();
    final favorites = await LocalAppStore.readFavorites();
    final items = <_NotificationItem>[];

    if (favorites.isNotEmpty) {
      items.add(
        _NotificationItem(
          icon: Icons.bookmark_border,
          title: '관심 목록 ${favorites.length}개',
          copy: '홈 피드에서 표시한 관심 항목을 이어서 확인할 수 있어요.',
          tone: _softGreen,
        ),
      );
    }

    if (matchNotifications) {
      for (final match in matches.take(4)) {
        items.add(
          _NotificationItem(
            icon: match.chatOpen
                ? Icons.mark_chat_unread_outlined
                : Icons.handshake_outlined,
            title: match.chatOpen ? '채팅방이 열렸어요' : '상호 확정 대기 중',
            copy: match.chatOpen
                ? '${match.id}에서 인계 대화를 시작할 수 있어요.'
                : '${match.requestId} · ${match.caregiverId} 매칭의 상대 확정을 기다리고 있어요.',
            tone: match.chatOpen ? _softGreen : _notice,
          ),
        );
      }
    }

    if (chatNotifications && chatOpen) {
      items.add(
        const _NotificationItem(
          icon: Icons.chat_bubble_outline,
          title: '비공개 채팅 사용 가능',
          copy: '열린 채팅방에서 일정과 인계 정보를 조율해 주세요.',
          tone: _softGreen,
        ),
      );
    }

    final remainingTasks = tasks.where((task) => !task.done).length;
    if (remainingTasks > 0) {
      items.add(
        _NotificationItem(
          icon: Icons.fact_check_outlined,
          title: '인계 체크 $remainingTasks개 남음',
          copy: '빠뜨리기 쉬운 항목을 인계 화면에서 확인할 수 있어요.',
          tone: _softGreen,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          '알림함',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w900),
        ),
      ),
      body: ResponsivePage(
        child: FutureBuilder<List<_NotificationItem>>(
          future: _loadItems(),
          builder: (context, snapshot) {
            final items = snapshot.data ?? const <_NotificationItem>[];

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              children: [
                const PageTitle(
                  title: '지금 확인할 일',
                  subtitle: '매칭, 채팅, 인계 준비 상태를 모아 보여줍니다.',
                ),
                if (!snapshot.hasData)
                  const AppCard(
                    child: SizedBox(
                      height: 86,
                      child: Center(
                          child: CircularProgressIndicator(color: _brand)),
                    ),
                  )
                else if (items.isEmpty)
                  const EmptyResultCard(
                    title: '새 알림이 없어요',
                    copy: '매칭을 만들거나 관심 항목을 표시하면 이곳에서 다시 볼 수 있어요.',
                  )
                else
                  for (final item in items) _NotificationTile(item: item),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.copy,
    required this.tone,
  });

  final IconData icon;
  final String title;
  final String copy;
  final Color tone;
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.tone,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: _brand),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.copy,
                  style: const TextStyle(color: _muted, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivitySummaryCard extends StatelessWidget {
  const ActivitySummaryCard({super.key});

  Future<_ActivitySummary> _loadSummary() async {
    final favorites = await LocalAppStore.readFavorites();
    final matches = await _poomRepository.readMatches();
    final tasks = await _poomRepository.readHandoffTasks();

    return _ActivitySummary(
      favorites: favorites.length,
      matches: matches.length,
      openChats: matches.where((match) => match.chatOpen).length,
      remainingTasks: tasks.where((task) => !task.done).length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ActivitySummary>(
      future: _loadSummary(),
      builder: (context, snapshot) {
        final summary = snapshot.data;

        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '내 활동',
                style: TextStyle(
                  color: _ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              if (!snapshot.hasData)
                const SizedBox(
                  height: 54,
                  child:
                      Center(child: CircularProgressIndicator(color: _brand)),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 420;
                    final tiles = [
                      ActivityMetricTile(
                        label: '관심',
                        value: '${summary!.favorites}',
                        icon: Icons.bookmark_border,
                      ),
                      ActivityMetricTile(
                        label: '매칭',
                        value: '${summary.matches}',
                        icon: Icons.handshake_outlined,
                      ),
                      ActivityMetricTile(
                        label: '채팅',
                        value: '${summary.openChats}',
                        icon: Icons.chat_bubble_outline,
                      ),
                      ActivityMetricTile(
                        label: '체크',
                        value: '${summary.remainingTasks}',
                        icon: Icons.fact_check_outlined,
                      ),
                    ];

                    if (compact) {
                      return Column(
                        children: [
                          Row(children: tiles.take(2).toList()),
                          const SizedBox(height: 8),
                          Row(children: tiles.skip(2).toList()),
                        ],
                      );
                    }

                    return Row(children: tiles);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivitySummary {
  const _ActivitySummary({
    required this.favorites,
    required this.matches,
    required this.openChats,
    required this.remainingTasks,
  });

  final int favorites;
  final int matches;
  final int openChats;
  final int remainingTasks;
}

class ActivityMetricTile extends StatelessWidget {
  const ActivityMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
        ),
        child: Column(
          children: [
            Icon(icon, color: _brand, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: _ink,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    required this.role,
    required this.matchNotifications,
    required this.chatNotifications,
    required this.onRoleChanged,
    required this.onMatchNotificationsChanged,
    required this.onChatNotificationsChanged,
    super.key,
  });

  final AppRole role;
  final bool matchNotifications;
  final bool chatNotifications;
  final ValueChanged<AppRole> onRoleChanged;
  final ValueChanged<bool> onMatchNotificationsChanged;
  final ValueChanged<bool> onChatNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          '역할과 알림',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w900),
        ),
      ),
      body: ResponsivePage(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            const PageTitle(
              title: '내 사용 방식',
              subtitle: '역할에 따라 앱에서 강조되는 기능이 달라집니다.',
            ),
            const ActivitySummaryCard(),
            AppCard(
              child: Column(
                children: [
                  for (final nextRole in AppRole.values)
                    RoleOptionTile(
                      role: nextRole,
                      selected: role == nextRole,
                      onTap: () => onRoleChanged(nextRole),
                    ),
                ],
              ),
            ),
            const SectionHeader(title: '알림', action: '앱 내 설정'),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile(
                    value: matchNotifications,
                    activeThumbColor: _brand,
                    onChanged: onMatchNotificationsChanged,
                    title: const Text(
                      '매칭 진행 알림',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: const Text('상대가 매칭을 확정하면 알려줍니다.'),
                  ),
                  const Divider(color: _line),
                  SwitchListTile(
                    value: chatNotifications,
                    activeThumbColor: _brand,
                    onChanged: onChatNotificationsChanged,
                    title: const Text(
                      '채팅 메시지 알림',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: const Text('열린 채팅방의 새 메시지를 알려줍니다.'),
                  ),
                ],
              ),
            ),
            const NoticeBox(
              title: '현재는 앱 안에서만 저장됩니다',
              copy: '실제 서비스에서는 계정과 기기에 연결해 설정을 저장할 수 있습니다.',
            ),
          ],
        ),
      ),
    );
  }
}

class RoleOptionTile extends StatelessWidget {
  const RoleOptionTile({
    required this.role,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final AppRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? _brand : _muted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.label,
                    style: const TextStyle(
                      color: _ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    role == AppRole.requester
                        ? '도움을 요청하고 매칭을 확정합니다.'
                        : '도움 요청을 확인하고 보호 가능 여부를 선택합니다.',
                    style: const TextStyle(color: _muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    required this.child,
    this.maxWidth = 760,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  constraints.maxWidth < 480 ? constraints.maxWidth : maxWidth,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class QuickStatusStrip extends StatelessWidget {
  const QuickStatusStrip({required this.stats, super.key});

  final DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final pills = [
          StatusPill(
            title: '상호 대기',
            value: '${stats.waitingMatches}',
          ),
          StatusPill(
            title: '매칭 검토',
            value: '${stats.reviewingMatches}',
          ),
          StatusPill(
            title: '인계 준비',
            value: '${stats.handoffsReady}',
          ),
        ];

        if (compact) {
          return Column(
            children: [
              for (final pill in pills) pill,
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < pills.length; i++) ...[
              Expanded(child: pills[i]),
              if (i != pills.length - 1) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
}

class SafetyOverviewCard extends StatelessWidget {
  const SafetyOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '품의 연결 기준',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          SafetyRuleRow(
            icon: Icons.visibility_off_outlined,
            title: '공개 정보 최소화',
            copy: '필요한 조건만 먼저 보여줍니다.',
          ),
          SafetyRuleRow(
            icon: Icons.handshake_outlined,
            title: '상호 선택 후 진행',
            copy: '한쪽 선택만으로 대화가 열리지 않습니다.',
          ),
          SafetyRuleRow(
            icon: Icons.fact_check_outlined,
            title: '인계 전 체크',
            copy: '일정과 준비물을 앱 안에서 확인합니다.',
            last: true,
          ),
        ],
      ),
    );
  }
}

class SafetyRuleRow extends StatelessWidget {
  const SafetyRuleRow({
    required this.icon,
    required this.title,
    required this.copy,
    this.last = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String copy;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _softGreen,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _brand, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(copy, style: const TextStyle(color: _muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.title, required this.value, super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, required this.action, super.key});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Text(
            action,
            style: const TextStyle(
              color: _brand,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class RequestFeedCard extends StatelessWidget {
  const RequestFeedCard({
    this.id,
    required this.tag,
    required this.title,
    required this.meta,
    required this.description,
    required this.progress,
    this.favorite = false,
    this.onFavorite,
    this.onTap,
    super.key,
  });

  final String? id;
  final String tag;
  final String title;
  final String meta;
  final String description;
  final double progress;
  final bool favorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BadgeLabel(text: tag),
                const Spacer(),
                if (onFavorite != null)
                  IconButton(
                    tooltip: favorite ? '관심 해제' : '관심 표시',
                    onPressed: onFavorite,
                    icon: Icon(
                      favorite ? Icons.bookmark : Icons.bookmark_border,
                      color: favorite ? _brand : _muted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              meta,
              style: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(color: _muted)),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: _bg,
                color: _brand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaregiverFeedCard extends StatelessWidget {
  const CaregiverFeedCard({
    this.id,
    required this.name,
    required this.meta,
    required this.detail,
    required this.match,
    this.favorite = false,
    this.onFavorite,
    this.onTap,
    super.key,
  });

  final String? id;
  final String name;
  final String meta;
  final String detail;
  final String match;
  final bool favorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;

            final icon = Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _softGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.volunteer_activism_outlined,
                color: _brand,
              ),
            );

            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                Text(detail, style: const TextStyle(color: _muted)),
              ],
            );

            final score = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  match,
                  style: const TextStyle(
                    color: _brand,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (onFavorite != null)
                  IconButton(
                    tooltip: favorite ? '관심 해제' : '관심 표시',
                    onPressed: onFavorite,
                    icon: Icon(
                      favorite ? Icons.bookmark : Icons.bookmark_border,
                      color: favorite ? _brand : _muted,
                    ),
                  ),
              ],
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      icon,
                      const Spacer(),
                      score,
                    ],
                  ),
                  const SizedBox(height: 12),
                  content,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 14),
                Expanded(child: content),
                const SizedBox(width: 10),
                score,
              ],
            );
          },
        ),
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  const PageTitle({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: const TextStyle(color: _muted, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class SimpleField extends StatelessWidget {
  const SimpleField({
    required this.label,
    required this.value,
    this.tall = false,
    super.key,
  });

  final String label;
  final String value;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: tall ? 76 : 42),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: _ink,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmCard extends StatelessWidget {
  const ConfirmCard({
    required this.label,
    required this.name,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String name;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: _brand,
        contentPadding: EdgeInsets.zero,
        title: Text(
          '$label · $name',
          style: const TextStyle(
            color: _ink,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Text(
          value ? '매칭 의사를 확정했어요' : '아직 확정하지 않았어요',
          style: const TextStyle(color: _muted),
        ),
      ),
    );
  }
}

class NoticeBox extends StatelessWidget {
  const NoticeBox({
    required this.title,
    required this.copy,
    this.success = true,
    super.key,
  });

  final String title;
  final String copy;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: success ? _softGreen : _notice,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: success ? _line : const Color(0xFFFFDFAB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(copy, style: const TextStyle(color: _muted)),
        ],
      ),
    );
  }
}

class LockedState extends StatelessWidget {
  const LockedState({required this.title, required this.copy, super.key});

  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: AppCard(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _softGreen,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.lock_outline, color: _brand, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                copy,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.copy,
    super.key,
  });

  final IconData icon;
  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _softGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: _brand, size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                copy,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.mine,
    required this.sender,
    required this.text,
    super.key,
  });

  final bool mine;
  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: mine ? _softGreen : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: mine ? _brand : _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(text, style: const TextStyle(color: _ink)),
          ],
        ),
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  ChatInputBar({required this.onSend, super.key});

  final ValueChanged<String> onSend;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) {
                onSend(value);
                _controller.clear();
              },
              decoration: InputDecoration(
                hintText: '인계 시간이나 정보를 입력해 주세요',
                filled: true,
                fillColor: _bg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () {
              onSend(_controller.text);
              _controller.clear();
            },
            style: IconButton.styleFrom(backgroundColor: _brand),
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChecklistCard extends StatelessWidget {
  const ChecklistCard({
    required this.title,
    required this.done,
    this.onTap,
    super.key,
  });

  final String title;
  final bool done;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? _brand : _muted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (onTap != null)
              const Icon(Icons.touch_app_outlined, color: _muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class BadgeLabel extends StatelessWidget {
  const BadgeLabel({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _softGreen,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: _brandDark,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class DetailSheet extends StatelessWidget {
  const DetailSheet({
    required this.title,
    required this.subtitle,
    required this.rows,
    this.primaryLabel,
    this.onPrimary,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<DetailRow> rows;
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 6, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: _muted)),
            const SizedBox(height: 18),
            for (final row in rows) row,
            const SizedBox(height: 10),
            if (onPrimary != null && primaryLabel != null) ...[
              FilledButton(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(
                  backgroundColor: _brand,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(primaryLabel!),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: _ink, height: 1.35)),
        ],
      ),
    );
  }
}

class MatchChoiceSheet<T> extends StatelessWidget {
  const MatchChoiceSheet({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.itemBuilder,
    super.key,
  });

  final String title;
  final String subtitle;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.78,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: _muted)),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return itemBuilder(context, items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchChoiceTile extends StatelessWidget {
  const MatchChoiceTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.body,
    required this.verified,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String trailing;
  final String body;
  final bool verified;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _softGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  verified
                      ? Icons.verified_user_outlined
                      : Icons.schedule_outlined,
                  color: _brand,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        BadgeLabel(text: trailing),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: _muted, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CrudSection {
  requests('도움 요청'),
  caregivers('보호 가능자'),
  matches('매칭'),
  messages('채팅 메시지'),
  handoffs('인계 체크리스트'),
  stats('대시보드 숫자');

  const CrudSection(this.label);

  final String label;
}

class CrudConsolePage extends StatefulWidget {
  const CrudConsolePage({super.key});

  @override
  State<CrudConsolePage> createState() => _CrudConsolePageState();
}

class _CrudConsolePageState extends State<CrudConsolePage> {
  CrudSection _section = CrudSection.requests;
  String _adminQuery = '';
  int _version = 0;
  final _pageScrollController = ScrollController();
  final _sectionScrollController = ScrollController();

  void _reload() => setState(() => _version++);

  String _newId(String prefix) =>
      '$prefix-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void dispose() {
    _pageScrollController.dispose();
    _sectionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          '데이터 관리',
          style: TextStyle(color: _ink, fontWeight: FontWeight.w900),
        ),
      ),
      body: ResponsivePage(
        maxWidth: 1100,
        child: Scrollbar(
          controller: _pageScrollController,
          thumbVisibility: true,
          child: ListView(
            controller: _pageScrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              const Text(
                '앱에서 사용하는 데이터를 직접 추가, 수정, 삭제합니다.',
                style: TextStyle(color: _muted, fontSize: 15),
              ),
              const SizedBox(height: 14),
              FeedSearchBar(
                onChanged: (value) => setState(() => _adminQuery = value),
              ),
              const SizedBox(height: 14),
              Scrollbar(
                controller: _sectionScrollController,
                thumbVisibility: true,
                notificationPredicate: (notification) =>
                    notification.depth == 1,
                child: SingleChildScrollView(
                  controller: _sectionScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      for (final section in CrudSection.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(section.label),
                            selected: _section == section,
                            selectedColor: _softGreen,
                            checkmarkColor: _brand,
                            onSelected: (_) =>
                                setState(() => _section = section),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              KeyedSubtree(
                key: ValueKey('$_section-$_version'),
                child: _buildSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection() {
    switch (_section) {
      case CrudSection.requests:
        return _RequestCrudPanel(
          query: _adminQuery,
          newId: _newId,
          onChanged: _reload,
        );
      case CrudSection.caregivers:
        return _CaregiverCrudPanel(
          query: _adminQuery,
          newId: _newId,
          onChanged: _reload,
        );
      case CrudSection.matches:
        return _MatchCrudPanel(
          query: _adminQuery,
          newId: _newId,
          onChanged: _reload,
        );
      case CrudSection.messages:
        return _MessageCrudPanel(
          query: _adminQuery,
          newId: _newId,
          onChanged: _reload,
        );
      case CrudSection.handoffs:
        return _HandoffCrudPanel(
          query: _adminQuery,
          newId: _newId,
          onChanged: _reload,
        );
      case CrudSection.stats:
        return _StatsCrudPanel(onChanged: _reload);
    }
  }
}

class _CrudHeader extends StatelessWidget {
  const _CrudHeader({
    required this.title,
    required this.onAdd,
    this.onBulkDelete,
  });

  final String title;
  final VoidCallback onAdd;
  final VoidCallback? onBulkDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('추가'),
          style: FilledButton.styleFrom(backgroundColor: _brand),
        ),
        if (onBulkDelete != null) ...[
          const SizedBox(width: 8),
          IconButton.outlined(
            tooltip: '검색 결과 일괄 삭제',
            onPressed: onBulkDelete,
            icon: const Icon(Icons.delete_sweep_outlined),
            color: Colors.redAccent,
          ),
        ],
      ],
    );
  }
}

class _CrudActions extends StatelessWidget {
  const _CrudActions({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('수정'),
        ),
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          label: const Text('삭제'),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
        ),
      ],
    );
  }
}

class _RequestCrudPanel extends StatelessWidget {
  const _RequestCrudPanel({
    required this.query,
    required this.newId,
    required this.onChanged,
  });

  final String query;
  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CareRequest>>(
      future: _poomRepository.readCareRequests(),
      builder: (context, snapshot) {
        final items = (snapshot.data ?? const <CareRequest>[])
            .where((item) => _matchesQuery(
                  query,
                  [item.id, item.title, item.meta, item.description, item.tag],
                ))
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '도움 요청',
              onAdd: () async {
                await _editRequest(context, null);
                onChanged();
              },
              onBulkDelete: items.isEmpty
                  ? null
                  : () async {
                      if (!await _confirmBulkDelete(context, items.length)) {
                        return;
                      }
                      for (final item in items) {
                        await _poomRepository.deleteCareRequest(item.id);
                      }
                      onChanged();
                    },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BadgeLabel(text: item.tag),
                    const SizedBox(height: 10),
                    Text(item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(item.meta, style: const TextStyle(color: _muted)),
                    const SizedBox(height: 8),
                    Text(item.description,
                        style: const TextStyle(color: _muted)),
                    _CrudActions(
                      onEdit: () async {
                        await _editRequest(context, item);
                        onChanged();
                      },
                      onDelete: () async {
                        await _poomRepository.deleteCareRequest(item.id);
                        onChanged();
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _editRequest(BuildContext context, CareRequest? item) async {
    final title = TextEditingController(text: item?.title ?? '');
    final animal = TextEditingController(text: item?.animal ?? '강아지');
    final location = TextEditingController(text: item?.location ?? '서울');
    final condition = TextEditingController(text: item?.condition ?? '임시 보호');
    final description = TextEditingController(text: item?.description ?? '');
    final tag = TextEditingController(text: item?.tag ?? '신규');

    final saved = await _showCrudDialog(
      context,
      title: item == null ? '도움 요청 추가' : '도움 요청 수정',
      fields: [
        _CrudTextField(label: '제목', controller: title),
        _CrudTextField(label: '동물', controller: animal),
        _CrudTextField(label: '지역', controller: location),
        _CrudTextField(label: '조건', controller: condition),
        _CrudTextField(label: '태그', controller: tag),
        _CrudTextField(label: '설명', controller: description, maxLines: 3),
      ],
    );
    if (!saved) return;

    final next = CareRequest(
      id: item?.id ?? newId('request'),
      tag: tag.text,
      title: title.text,
      animal: animal.text,
      location: location.text,
      condition: condition.text,
      description: description.text,
      progress: item?.progress ?? 0.2,
      createdAt: item?.createdAt ?? DateTime.now(),
    );

    if (item == null) {
      await _poomRepository.createCareRequest(next);
    } else {
      await _poomRepository.updateCareRequest(next);
    }
  }
}

class _CaregiverCrudPanel extends StatelessWidget {
  const _CaregiverCrudPanel({
    required this.query,
    required this.newId,
    required this.onChanged,
  });

  final String query;
  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CaregiverProfile>>(
      future: _poomRepository.readCaregivers(),
      builder: (context, snapshot) {
        final items = (snapshot.data ?? const <CaregiverProfile>[])
            .where((item) => _matchesQuery(
                  query,
                  [item.id, item.name, item.meta, item.detail, item.matchLabel],
                ))
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '보호 가능자',
              onAdd: () async {
                await _editCaregiver(context, null);
                onChanged();
              },
              onBulkDelete: items.isEmpty
                  ? null
                  : () async {
                      if (!await _confirmBulkDelete(context, items.length)) {
                        return;
                      }
                      for (final item in items) {
                        await _poomRepository.deleteCaregiver(item.id);
                      }
                      onChanged();
                    },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.name} · ${item.matchLabel}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(item.meta, style: const TextStyle(color: _muted)),
                    const SizedBox(height: 8),
                    Text(item.detail, style: const TextStyle(color: _muted)),
                    _CrudActions(
                      onEdit: () async {
                        await _editCaregiver(context, item);
                        onChanged();
                      },
                      onDelete: () async {
                        await _poomRepository.deleteCaregiver(item.id);
                        onChanged();
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _editCaregiver(
      BuildContext context, CaregiverProfile? item) async {
    final name = TextEditingController(text: item?.name ?? '');
    final location = TextEditingController(text: item?.location ?? '서울');
    final availableCare =
        TextEditingController(text: item?.availableCare ?? '임시 보호');
    final detail = TextEditingController(text: item?.detail ?? '');
    final matchScore = TextEditingController(text: '${item?.matchScore ?? 80}');

    final saved = await _showCrudDialog(
      context,
      title: item == null ? '보호 가능자 추가' : '보호 가능자 수정',
      fields: [
        _CrudTextField(label: '이름', controller: name),
        _CrudTextField(label: '지역', controller: location),
        _CrudTextField(label: '가능한 보호', controller: availableCare),
        _CrudTextField(
            label: '적합도',
            controller: matchScore,
            keyboardType: TextInputType.number),
        _CrudTextField(label: '상세', controller: detail, maxLines: 3),
      ],
    );
    if (!saved) return;

    final next = CaregiverProfile(
      id: item?.id ?? newId('caregiver'),
      name: name.text,
      location: location.text,
      availableCare: availableCare.text,
      detail: detail.text,
      matchScore: int.tryParse(matchScore.text) ?? 80,
      verified: item?.verified ?? false,
    );

    if (item == null) {
      await _poomRepository.createCaregiver(next);
    } else {
      await _poomRepository.updateCaregiver(next);
    }
  }
}

class _MatchCrudPanel extends StatelessWidget {
  const _MatchCrudPanel({
    required this.query,
    required this.newId,
    required this.onChanged,
  });

  final String query;
  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchRecord>>(
      future: _poomRepository.readMatches(),
      builder: (context, snapshot) {
        final items = (snapshot.data ?? const <MatchRecord>[])
            .where((item) => _matchesQuery(
                  query,
                  [item.id, item.requestId, item.caregiverId],
                ))
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '매칭',
              onAdd: () async {
                await _editMatch(context, null);
                onChanged();
              },
              onBulkDelete: items.isEmpty
                  ? null
                  : () async {
                      if (!await _confirmBulkDelete(context, items.length)) {
                        return;
                      }
                      for (final item in items) {
                        await _poomRepository.deleteMatch(item.id);
                      }
                      onChanged();
                    },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.id,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('${item.requestId} ↔ ${item.caregiverId}',
                        style: const TextStyle(color: _muted)),
                    const SizedBox(height: 8),
                    Text(item.chatOpen ? '채팅 가능' : '상호 확정 대기',
                        style: const TextStyle(
                            color: _brand, fontWeight: FontWeight.w900)),
                    _CrudActions(
                      onEdit: () async {
                        await _editMatch(context, item);
                        onChanged();
                      },
                      onDelete: () async {
                        await _poomRepository.deleteMatch(item.id);
                        onChanged();
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _editMatch(BuildContext context, MatchRecord? item) async {
    final requestId =
        TextEditingController(text: item?.requestId ?? 'request-001');
    final caregiverId =
        TextEditingController(text: item?.caregiverId ?? 'caregiver-001');
    var requesterConfirmed = item?.requesterConfirmed ?? false;
    var caregiverConfirmed = item?.caregiverConfirmed ?? false;

    final saved = await _showCrudDialog(
      context,
      title: item == null ? '매칭 추가' : '매칭 수정',
      fields: [
        _CrudTextField(label: '요청 ID', controller: requestId),
        _CrudTextField(label: '보호 가능자 ID', controller: caregiverId),
        StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              children: [
                SwitchListTile(
                  value: requesterConfirmed,
                  onChanged: (value) =>
                      setDialogState(() => requesterConfirmed = value),
                  title: const Text('요청자 확정'),
                ),
                SwitchListTile(
                  value: caregiverConfirmed,
                  onChanged: (value) =>
                      setDialogState(() => caregiverConfirmed = value),
                  title: const Text('보호 가능자 확정'),
                ),
              ],
            );
          },
        ),
      ],
    );
    if (!saved) return;

    final next = MatchRecord(
      id: item?.id ?? newId('match'),
      requestId: requestId.text,
      caregiverId: caregiverId.text,
      requesterConfirmed: requesterConfirmed,
      caregiverConfirmed: caregiverConfirmed,
    );

    if (item == null) {
      await _poomRepository.createMatch(next);
    } else {
      await _poomRepository.updateMatch(next);
    }
  }
}

class _MessageCrudPanel extends StatelessWidget {
  const _MessageCrudPanel({
    required this.query,
    required this.newId,
    required this.onChanged,
  });

  final String query;
  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchRecord>>(
      future: _poomRepository.readMatches(),
      builder: (context, matchSnapshot) {
        final matchId = (matchSnapshot.data?.isNotEmpty ?? false)
            ? matchSnapshot.data!.first.id
            : 'match-001';

        return FutureBuilder<List<ChatMessageRecord>>(
          future: _poomRepository.readChatMessages(matchId),
          builder: (context, snapshot) {
            final items = (snapshot.data ?? const <ChatMessageRecord>[])
                .where((item) => _matchesQuery(
                      query,
                      [item.id, item.matchId, item.sender, item.text],
                    ))
                .toList(growable: false);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CrudHeader(
                  title: '채팅 메시지',
                  onAdd: () async {
                    await _editMessage(context, null, matchId);
                    onChanged();
                  },
                  onBulkDelete: items.isEmpty
                      ? null
                      : () async {
                          if (!await _confirmBulkDelete(
                              context, items.length)) {
                            return;
                          }
                          for (final item in items) {
                            await _poomRepository.deleteChatMessage(item.id);
                          }
                          onChanged();
                        },
                ),
                const SizedBox(height: 12),
                for (final item in items)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.sender} · ${item.matchId}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        Text(item.text, style: const TextStyle(color: _muted)),
                        _CrudActions(
                          onEdit: () async {
                            await _editMessage(context, item, matchId);
                            onChanged();
                          },
                          onDelete: () async {
                            await _poomRepository.deleteChatMessage(item.id);
                            onChanged();
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editMessage(BuildContext context, ChatMessageRecord? item,
      String fallbackMatchId) async {
    final matchId =
        TextEditingController(text: item?.matchId ?? fallbackMatchId);
    final sender = TextEditingController(text: item?.sender ?? '요청자');
    final text = TextEditingController(text: item?.text ?? '');
    var mine = item?.mine ?? true;

    final saved = await _showCrudDialog(
      context,
      title: item == null ? '메시지 추가' : '메시지 수정',
      fields: [
        _CrudTextField(label: '매칭 ID', controller: matchId),
        _CrudTextField(label: '보낸 사람', controller: sender),
        _CrudTextField(label: '내용', controller: text, maxLines: 3),
        StatefulBuilder(
          builder: (context, setDialogState) {
            return SwitchListTile(
              value: mine,
              onChanged: (value) => setDialogState(() => mine = value),
              title: const Text('내가 보낸 메시지'),
            );
          },
        ),
      ],
    );
    if (!saved) return;

    final next = ChatMessageRecord(
      id: item?.id ?? newId('message'),
      matchId: matchId.text,
      sender: sender.text,
      text: text.text,
      mine: mine,
    );

    if (item == null) {
      await _poomRepository.createChatMessage(next);
    } else {
      await _poomRepository.updateChatMessage(next);
    }
  }
}

class _HandoffCrudPanel extends StatelessWidget {
  const _HandoffCrudPanel({
    required this.query,
    required this.newId,
    required this.onChanged,
  });

  final String query;
  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HandoffTask>>(
      future: _poomRepository.readHandoffTasks(),
      builder: (context, snapshot) {
        final items = (snapshot.data ?? const <HandoffTask>[])
            .where((item) => _matchesQuery(query, [item.id, item.title]))
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '인계 체크리스트',
              onAdd: () async {
                await _editTask(context, null);
                onChanged();
              },
              onBulkDelete: items.isEmpty
                  ? null
                  : () async {
                      if (!await _confirmBulkDelete(context, items.length)) {
                        return;
                      }
                      for (final item in items) {
                        await _poomRepository.deleteHandoffTask(item.id);
                      }
                      onChanged();
                    },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Row(
                  children: [
                    Icon(
                        item.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: item.done ? _brand : _muted),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(item.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w900))),
                    IconButton(
                      onPressed: () async {
                        await _editTask(context, item);
                        onChanged();
                      },
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _poomRepository.deleteHandoffTask(item.id);
                        onChanged();
                      },
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _editTask(BuildContext context, HandoffTask? item) async {
    final title = TextEditingController(text: item?.title ?? '');
    var done = item?.done ?? false;

    final saved = await _showCrudDialog(
      context,
      title: item == null ? '체크리스트 추가' : '체크리스트 수정',
      fields: [
        _CrudTextField(label: '제목', controller: title),
        StatefulBuilder(
          builder: (context, setDialogState) {
            return SwitchListTile(
              value: done,
              onChanged: (value) => setDialogState(() => done = value),
              title: const Text('완료됨'),
            );
          },
        ),
      ],
    );
    if (!saved) return;

    final next = HandoffTask(
      id: item?.id ?? newId('handoff'),
      title: title.text,
      done: done,
    );

    if (item == null) {
      await _poomRepository.createHandoffTask(next);
    } else {
      await _poomRepository.updateHandoffTask(next);
    }
  }
}

class _StatsCrudPanel extends StatefulWidget {
  const _StatsCrudPanel({required this.onChanged});

  final VoidCallback onChanged;

  @override
  State<_StatsCrudPanel> createState() => _StatsCrudPanelState();
}

class _StatsCrudPanelState extends State<_StatsCrudPanel> {
  final _waiting = TextEditingController();
  final _reviewing = TextEditingController();
  final _handoffs = TextEditingController();

  @override
  void dispose() {
    _waiting.dispose();
    _reviewing.dispose();
    _handoffs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DashboardStats>(
      future: _poomRepository.readDashboardStats(),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        if (stats != null && _waiting.text.isEmpty) {
          _waiting.text = '${stats.waitingMatches}';
          _reviewing.text = '${stats.reviewingMatches}';
          _handoffs.text = '${stats.handoffsReady}';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('대시보드 숫자',
                style: TextStyle(
                    color: _ink, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _CrudTextField(
                      label: '상호 대기',
                      controller: _waiting,
                      keyboardType: TextInputType.number),
                  _CrudTextField(
                      label: '매칭 검토',
                      controller: _reviewing,
                      keyboardType: TextInputType.number),
                  _CrudTextField(
                      label: '인계 준비',
                      controller: _handoffs,
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            await _poomRepository.updateDashboardStats(
                              DashboardStats(
                                waitingMatches:
                                    int.tryParse(_waiting.text) ?? 0,
                                reviewingMatches:
                                    int.tryParse(_reviewing.text) ?? 0,
                                handoffsReady:
                                    int.tryParse(_handoffs.text) ?? 0,
                              ),
                            );
                            widget.onChanged();
                          },
                          style:
                              FilledButton.styleFrom(backgroundColor: _brand),
                          child: const Text('저장'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await _poomRepository.deleteDashboardStats();
                            _waiting.clear();
                            _reviewing.clear();
                            _handoffs.clear();
                            widget.onChanged();
                          },
                          child: const Text('초기화'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CrudTextField extends StatelessWidget {
  const _CrudTextField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: _bg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

bool _matchesQuery(String query, List<String> values) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return true;

  return values.any((value) => value.toLowerCase().contains(normalized));
}

Future<bool> _confirmBulkDelete(BuildContext context, int count) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('검색 결과 삭제'),
        content: Text('현재 보이는 $count개 항목을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('삭제'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

Future<bool> _showCrudDialog(
  BuildContext context, {
  required String title,
  required List<Widget> fields,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: fields),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: _brand),
            child: const Text('저장'),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
