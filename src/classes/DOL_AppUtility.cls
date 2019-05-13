public class DOL_AppUtility {

    public static String getDate(String inputformat){
        Datetime dt = Datetime.now();
        return dt.format(inputformat);
    }
    
    public static String getString(List<String> strList){
       	String outputString;
        if(strList != null && strList.size() > 0){
            //strList.remove(null);
            outputString = String.join(strList,',');
        }
        return outputString;
    }
    
}