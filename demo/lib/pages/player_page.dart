import 'package:flutter/material.dart';

import '../models/song.dart';
import '../widgets/song_card.dart';

// Màn hình trình phát nhạc: nơi duy nhất lưu giữ trạng thái.
class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  // ---- Trạng thái: dữ liệu thay đổi theo thao tác của người dùng ----
  bool _isPlaying = false;
  bool _isFavorite = false;
  int _volume = 5;
  String _lastEvent = 'Chưa có sự kiện nào';

  // ---- Hàm xử lý sự kiện: đổi trạng thái bên trong setState ----
  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      _lastEvent = 'onTap (InkWell) → ${_isPlaying ? "phát nhạc" : "tạm dừng"}';
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _lastEvent =
          'onDoubleTap (GestureDetector) → ${_isFavorite ? "thả tim" : "bỏ tim"}';
    });
  }

  void _changeVolume(int delta) {
    setState(() {
      _volume += delta;
      _lastEvent =
          'onPressed (IconButton ${delta > 0 ? "+" : "−"}) → âm lượng $_volume';
    });
  }

  void _addToPlaylist() {
    // Phản hồi bằng SnackBar, xóa thông báo cũ để không phải chờ
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm "${demoSong.title}" vào playlist')),
    );
    setState(() {
      _lastEvent = 'onPressed (ElevatedButton) → thêm vào playlist';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade100,
        title: const Text(
          'Trình phát nhạc mini',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thanh hiển thị sự kiện vừa nhận, dùng để minh họa khi demo
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.amber.shade100,
              child: Text(
                'Sự kiện vừa nhận:\n$_lastEvent',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Trạng thái đi xuống qua tham số, sự kiện đi lên qua callback
            SongCard(
              song: demoSong,
              isPlaying: _isPlaying,
              isFavorite: _isFavorite,
              volume: _volume,
              onTapCard: _togglePlay,
              onDoubleTapDisc: _toggleFavorite,
              onVolumeChanged: _changeVolume,
            ),
            const SizedBox(height: 8),
            const Text(
              'Chạm thẻ để phát hoặc tạm dừng. Nhấn đúp vào đĩa nhạc để thả tim.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),
            // Nút chỉ bấm được khi đang phát nhạc (onPressed: null -> nút mờ)
            ElevatedButton.icon(
              onPressed: _isPlaying ? _addToPlaylist : null,
              icon: const Icon(Icons.playlist_add),
              label: const Text('Thêm vào playlist'),
            ),
          ],
        ),
      ),
    );
  }
}
