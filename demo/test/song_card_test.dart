import 'package:demo/models/song.dart';
import 'package:demo/widgets/song_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Kiểm tra SongCard chỉ báo sự kiện qua callback, không tự đổi giao diện.
void main() {
  late int tapCount;
  late int doubleTapCount;
  late List<int> volumeDeltas;

  setUp(() {
    tapCount = 0;
    doubleTapCount = 0;
    volumeDeltas = [];
  });

  Future<void> pumpCard(WidgetTester tester, {int volume = 5}) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SongCard(
            song: demoSong,
            isPlaying: false,
            isFavorite: false,
            volume: volume,
            onTapCard: () => tapCount++,
            onDoubleTapDisc: () => doubleTapCount++,
            onVolumeChanged: volumeDeltas.add,
          ),
        ),
      ),
    );
  }

  testWidgets('Chạm thẻ gọi onTapCard', (tester) async {
    await pumpCard(tester);
    await tester.tap(find.text(demoSong.title));
    await tester.pumpAndSettle();
    expect(tapCount, 1);
  });

  testWidgets('Nhấn đúp đĩa nhạc gọi onDoubleTapDisc', (tester) async {
    await pumpCard(tester);
    final disc = find.byType(CircleAvatar);
    await tester.tap(disc);
    await tester.pump(kDoubleTapMinTime);
    await tester.tap(disc);
    await tester.pumpAndSettle();
    expect(doubleTapCount, 1);
    expect(tapCount, 0);
  });

  testWidgets('Nút âm lượng gửi +1 / -1 qua callback', (tester) async {
    await pumpCard(tester);
    await tester.tap(find.byIcon(Icons.volume_up));
    await tester.tap(find.byIcon(Icons.volume_down));
    expect(volumeDeltas, [1, -1]);
  });

  testWidgets('Âm lượng 0 thì nút giảm bị khóa (onPressed: null)', (
    tester,
  ) async {
    await pumpCard(tester, volume: SongCard.minVolume);
    final down = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.volume_down),
    );
    expect(down.onPressed, isNull);
  });
}
