import 'dart:async';

import 'package:flutter/material.dart';

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
                      child: const BrandMark(size: 78, radius: 18, fontSize: 32),
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

  bool get _chatOpen => _requesterConfirmed && _caregiverConfirmed;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onWriteRequest: () => setState(() => _index = 1)),
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
            tooltip: '데이터 관리',
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
          NavigationDestination(icon: Icon(Icons.edit_note_outlined), label: '요청'),
          NavigationDestination(icon: Icon(Icons.handshake_outlined), label: '매칭'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
          NavigationDestination(icon: Icon(Icons.fact_check_outlined), label: '인계'),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({required this.onWriteRequest, super.key});

  final VoidCallback onWriteRequest;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showRequests = true;
  late final Future<HomeFeed> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _poomRepository.fetchHomeFeed();
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
          onPressed: widget.onWriteRequest,
          style: FilledButton.styleFrom(
            backgroundColor: _brand,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            '도움 요청 작성하기',
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
                const SizedBox(height: 26),
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
                  for (final request in feed.requests)
                    RequestFeedCard(
                      tag: request.tag,
                      title: request.title,
                      meta: request.meta,
                      description: request.description,
                      progress: request.progress,
                    )
                else
                  for (final caregiver in feed.caregivers)
                    CaregiverFeedCard(
                      name: caregiver.name,
                      meta: caregiver.meta,
                      detail: caregiver.detail,
                      match: caregiver.matchLabel,
                    ),
              ],
            );
          },
        ),
      ],
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

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: const [
        PageTitle(
          title: '요청 작성',
          subtitle: '공개 목록에는 꼭 필요한 정보만 보여줍니다.',
        ),
        SimpleField(label: '동물 구분', value: '강아지'),
        SimpleField(label: '도움 유형', value: '임시 보호'),
        SimpleField(label: '지역', value: '서울 마포구'),
        SimpleField(label: '필요 기간', value: '2개월'),
        SimpleField(
          label: '꼭 필요한 조건',
          value: '매일 산책 가능, 병원 기록 확인, 기존 보호자와 사전 조건 확인',
          tall: true,
        ),
        NoticeBox(
          title: '민감한 정보는 바로 공개되지 않아요',
          copy: '상호 매칭이 확정된 뒤 앱 채팅에서 필요한 내용만 나눌 수 있어요.',
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
        const RequestFeedCard(
          tag: '선택됨',
          title: '모카 보호 요청',
          meta: '강아지 · 서울 마포구 · 임시 보호',
          description: '사료, 병원 기록, 생활 습관을 인계할 수 있어요.',
          progress: 0.72,
        ),
        const CaregiverFeedCard(
          name: '김하은',
          meta: '서울 은평구 · 소형견 임시 보호 가능',
          detail: '신원 확인, 거주 환경 확인, 돌봄 이력 완료',
          match: '98%',
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
    if (!chatOpen) {
      return const LockedState(
        title: '채팅은 아직 열리지 않았어요',
        copy: '요청자와 보호 가능자가 모두 확정하면 여기에서 대화할 수 있어요.',
      );
    }

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<ChatMessageRecord>>(
            future: _poomRepository.fetchChatMessages('match-001'),
            builder: (context, snapshot) {
              final messages = snapshot.data ?? const <ChatMessageRecord>[];

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                children: [
                  const PageTitle(title: '모카 · 김하은', subtitle: '비공개 1대1 채팅'),
                  if (!snapshot.hasData)
                    const AppCard(
                      child: SizedBox(
                        height: 82,
                        child: Center(
                          child: CircularProgressIndicator(color: _brand),
                        ),
                      ),
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
        const ChatInputBar(),
      ],
    );
  }
}

class HandoffPage extends StatelessWidget {
  const HandoffPage({required this.chatOpen, super.key});

  final bool chatOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        const PageTitle(
          title: '인계 준비',
          subtitle: '빠뜨리면 안 되는 것만 간단히 확인해요.',
        ),
        NoticeBox(
          title: chatOpen ? '인계 정보를 정리 중이에요' : '매칭 확정 후 시작할 수 있어요',
          copy: chatOpen
              ? '채팅 내용과 체크리스트를 바탕으로 필요한 정보를 정리합니다.'
              : '먼저 1대1 매칭을 확정해 주세요.',
          success: chatOpen,
        ),
        FutureBuilder<List<HandoffTask>>(
          future: _poomRepository.fetchHandoffTasks(),
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

            return Column(
              children: [
                for (final task in snapshot.data!)
                  ChecklistCard(title: task.title, done: task.done),
              ],
            );
          },
        ),
      ],
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
              maxWidth: constraints.maxWidth < 480 ? constraints.maxWidth : maxWidth,
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
    required this.tag,
    required this.title,
    required this.meta,
    required this.description,
    required this.progress,
    super.key,
  });

  final String tag;
  final String title;
  final String meta;
  final String description;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BadgeLabel(text: tag),
          const SizedBox(height: 12),
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
    );
  }
}

