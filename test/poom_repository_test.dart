import 'package:flutter_test/flutter_test.dart';
import 'package:poom_app/data/poom_database.dart';

void main() {
  group('PoomRepository CRUD', () {
    late PoomRepository repository;

    setUp(() {
      repository = PoomRepository(PoomDatabase.seeded());
    });

    test('manages dashboard stats', () async {
      await repository.createDashboardStats(
        const DashboardStats(
          waitingMatches: 1,
          reviewingMatches: 2,
          handoffsReady: 3,
        ),
      );

      final created = await repository.readDashboardStats();
      expect(created.waitingMatches, 1);

      final updated = await repository.updateDashboardStats(
        created.copyWith(handoffsReady: 9),
      );
      expect(updated.handoffsReady, 9);

      await repository.deleteDashboardStats();
      final deleted = await repository.readDashboardStats();
      expect(deleted.waitingMatches, 0);
      expect(deleted.reviewingMatches, 0);
      expect(deleted.handoffsReady, 0);
    });

    test('manages care requests', () async {
      final request = CareRequest(
        id: 'request-test',
        tag: '신규',
        title: '테스트 요청',
        animal: '강아지',
        location: '서울 중구',
        condition: '단기',
        description: '테스트 설명',
        progress: 0.1,
        createdAt: DateTime(2026, 6, 17),
      );

      await repository.createCareRequest(request);
      expect((await repository.readCareRequest(request.id))?.title, '테스트 요청');

      await repository.updateCareRequest(request.copyWith(title: '수정된 요청'));
      expect((await repository.readCareRequest(request.id))?.title, '수정된 요청');

      await repository.deleteCareRequest(request.id);
      expect(await repository.readCareRequest(request.id), isNull);
    });

    test('manages caregivers', () async {
      const caregiver = CaregiverProfile(
        id: 'caregiver-test',
        name: '테스트 보호자',
        location: '서울 중구',
        availableCare: '단기 보호',
        detail: '테스트 상세',
        matchScore: 80,
        verified: false,
      );

      await repository.createCaregiver(caregiver);
      expect((await repository.readCaregiver(caregiver.id))?.name, '테스트 보호자');

      await repository.updateCaregiver(caregiver.copyWith(matchScore: 99));
      expect((await repository.readCaregiver(caregiver.id))?.matchScore, 99);

      await repository.deleteCaregiver(caregiver.id);
      expect(await repository.readCaregiver(caregiver.id), isNull);
    });

    test('manages matches and deletes related chat messages', () async {
      const match = MatchRecord(
        id: 'match-test',
        requestId: 'request-001',
        caregiverId: 'caregiver-001',
        requesterConfirmed: false,
        caregiverConfirmed: false,
      );
      const message = ChatMessageRecord(
        id: 'message-test',
        matchId: 'match-test',
        sender: '요청자',
        text: '안녕하세요',
        mine: true,
      );

      await repository.createMatch(match);
      await repository.createChatMessage(message);
      expect((await repository.readMatch(match.id))?.chatOpen, false);

      await repository.updateMatch(
        match.copyWith(requesterConfirmed: true, caregiverConfirmed: true),
      );
      expect((await repository.readMatch(match.id))?.chatOpen, true);

      await repository.deleteMatch(match.id);
      expect(await repository.readMatch(match.id), isNull);
      expect(await repository.readChatMessage(message.id), isNull);
    });

    test('manages chat messages', () async {
      const message = ChatMessageRecord(
        id: 'message-crud',
        matchId: 'match-001',
        sender: '보호 가능자',
        text: '처음 메시지',
        mine: false,
      );

      await repository.createChatMessage(message);
      expect((await repository.readChatMessage(message.id))?.text, '처음 메시지');

      await repository.updateChatMessage(message.copyWith(text: '수정 메시지'));
      expect((await repository.readChatMessage(message.id))?.text, '수정 메시지');

      await repository.deleteChatMessage(message.id);
      expect(await repository.readChatMessage(message.id), isNull);
    });

    test('manages handoff tasks', () async {
      const task = HandoffTask(
        id: 'handoff-test',
        title: '테스트 체크',
        done: false,
      );

      await repository.createHandoffTask(task);
      expect((await repository.readHandoffTask(task.id))?.title, '테스트 체크');

      await repository.updateHandoffTask(task.copyWith(done: true));
      expect((await repository.readHandoffTask(task.id))?.done, true);

      await repository.deleteHandoffTask(task.id);
      expect(await repository.readHandoffTask(task.id), isNull);
    });
  });
}
