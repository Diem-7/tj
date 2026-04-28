import 'trade.dart';

class TradeFilter {
  const TradeFilter({
    this.closedDateFrom,
    this.closedDateTo,
    this.accountId,
    this.instrumentId,
    this.session,
  });

  final DateTime? closedDateFrom;
  final DateTime? closedDateTo;
  final String? accountId;
  final String? instrumentId;
  final TradeSession? session;

  List<Trade> apply(List<Trade> trades) {
    return trades.where(includes).toList();
  }

  bool includes(Trade trade) {
    final closedAt = trade.closedAt;
    if (!trade.isClosed || closedAt == null) {
      return false;
    }
    if (!_matchesClosedFrom(closedAt)) {
      return false;
    }
    if (!_matchesClosedTo(closedAt)) {
      return false;
    }
    if (accountId != null && trade.accountId != accountId) {
      return false;
    }
    if (instrumentId != null && trade.instrumentId != instrumentId) {
      return false;
    }
    if (session != null && trade.session != session) {
      return false;
    }
    return true;
  }

  TradeFilter copyWith({
    DateTime? closedDateFrom,
    DateTime? closedDateTo,
    String? accountId,
    String? instrumentId,
    TradeSession? session,
    bool clearClosedDateFrom = false,
    bool clearClosedDateTo = false,
    bool clearAccountId = false,
    bool clearInstrumentId = false,
    bool clearSession = false,
  }) {
    return TradeFilter(
      closedDateFrom: clearClosedDateFrom
          ? null
          : closedDateFrom ?? this.closedDateFrom,
      closedDateTo: clearClosedDateTo
          ? null
          : closedDateTo ?? this.closedDateTo,
      accountId: clearAccountId ? null : accountId ?? this.accountId,
      instrumentId: clearInstrumentId
          ? null
          : instrumentId ?? this.instrumentId,
      session: clearSession ? null : session ?? this.session,
    );
  }

  bool _matchesClosedFrom(DateTime closedAt) {
    final from = closedDateFrom;
    if (from == null) {
      return true;
    }
    return !_dateOnly(closedAt).isBefore(_dateOnly(from));
  }

  bool _matchesClosedTo(DateTime closedAt) {
    final to = closedDateTo;
    if (to == null) {
      return true;
    }
    return !_dateOnly(closedAt).isAfter(_dateOnly(to));
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