class CaregiverFeedCard extends StatelessWidget {
  const CaregiverFeedCard({
    required this.name,
    required this.meta,
    required this.detail,
    required this.match,
    super.key,
  });

  final String name;
  final String meta;
  final String detail;
  final String match;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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

          final score = Text(
            match,
            style: const TextStyle(
              color: _brand,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
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
  const ChatInputBar({super.key});

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
            onPressed: () {},
            style: IconButton.styleFrom(backgroundColor: _brand),
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class ChecklistCard extends StatelessWidget {
  const ChecklistCard({required this.title, required this.done, super.key});

  final String title;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
        ],
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
  int _version = 0;
  final _pageScrollController = ScrollController();
  final _sectionScrollController = ScrollController();

  void _reload() => setState(() => _version++);

  String _newId(String prefix) => '$prefix-${DateTime.now().millisecondsSinceEpoch}';

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
              Scrollbar(
                controller: _sectionScrollController,
                thumbVisibility: true,
                notificationPredicate: (notification) => notification.depth == 1,
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
                            onSelected: (_) => setState(() => _section = section),
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
        return _RequestCrudPanel(newId: _newId, onChanged: _reload);
      case CrudSection.caregivers:
        return _CaregiverCrudPanel(newId: _newId, onChanged: _reload);
      case CrudSection.matches:
        return _MatchCrudPanel(newId: _newId, onChanged: _reload);
      case CrudSection.messages:
        return _MessageCrudPanel(newId: _newId, onChanged: _reload);
      case CrudSection.handoffs:
        return _HandoffCrudPanel(newId: _newId, onChanged: _reload);
      case CrudSection.stats:
        return _StatsCrudPanel(onChanged: _reload);
    }
  }
}

class _CrudHeader extends StatelessWidget {
  const _CrudHeader({
    required this.title,
    required this.onAdd,
  });

