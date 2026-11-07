// Dữ liệu cố định của bài hát: chỉ đọc, không thay đổi khi người dùng thao tác,
// vì vậy không đặt trong State.
class Song {
  const Song({required this.title, required this.artist});

  final String title;
  final String artist;
}

const Song demoSong = Song(title: 'Flutter Lofi Beat', artist: 'Nhóm 7');
