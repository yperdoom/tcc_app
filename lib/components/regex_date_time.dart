String regexDateTime(var time) {
  if (time != null) {
    DateTime dateTime = DateTime.parse(time.toString());
    String formattedDateTime = '';

    String formattedTime = '${dateTime.hour}:${dateTime.minute}';
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    formattedDateTime = '$formattedDate às $formattedTime';

    return formattedDateTime;
  } else {
    return '06/05/2020 às 00:00:00';
  }
}
