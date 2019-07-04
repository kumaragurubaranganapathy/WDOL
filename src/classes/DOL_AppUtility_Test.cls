@isTest
public class DOL_AppUtility_Test {
	@isTest
    public static void test(){
        DOL_AppUtility.getDate('MM-DD-YYYY');
        List<String> strList = new List<String>();
        strList.add('test');
        DOL_AppUtility.getString(strList);
        DOL_AppUtility.getDate('20190610','YYYYMMDD');
        DOL_AppUtility.getDateString('20190610','YYYYMMDD');
        DOL_AppUtility.getDateTime('20190610 02:28:00','YYYYMMDD HH:mm:SS');
        DOL_AppUtility.getDateTimeString('20190610 02:28:00','YYYYMMDD HH:mm:SS');
        DOL_AppUtility.isValidDecimalValue('444444');
        DOL_AppUtility.isValidDecimalValue('ABCD');
        
        DOL_AppUtility.JournalWrapper wrapper = new DOL_AppUtility.JournalWrapper(null,null,null);
    }
}