public class RenewalReinstatement{
  
public static Map<Id,Boolean> autoRenewReinstatement(List<Renewal_Application__c> renewReinstateList){
    Map<Id,Boolean> autoIdRenwewalMap = new Map<Id,Boolean>();
    Set<Id> setId = new Set<Id>();
    system.debug('renewReinstateList-----'+renewReinstateList);
    for(Renewal_Application__c renewreinstate :renewReinstateList ){
        setId.add(renewreinstate.id);
    }
    
    List<BGCK__Answer__c> ansList = [select id,Answer_Text__c,Question__c,Renewal_Reinstatement_Application__c from BGCK__Answer__c where Renewal_Reinstatement_Application__c IN:setId AND Question__r.Section__c = 'Legal Background Questions' AND Question__r.Data_Type__c = 'Yes_No' ];
    system.debug('ansList---'+ansList);
    
    Map<id,Boolean> reneUpdate = new Map<id,Boolean>();
    
    List<MUSW__License2__c> licenseList = new List<MUSW__License2__c>();
    if(!ansList.isEmpty()){
       for(Renewal_Application__c rene : renewReinstateList ){
            Integer numberOfQue = 0;
            Integer numberOfNo = 0;
            for(BGCK__Answer__c ans : ansList){
                if(ans.Renewal_Reinstatement_Application__c == rene.Id){
                    numberOfQue++;
                    if(ans.Answer_Text__c == 'No'){
                        numberOfNo++;
                    }
                }
            }
            system.debug('rene ---'+rene);
            system.debug('rene ---'+rene.Renewal_Status__c);
            system.debug('rene ---'+rene.License__c);
            system.debug('rene ----'+rene.License__r.MUSW__Expiration_Date__c);
            if(rene.Renewal_Status__c == 'In-Review' && numberOfQue != 0 && (numberOfQue == numberOfNo)){
                MUSW__License2__c license = new MUSW__License2__c(id= rene.License__c);
                license.MUSW__Status__c = 'Active';
                if(rene.License__r.Is_Late_Renewal_Eligible__c || rene.License__r.Is_Reinstatement_Eligible__c){
                    license.MUSW__Issue_Date__c = System.today();
                }else{
                    if(rene.License__r.MUSW__Expiration_Date__c != null){
                        license.MUSW__Issue_Date__c  = rene.License__r.MUSW__Expiration_Date__c + 1;
                    }
                }    
                
                licenseList.add(license);  
                system.debug('licenseList---'+licenseList);
                autoIdRenwewalMap.put(rene.Id,true);
            }   
        } 
    }
        
        
        if(!licenseList.isEmpty()){
            update licenseList;
        }
        
        return autoIdRenwewalMap;
    }
}