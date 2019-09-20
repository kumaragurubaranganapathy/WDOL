public class Dol_ConnectToSlipPrinter {
	public String printParameter {get;set;}
    public String printerName {get;set;}
    public Boolean isdebugOn {get;set;}
    public Boolean isPrinterConfigured {get;set;}
    
   	public Dol_ConnectToSlipPrinter() {
        printParameter = ApexPages.currentPage().getParameters().get('validationNo');
    	System.debug('printParameter'+printParameter);
        String userName = UserInfo.getUserName();
        List<SlipPrinterNameToUserMap__mdt> slipprinterDetail = [select IsDebugON__c, PrinterName__c, UserName__c from SlipPrinterNameToUserMap__mdt where UserName__c=:userName limit 1];
   		System.debug('slipprinterDetail'+slipprinterDetail);
        if(slipprinterDetail != null && Dol_IntegrationUtil.isNotEmpty(slipprinterDetail)){
            isPrinterConfigured = true;
            printerName = slipprinterDetail[0].PrinterName__c;
            Boolean debugOn = slipprinterDetail[0].IsDebugON__c;
            if(debugOn){
                isdebugOn = True;
            }
            else isdebugOn = False;
        }else  isPrinterConfigured= false;
        System.debug('isPrinterConfigured=='+isPrinterConfigured);
    }     
}