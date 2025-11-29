import 'package:instagram/models/dm_thread.dart';

final List<DmThread> dummyDmThreads = [
  DmThread(
    threadId: 't1',
    peerUserId: '10', // haetbaaaan
    lastMessageText: 'so cute!!',
    lastMessageTime: DateTime.now().subtract(Duration(minutes: 3)),
    isSeen: false,
  ),
  DmThread(
    threadId: 't2',
    peerUserId: '11', // junhyuk
    lastMessageText: 'Perfect!',
    lastMessageTime: DateTime.now().subtract(Duration(days: 14)),
    isSeen: true,
  ),
];