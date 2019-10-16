public class WA_License_utility{

public static void updateRenewalFields(List<MUSW__License2__c> licenseList){
    List<String> programList = new List<String>();
    for(MUSW__License2__c lic : licenseList){
        programList.add(lic.Application_Type__c);
    
    }
    List<MUSW__License2__c> licenseToUpdate = new List<MUSW__License2__c>();
   /* List<Renewal_Reinstatement_Eligibility__c> reneList = [select id,Active__c,License_Type__c,Renewal_Grace_Period_N_Days_After_Expiry__c,Renewal_Eligible_N_Days_Before_Expiry__c,Program_Type__c,Credential_Or_Permit__c,Late_Ren_Eligible_Until_N_Days_After_Exp__c,Reinstatement_Eligible_End_Date__c from Renewal_Reinstatement_Eligibility__c 
                                                           where Active__c = true 
                                                           and  Credential_Or_Permit__c = 'Credential'
                                                           and Program_Type__c IN: programList];*/
    
   for(MUSW__License2__c license : licenseList){
   
       for(Renewal_Reinstatement_Eligibility__c rerinsta : [select id,Active__c,License_Type__c,Renewal_Grace_Period_N_Days_After_Expiry__c,Renewal_Eligible_N_Days_Before_Expiry__c,Program_Type__c,Credential_Or_Permit__c,Late_Ren_Eligible_Until_N_Days_After_Exp__c,Reinstatement_Eligible_End_Date__c from Renewal_Reinstatement_Eligibility__c 
                                                           where Active__c = true 
                                                           and  Credential_Or_Permit__c = 'Credential'
                                                           and Program_Type__c IN: programList]){
           if(rerinsta.Program_Type__c == license.Application_Type__c  && rerinsta.License_Type__c.contains(license.Credential_Type__c) ){
               
               if(rerinsta.Renewal_Eligible_N_Days_Before_Expiry__c != null){
                   license.Renewal_Eligible_Start_Date__c = license.MUSW__Expiration_Date__c - rerinsta.Renewal_Eligible_N_Days_Before_Expiry__c.intValue() ;
               }
               if(rerinsta.Renewal_Grace_Period_N_Days_After_Expiry__c != null){
                   license.Renewal_Grace_Period_End_Date__c = license.MUSW__Expiration_Date__c + rerinsta.Renewal_Grace_Period_N_Days_After_Expiry__c.intValue();
               }
               if(rerinsta.Late_Ren_Eligible_Until_N_Days_After_Exp__c!= null){
                   license.Late_Renewal_Eligible_End_Date__c = license.MUSW__Expiration_Date__c + rerinsta.Late_Ren_Eligible_Until_N_Days_After_Exp__c.intValue();
                   license.Reinstatement_Eligible_Start_Date__c = license.MUSW__Expiration_Date__c + rerinsta.Late_Ren_Eligible_Until_N_Days_After_Exp__c.intValue();
               }
               if(rerinsta.Reinstatement_Eligible_End_Date__c != null){
                   license.Reinstatement_Eligibility_End_Date__c = license.MUSW__Expiration_Date__c + rerinsta.Reinstatement_Eligible_End_Date__c.intValue();
              }
               licenseToUpdate.add(license);
           }
       
       }
   }
}

public static void updateProfessionCode(List<MUSW__License2__c> licenseList){
   List<LnP_ProfessionalCode__mdt> professionCode = [SELECT MasterLabel, License_Type__c, Profession_Code__c FROM LnP_ProfessionalCode__mdt];
    Map<String,String> professionCodeMap = new Map<String,String>(); 
    if(!professionCode.isEmpty()){
        for(LnP_ProfessionalCode__mdt pfcode : professionCode){
           professionCodeMap.put(pfcode.License_Type__c,pfcode.Profession_Code__c);
        } 
    }
    
    for(MUSW__License2__c lic : licenseList){
       // System.debug('inside updateProfessionCode' + professionCodeMap.get(lic.Credential_Type__c));
        lic.Profession_Code__c = professionCodeMap.get(lic.Credential_Type__c);
    }
}
}