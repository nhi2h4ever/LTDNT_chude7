import 'package:demo/main.dart';
import 'package:demo/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Kiểm tra PlayerPage: sự kiện -> setState -> giao diện cập nhật.
void main() {
  ElevatedButton playlistButton(WidgetTester tester) =>
      tester.widget<ElevatedButton>(find.byType(ElevatedButton));

  testWidgets('Trạng thái ban đầu: tạm dừng, nút playlist bị khóa', (
    tester,
  ) async {
    await tester.pumpWidget(const MusicPlayerApp());
    expect(find.text('Tạm dừng'), findsOneWidget);
    expect(find.textContaining('Chưa có sự kiện nào'), findsOneWidget);
    expect(playlistButton(tester).onPressed, isNull);
  });

  testWidgets('Chạm thẻ: phát nhạc, mở khóa nút, ghi sự kiện', (tester) async {
    await tester.pumpWidget(const MusicPlayerApp());
    await tester.tap(find.text(demoSong.title));
    await tester.pumpAndSettle();
    expect(find.text('Đang phát'), findsOneWidget);
    expect(find.textContaining('onTap (InkWell)'), findsOneWidget);
    expect(playlistButton(tester).onPressed, isNotNull);
  });

  testWidgets('Nút âm lượng cập nhật số và thanh sự kiện', (tester) async {
    await tester.pumpWidget(const MusicPlayerApp());
    await tester.tap(find.byIcon(Icons.volume_up));
    await tester.pump();
    expect(find.text('6'), findsOneWidget);
    expect(find.textContaining('âm lượng 6'), findsOneWidget);
  });

  testWidgets('Thêm vào playlist hiện SnackBar', (tester) async {
    await tester.pumpWidget(const MusicPlayerApp());
    await tester.tap(find.text(demoSong.title));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('thêm vào playlist'), findsOneWidget);
  });
}
