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
    
    //Do not delete this wrapper 
    //Added by Sumeet Kanjilal for processing flow of Journal 
    //Wrapper scenario in Finance Application related US- 
    public class JournalWrapper
    {
        public BGBK__Item__c objItemsData {get;set;}
        public Decimal iTotalAmount {get;set;}
        
        public JournalWrapper(BGBK__Item__c objItemsData, Decimal iTotalAmount)
        {
            this.objItemsData = objItemsData;
            this.iTotalAmount = iTotalAmount;
        }
    }
    
}