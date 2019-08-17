public class Dol_ConnectToSlipPrinter {
	public String printParameter {get;set;}
    
   	public Dol_ConnectToSlipPrinter() {
        printParameter = ApexPages.currentPage().getParameters().get('validationNo');
    	System.debug('printParameter'+printParameter);
   }     
}