enum KdsSoundKind { phrase, tone }

class KdsSound {
  final String id;
  final String label;
  final KdsSoundKind kind;

  /// The spoken text when [kind] is [KdsSoundKind.phrase],
  /// or the asset path (under `assets/`) when [kind] is [KdsSoundKind.tone].
  final String value;

  const KdsSound.phrase(this.id, String text)
    : label = text,
      kind = KdsSoundKind.phrase,
      value = text;

  const KdsSound.tone(this.id, this.label, String asset)
    : kind = KdsSoundKind.tone,
      value = asset;
}

class KdsSounds {
  KdsSounds._();

  static const orderReceived = KdsSound.phrase('order_received', 'Order Received');
  static const received = KdsSound.phrase('received', 'Received');
  static const orderPaid = KdsSound.phrase('order_paid', 'Order Paid');
  static const paid = KdsSound.phrase('paid', 'Paid');
  static const orderCleared = KdsSound.phrase('order_cleared', 'Order Cleared');
  static const clear = KdsSound.phrase('clear', 'Clear');

  static const chime = KdsSound.tone('chime', 'Chime', 'sounds/order_alert.wav');
  static const bell = KdsSound.tone('bell', 'Bell', 'sounds/bell.wav');
  static const ding = KdsSound.tone('ding', 'Ding', 'sounds/ding.wav');
  static const doubleBeep = KdsSound.tone(
    'double_beep',
    'Double Beep',
    'sounds/beep_beep.wav',
  );

  /// Generic tones offered alongside the event-specific phrases in every picker.
  static const tones = [chime, bell, ding, doubleBeep];

  static const forOrderReceived = [orderReceived, received, ...tones];
  static const forOrderPaid = [orderPaid, paid, ...tones];
  static const forOrderCleared = [orderCleared, clear, ...tones];

  static const all = [
    orderReceived,
    received,
    orderPaid,
    paid,
    orderCleared,
    clear,
    ...tones,
  ];

  static KdsSound byId(String id) =>
      all.firstWhere((sound) => sound.id == id, orElse: () => orderReceived);
}
