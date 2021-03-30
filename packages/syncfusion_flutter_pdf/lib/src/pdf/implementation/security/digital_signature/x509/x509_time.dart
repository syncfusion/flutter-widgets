part of pdf;

class _X509Time extends _Asn1Encode {
  _X509Time(_Asn1 time) {
    _time = time;
  }
  _Asn1? _time;
  static _X509Time? getTime(dynamic obj) {
    _X509Time? result;
    if (obj == null || obj is _X509Time) {
      result = obj;
    } else if (obj is _DerUtcTime) {
      result = _X509Time(obj);
    } else if (obj is _GeneralizedTime) {
      result = _X509Time(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  DateTime? toDateTime() {
    DateTime? result;
    try {
      if (_time is _DerUtcTime) {
        result = (_time as _DerUtcTime).toAdjustedDateTime;
      } else if (_time is _GeneralizedTime) {
        result = (_time as _GeneralizedTime).toDateTime();
      } else {
        result = DateTime.now();
      }
    } catch (e) {
      throw ArgumentError.value(result, 'DateTime', 'Invalid entry');
    }
    return result;
  }

  @override
  _Asn1? getAsn1() {
    return _time;
  }

  @override
  String toString() {
    if (_time is _DerUtcTime) {
      return (_time as _DerUtcTime).adjustedTimeString;
    } else if (_time is _GeneralizedTime) {
      return (_time as _GeneralizedTime)._time;
    } else {
      return '';
    }
  }
}
