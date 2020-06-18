public class Test_FormatDateTime{
    public DateTime dateTimeValue { get; set; }
    public String getTimeZoneValue() {
    String datetime_format = 'MMMM dd, yyyy  HH:mm a z';
        if( dateTimeValue != null ) {
            String localeFormatDT = dateTimeValue.format(datetime_format);
            return localeFormatDT;
        }
        return null;
    }
}