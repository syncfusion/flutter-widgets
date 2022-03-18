import '../asn1/asn1.dart';
import '../asn1/der.dart';

/// internal class
class X509Time extends Asn1Encode {
  /// internal constructor
  X509Time(Asn1 time) {
    _time = time;
  }
  Asn1? _time;

  /// internal method
  static X509Time? getTime(dynamic obj) {
    X509Time? result;
    if (obj == null || obj is X509Time) {
      result = obj as X509Time?;
    } else if (obj is DerUtcTime) {
      result = X509Time(obj);
    } else if (obj is GeneralizedTime) {
      result = X509Time(obj);
    } else {
      throw ArgumentError.value(obj, 'obj', 'Invalid entry');
    }
    return result;
  }

  /// internal method
  DateTime? toDateTime() {
    DateTime? result;
    try {
      if (_time is DerUtcTime) {
        result = (_time! as DerUtcTime).toAdjustedDateTime;
      } else if (_time is GeneralizedTime) {
        result = (_time! as GeneralizedTime).toDateTime();
      } else {
        result = DateTime.now();
      }
    } catch (e) {
      throw ArgumentError.value(result, 'DateTime', 'Invalid entry');
    }
    return result;
  }

  @override
  Asn1? getAsn1() {
    return _time;
  }

  @override
  String toString() {
    if (_time is DerUtcTime) {
      return (_time! as DerUtcTime).adjustedTimeString;
    } else if (_time is GeneralizedTime) {
      return (_time! as GeneralizedTime).time;
    } else {
      return '';
    }
  }
}
