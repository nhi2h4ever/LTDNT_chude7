import 'package:flutter/material.dart';

import '../models/song.dart';

// Thẻ bài hát: chỉ hiển thị dữ liệu nhận từ PlayerPage và báo sự kiện
// ngược lên qua callback. Widget này không giữ trạng thái.
class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.isFavorite,
    required this.volume,
    required this.onTapCard,
    required this.onDoubleTapDisc,
    required this.onVolumeChanged,
  });

  static const int minVolume = 0;
  static const int maxVolume = 10;

  // Dữ liệu đi xuống từ PlayerPage
  final Song song;
  final bool isPlaying;
  final bool isFavorite;
  final int volume;

  // Sự kiện đi lên PlayerPage
  final VoidCallback onTapCard;
  final VoidCallback onDoubleTapDisc;
  final ValueChanged<int> onVolumeChanged; // gửi +1 hoặc -1

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // giữ gợn sóng trong góc bo
      color: isPlaying ? Colors.deepPurple.shade50 : Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isPlaying ? Colors.deepPurple : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // (1) InkWell: chạm vào thẻ -> onTap, có hiệu ứng gợn sóng
          InkWell(
            onTap: onTapCard,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // (2) GestureDetector: nhấn đúp vào đĩa nhạc -> onDoubleTap,
                  // không có gợn sóng
                  GestureDetector(
                    onDoubleTap: onDoubleTapDisc,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: isPlaying
                          ? Colors.deepPurple.shade200
                          : Colors.grey.shade400,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.music_note,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(song.artist),
                        const SizedBox(height: 4),
                        Text(
                          isPlaying ? 'Đang phát' : 'Tạm dừng',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isPlaying ? Colors.deepPurple : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 36,
                    color: isPlaying ? Colors.deepPurple : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          // (3) IconButton: onPressed = null khi chạm mức 0 hoặc 10 -> nút tự mờ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Expanded(child: Text('Âm lượng')),
                IconButton(
                  onPressed: volume <= minVolume
                      ? null
                      : () => onVolumeChanged(-1),
                  icon: const Icon(Icons.volume_down),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '$volume',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: volume >= maxVolume
                      ? null
                      : () => onVolumeChanged(1),
                  icon: const Icon(Icons.volume_up),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
