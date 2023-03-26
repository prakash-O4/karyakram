import 'package:intl/intl.dart';

extension FormattedDate on DateTime? 
{
  String toFormatDate() {
    if(this == null) return "";
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(this!);
  }

  String getTimeFromTime()
  {
    if(this == null) return "";
    DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(this!);
  }
}