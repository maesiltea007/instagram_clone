import 'package:instagram/models/dm_message.dart';

final List<DmMessage> dummyDmMessages = [
  // Thread t1
  DmMessage(
    messageId: 'm1',
    threadId: 't1',
    text: 'so cute!!',
    createdAt: DateTime.now().subtract(Duration(seconds: 10)),
    isMine: false,
  ),
  DmMessage(
    messageId: 'm2',
    threadId: 't1',
    text: 'Reply to haetbaaan…',
    createdAt: DateTime.now().subtract(Duration(seconds: 5)),
    isMine: true,
  ),

  // Thread t2
  DmMessage(
    messageId: 'm3',
    threadId: 't2',
    text: 'Perfect!',
    createdAt: DateTime.now().subtract(Duration(days: 14)),
    isMine: false,
  ),
  DmMessage(
    messageId: 'm4',
    threadId: 't2',
    text: 'Hi!!',
    createdAt: DateTime.now().subtract(Duration(days: 14, minutes: -3)),
    isMine: true,
  ),
];