  final String title;
  final VoidCallback onAdd;

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
  const _RequestCrudPanel({required this.newId, required this.onChanged});

  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CareRequest>>(
      future: _poomRepository.readCareRequests(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <CareRequest>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '도움 요청',
              onAdd: () async {
                await _editRequest(context, null);
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
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(item.meta, style: const TextStyle(color: _muted)),
                    const SizedBox(height: 8),
                    Text(item.description, style: const TextStyle(color: _muted)),
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
  const _CaregiverCrudPanel({required this.newId, required this.onChanged});

  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CaregiverProfile>>(
      future: _poomRepository.readCaregivers(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <CaregiverProfile>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '보호 가능자',
              onAdd: () async {
                await _editCaregiver(context, null);
                onChanged();
              },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.name} · ${item.matchLabel}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
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

  Future<void> _editCaregiver(BuildContext context, CaregiverProfile? item) async {
    final name = TextEditingController(text: item?.name ?? '');
    final location = TextEditingController(text: item?.location ?? '서울');
    final availableCare = TextEditingController(text: item?.availableCare ?? '임시 보호');
    final detail = TextEditingController(text: item?.detail ?? '');
    final matchScore = TextEditingController(text: '${item?.matchScore ?? 80}');

    final saved = await _showCrudDialog(
      context,
      title: item == null ? '보호 가능자 추가' : '보호 가능자 수정',
      fields: [
        _CrudTextField(label: '이름', controller: name),
        _CrudTextField(label: '지역', controller: location),
        _CrudTextField(label: '가능한 보호', controller: availableCare),
        _CrudTextField(label: '적합도', controller: matchScore, keyboardType: TextInputType.number),
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
  const _MatchCrudPanel({required this.newId, required this.onChanged});

  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchRecord>>(
      future: _poomRepository.readMatches(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <MatchRecord>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '매칭',
              onAdd: () async {
                await _editMatch(context, null);
                onChanged();
              },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('${item.requestId} ↔ ${item.caregiverId}', style: const TextStyle(color: _muted)),
                    const SizedBox(height: 8),
                    Text(item.chatOpen ? '채팅 가능' : '상호 확정 대기', style: const TextStyle(color: _brand, fontWeight: FontWeight.w900)),
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
    final requestId = TextEditingController(text: item?.requestId ?? 'request-001');
    final caregiverId = TextEditingController(text: item?.caregiverId ?? 'caregiver-001');
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
                  onChanged: (value) => setDialogState(() => requesterConfirmed = value),
                  title: const Text('요청자 확정'),
                ),
                SwitchListTile(
                  value: caregiverConfirmed,
                  onChanged: (value) => setDialogState(() => caregiverConfirmed = value),
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
  const _MessageCrudPanel({required this.newId, required this.onChanged});

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
            final items = snapshot.data ?? const <ChatMessageRecord>[];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CrudHeader(
                  title: '채팅 메시지',
                  onAdd: () async {
                    await _editMessage(context, null, matchId);
                    onChanged();
                  },
                ),
                const SizedBox(height: 12),
                for (final item in items)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${item.sender} · ${item.matchId}', style: const TextStyle(fontWeight: FontWeight.w900)),
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

  Future<void> _editMessage(BuildContext context, ChatMessageRecord? item, String fallbackMatchId) async {
    final matchId = TextEditingController(text: item?.matchId ?? fallbackMatchId);
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
  const _HandoffCrudPanel({required this.newId, required this.onChanged});

  final String Function(String prefix) newId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HandoffTask>>(
      future: _poomRepository.readHandoffTasks(),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <HandoffTask>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CrudHeader(
              title: '인계 체크리스트',
              onAdd: () async {
                await _editTask(context, null);
                onChanged();
              },
            ),
            const SizedBox(height: 12),
            for (final item in items)
              AppCard(
                child: Row(
                  children: [
                    Icon(item.done ? Icons.check_circle : Icons.radio_button_unchecked, color: item.done ? _brand : _muted),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w900))),
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
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
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
            const Text('대시보드 숫자', style: TextStyle(color: _ink, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  _CrudTextField(label: '상호 대기', controller: _waiting, keyboardType: TextInputType.number),
                  _CrudTextField(label: '매칭 검토', controller: _reviewing, keyboardType: TextInputType.number),
                  _CrudTextField(label: '인계 준비', controller: _handoffs, keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            await _poomRepository.updateDashboardStats(
                              DashboardStats(
                                waitingMatches: int.tryParse(_waiting.text) ?? 0,
                                reviewingMatches: int.tryParse(_reviewing.text) ?? 0,
                                handoffsReady: int.tryParse(_handoffs.text) ?? 0,
                              ),
                            );
                            widget.onChanged();
                          },
                          style: FilledButton.styleFrom(backgroundColor: _brand),
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
