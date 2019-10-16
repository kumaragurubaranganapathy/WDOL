public class Dol_UBISearchTransform {

    @auraEnabled
    public static String transformAndSave (id accountId, String ubi){  
        String newUBI= DOL_AppConstants.NULL_EMPTY_STRING + '';
        String status = DOL_AppConstants.NULL_EMPTY_STRING + '';
        String businessName = DOL_AppConstants.NULL_EMPTY_STRING + '';
        String businessStatus = DOL_AppConstants.NULL_EMPTY_STRING + '';
        
        List<String> ubiafterHash = ubi.split('-');
        //System.debug('UBI after split'+ubi.split('-'));
        //System.debug('First term'+ubiafterHash[0].trim());
        if(Dol_IntegrationUtil.isNotEmpty(ubiafterHash)){
            newUBI = ubiafterHash[0].trim() + ubiafterHash[1].trim() + ubiafterHash[2].trim();
        }
            
        Dol_SOSResponse responseDeatil = new Dol_SOSResponse();
        Account selectedAccount = new Account();
        List<Dol_SOSResponse.GoverningPersons> governingdetails = new List<Dol_SOSResponse.GoverningPersons>();
        
        try{
            HttpResponse apiRespone = Dol_RestAPIservice.callSOSservice(newUBI);
            if(apiRespone.getStatusCode() == 200){
                responseDeatil = (Dol_SOSResponse)JSON.deserialize(apiRespone.getBody(), Dol_SOSResponse.class);
                if(responseDeatil != null && responseDeatil.entity != null){
                    businessName = responseDeatil.entity.businessName != null ? responseDeatil.entity.businessName.trim() : '';
                    businessStatus = responseDeatil.entity.active !=null ? responseDeatil.entity.active.trim() : '';
                    governingdetails = responseDeatil.entity.governingPerson;
                    
                    //System.debug('governingdetails'+governingdetails[0].title);
                    //System.debug('businessName'+responseDeatil.entity.businessName);
                    if(Dol_IntegrationUtil.isNotBlank(accountId)){
                        selectedAccount = [select Id, Name from Account where id=:accountId AND id != null limit 1];
                    }
                    //System.debug('selectedAccount'+selectedAccount);
                    //follwoing two conditions have been removed as per User Story 1436
                    /* if(selectedAccount!= null && selectedAccount.name!= null && Dol_IntegrationUtil.isNotBlank(businessName) && selectedAccount.name != businessName && !businessStatus.equalsIgnoreCase('active')){
                        status = 'MismatchInactive'+'-'+'businessName';
                    }*/
                    
                    if(selectedAccount!= null && selectedAccount.name!= null && Dol_IntegrationUtil.isNotBlank(businessName) && selectedAccount.name != businessName ){
                        status = DOL_AppConstants.NULL_EMPTY_STRING + 'Mismatch'+'***'+businessName+'***'+selectedAccount.name;
                    }
                    
                   else if(selectedAccount!= null && selectedAccount.name!= null && Dol_IntegrationUtil.isNotBlank(businessName) && !businessStatus.equalsIgnoreCase('active')){
                        status = DOL_AppConstants.NULL_EMPTY_STRING + 'Inactive';
                    }
        
                    else if(selectedAccount!= null && selectedAccount.name!= null && Dol_IntegrationUtil.isNotBlank(businessName) && businessStatus.equalsIgnoreCase('active') && selectedAccount.name == businessName){
                        Map<String,Dol_SOSResponse.GoverningPersons> governingMap = new Map<String,Dol_SOSResponse.GoverningPersons>();
                        Map<String,MUSW__Account_Contact__c> accountConMap = new Map<String,MUSW__Account_Contact__c>();
                        List<Dol_SOSResponse.GoverningPersons> uniqueGovList = new List<Dol_SOSResponse.GoverningPersons>();
                        List<MUSW__Account_Contact__c> newAccountConList = new List<MUSW__Account_Contact__c>();
                        List<MUSW__Account_Contact__c> accountConList = new List<MUSW__Account_Contact__c>();
                        String accountName;
                        String governingName;
                        
                        Account acc = new Account(id = accountId);
                        acc.Name  = businessName ;
                        acc.UBI_Number__c = responseDeatil.entity.ubi !=null ? responseDeatil.entity.ubi.trim() : '';
                        acc.Business_Structure__c  = responseDeatil.entity.typeDescription !=null ? responseDeatil.entity.typeDescription.trim() : ''; 
                        acc.UBI_Status__c = businessStatus ;
                        acc.Account_Status__c = businessStatus;
                        
                        accountConList = [Select id,Title__c,Last_Name__c,Middle_Name__c,First_Name__c from MUSW__Account_Contact__c where MUSW__Account__c =:accountId AND MUSW__Account__c != null];
                        //System.debug('accountConList=='+accountConList);
                        //System.debug('governingdetails=='+governingdetails);
                        if(Dol_IntegrationUtil.isNotEmpty(governingdetails) && Dol_IntegrationUtil.isNotEmpty(accountConList)){
                                for(Dol_SOSResponse.GoverningPersons govdetail : governingdetails){ 
                                    governingName= DOL_AppConstants.NULL_EMPTY_STRING + '';
                                    if(govdetail.title != null){ governingName+= govdetail.title;}
                                    if(govdetail.firstName != null){ governingName+= govdetail.firstName;}
                                    if(govdetail.middleName != null){ governingName+= govdetail.middleName;}
                                    if(govdetail.lastName != null){ governingName+= govdetail.lastName;}
                                    governingMap.put(governingName,govdetail);
                                    //System.debug('governingMap'+governingMap);
                                    
                                }
                                for(MUSW__Account_Contact__c accountCon : accountConList){ 
                                    accountName = DOL_AppConstants.NULL_EMPTY_STRING + '';
                                    if(accountCon.Title__c != null){ accountName+= accountCon.Title__c;}
                                    if(accountCon.First_Name__c != null){ accountName+= accountCon.First_Name__c;}
                                    if(accountCon.Middle_Name__c != null){ accountName+= accountCon.Middle_Name__c;}
                                    if(accountCon.Last_Name__c != null){ accountName+= accountCon.Last_Name__c;}
                                    accountConMap.put(accountName,accountCon);
                                    //System.debug('accountConMap'+accountConMap);
                                }

                                for(String govName : governingMap.keySet()){
                                    if(!accountConMap.containsKey(govName)){
                                        //System.debug('accountConMapmismatch');
                                    	uniqueGovList.add(governingMap.get(govName));
                                    }
                                }
                            	//System.debug('uniqueGovList'+uniqueGovList);
                                for(Dol_SOSResponse.GoverningPersons govdetail : uniqueGovList){
                                	MUSW__Account_Contact__c newAccountCon = new MUSW__Account_Contact__c();
                                    newAccountCon.Title__c = govdetail.title != null ? govdetail.title.trim() : '' ;
                                    newAccountCon.Last_Name__c = govdetail.lastName != null ? govdetail.lastName.trim() : '' ;
                                    newAccountCon.Middle_Name__c = govdetail.middleName != null ? govdetail.middleName.trim() : '' ;
                                    newAccountCon.First_Name__c = govdetail.firstName != null ? govdetail.firstName.trim() : '' ;
                                    newAccountCon.MUSW__Account__c = accountId;
                                    //Hardcording role to "Owner" as per user  BUG 6237.
                                	newAccountCon.Role__c = Label.SOS_Role ;
                                    //Hardcording Status field as per user Story 1436.
                                	newAccountCon.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
                                    newAccountConList.add(newAccountCon);
                                }
                        }else if(Dol_IntegrationUtil.isNotEmpty(governingdetails) && Dol_IntegrationUtil.isEmpty(accountConList)){
                            for(Dol_SOSResponse.GoverningPersons govdetail : governingdetails ){
                                MUSW__Account_Contact__c newAccountCon = new MUSW__Account_Contact__c();
                                newAccountCon.Title__c = govdetail.title != null ? govdetail.title.trim() : '' ;
                                newAccountCon.Last_Name__c = govdetail.lastName != null ? govdetail.lastName.trim() : '' ;
                                newAccountCon.Middle_Name__c = govdetail.middleName != null ? govdetail.middleName.trim() : '' ;
                                newAccountCon.First_Name__c = govdetail.firstName != null ? govdetail.firstName.trim() : '' ;
                                newAccountCon.MUSW__Account__c = accountId;
                               //Hardcording role to "Owner" as per user  BUG 6237.
                                newAccountCon.Role__c = Label.SOS_Role ;
                                //Hardcording Status field as per user Story 1436.
                                newAccountCon.Status__c = DOL_AppConstants.NULL_EMPTY_STRING + 'Active';
                                newAccountConList.add(newAccountCon);
                            } 
                         }
                        try{
                            if(acc!= null){
                                upsert acc;
                                status = DOL_AppConstants.NULL_EMPTY_STRING + 'success';
                            }
                            //System.debug('newAccountConList'+newAccountConList);
                            if(newAccountConList != null){
                                //System.debug('newAccountConList'+newAccountConList);
                                upsert newAccountConList ;
                                status = DOL_AppConstants.NULL_EMPTY_STRING + 'success'; 
                            } 
                            
                        }catch(exception e){
                            status = DOL_AppConstants.NULL_EMPTY_STRING + 'DML Exception'; 
                            DebugErrorLoggger.LogError(e, '', '','Dol_SOSservice','searchbyUBI','searchbyUBI Method failed');
                        }
                        
                    }
                    
                } 
            } 
            else if(apiRespone.getStatusCode() == 404){
                    status = DOL_AppConstants.NULL_EMPTY_STRING + 'UBI not found';}
            else {status = DOL_AppConstants.NULL_EMPTY_STRING + 'error from SOS';}
            
                
        }catch (Exception e){
            //System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DOL_CreateErrorLog_Exception.logApplicationError(e);
            throw new AuraHandledException('An error occurred: '+e.getMessage());
        }
            //System.debug('status==' + status);
            return status;
    }
    
     @auraEnabled
    public static String getAccountUBI (id accountId){
        try{
            Account accObj = [select id, UBI_Number__c from Account where id=:accountId limit 1];
            String accUBI = DOL_AppConstants.NULL_EMPTY_STRING + '';
            if(accObj.UBI_Number__c!=null ||accObj.UBI_Number__c!='' ){
                accUBI = accObj.UBI_Number__c;
            }
            return accUBI;
        }
        catch(Exception ex)
        {
            DOL_CreateErrorLog_Exception.logApplicationError(ex);
            throw new AuraHandledException('An error occurred: '+ex.getMessage());
        }
    }
}