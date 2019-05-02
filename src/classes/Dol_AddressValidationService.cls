public class Dol_AddressValidationService {
    @auraEnabled
    public static Dol_AddressValidationService.AddrWrapper validateAddress(String addrLine1,String addrLine2,String city, String state, String zip){
		String licenseKey;
		Dol_AddressValidationService.AddrWrapper validatedAddress = new Dol_AddressValidationService.AddrWrapper();
		
		Dol_Integration_Settings__mdt customSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt where DeveloperName ='Address_LicenseKey' Limit 1];
		if(customSettings != null){
			licenseKey = customSettings.Value__c.trim();
		}
		String requestbody = '<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:urn=\"urn:MelissaDataAddressCheckService\" xmlns:urn1=\"urn:mdWebServiceAddress\">'
		+'<soapenv:Header/>'
		+'<soapenv:Body>'
		+'<urn:doAddressCheck>'
			+'<urn:Request>'
			+'<urn1:CustomerID>'+licenseKey+'</urn1:CustomerID>'
				+'<urn1:Record>'
				+'<urn1:AddressLine1>'+addrLine1+'</urn1:AddressLine1>'
            	+'<urn1:AddressLine2>'+addrLine2+'</urn1:AddressLine2>'
				+'<urn1:City>'+city+'</urn1:City>'
				+'<urn1:State>'+state+'</urn1:State>'
				+'<urn1:Zip>'+zip+'</urn1:Zip>'
				+'</urn1:Record>'
			+'</urn:Request>'
		+'</urn:doAddressCheck>'
		+'</soapenv:Body>'
		+'</soapenv:Envelope>';
		mdwebserviceaddress.ResponseArray res = new mdwebserviceaddress.ResponseArray();
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
		request.setHeader('SOAPAction', 'urn:MelissaDataAddressCheckService/IService/doAddressCheck');
		request.setEndpoint('https://addresscheck.melissadata.net/v2/SOAP/Service.svc');
		request.setMethod('POST');
		request.setBody(requestbody);
		HttpResponse response = new HttpResponse();
        if(!Test.isRunningTest()){
           response = new Http().send(request); 
        }
        else {
          response.setBody(Dol_AddressValidationService_Test.responsebody);
        }
		Dom.Document xml = response.getBodyDocument();
		Dom.XMLNode envelope = xml.getRootElement();
		Dom.XMLNode address = envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('doAddressCheckResponse','urn:MelissaDataAddressCheckService').getChildElement('doAddressCheckResult','urn:MelissaDataAddressCheckService').getChildElement('Record','urn:mdWebServiceAddress').getChildElement('Address', 'urn:mdWebServiceAddress');
		validatedAddress.street = address.getChildElement('Address1', 'urn:mdWebServiceAddress').getText();
        validatedAddress.street2 = address.getChildElement('Suite', 'urn:mdWebServiceAddress').getText();
        System.debug('suite2'+validatedAddress.street2);
       	validatedAddress.city = address.getChildElement('City', 'urn:mdWebServiceAddress').getChildElement('Name', 'urn:mdWebServiceAddress').getText();
       	validatedAddress.state = address.getChildElement('State', 'urn:mdWebServiceAddress').getChildElement('Abbreviation', 'urn:mdWebServiceAddress').getText();
        String zipRange ;
        if(address.getChildElement('Zip', 'urn:mdWebServiceAddress').getText() != null){
          zipRange = address.getChildElement('Zip', 'urn:mdWebServiceAddress').getText();
            System.debug('zip**'+address.getChildElement('Plus4', 'urn:mdWebServiceAddress').getText());
            string plus4 = address.getChildElement('Plus4', 'urn:mdWebServiceAddress').getText();
                
            if(plus4 != null && plus4 != '' && plus4 !=' ' && plus4 != 'undefined'){
               zipRange += '-'+address.getChildElement('Plus4', 'urn:mdWebServiceAddress').getText();
            }
        }
        validatedAddress.zip = zipRange;
		System.debug('zipRange'+zipRange);
        validatedAddress.country = address.getChildElement('Country', 'urn:mdWebServiceAddress').getChildElement('Name', 'urn:mdWebServiceAddress').getText() == 'United States of America' ? 'United States' : '';
        return validatedAddress;
	}

	 @AuraEnabled
    public static String getObjAPI(String recordId) {
        if(recordId == null || recordId == '') {
            return null;
        }
        
        Id sRecordId = recordId;
        String objName = sRecordId.getSObjectType().getDescribe().getName();
        system.debug('!!!! createTimeEntry.objName = ' + objName);
        
        return objName;
    }
	 @AuraEnabled 
    public static List<String> getStates(sObject objObject, string fld) {
      system.debug('objObject:' + objObject);
      system.debug('fld:' + fld);
      List<String> allOpts = new list <String> ();
      // Get the object type of the SObject.
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      Map<String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
      List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
      for (Schema.PicklistEntry a: values) {
       allOpts.add(a.getValue());
      }
      system.debug('allOpts ---->' + allOpts);
      return allOpts;
    }
	@auraEnabled
	public static Boolean saveAddress(string selectedAddress,Boolean isAptInfo, String parentId){
		Boolean success = false;
        String addres1;
        String aptInfo;
        String city;
        String state;
        String zip;
        String country;
        
        try{
            if(Dol_IntegrationUtil.isNotBlank(selectedAddress)){
                selectedAddress= selectedAddress.replaceAll('\\<.*?\\>', '');
                List<String> Addresslist = selectedAddress.split(',');
                if(Dol_IntegrationUtil.isNotempty(Addresslist)){
                    addres1 = Addresslist[0] != null ? Addresslist[0].trim() : '';
                    //if address line 2 is null
                    if(!isAptInfo){
                        city = Addresslist[1] != null ? Addresslist[1].trim() : '';
                        state = Addresslist[2] != null ? Addresslist[2].trim() : '';
                        zip = Addresslist[3] != null ? Addresslist[3].trim() : '';
                        country = Addresslist[4] != null ? Addresslist[4].trim() : '';
                    }
                     //if address line 2 is NOT null
                    else if(isAptInfo){
                        city = Addresslist[2] != null ? Addresslist[2].trim() : '';
                        state = Addresslist[3] != null ? Addresslist[3].trim() : '';
                        zip = Addresslist[4] != null ? Addresslist[4].trim() : '';
                        country = Addresslist[5] != null ? Addresslist[5].trim() : '';
                    }
                }
                List<MUSW__Parcel__c> existingParcel = [SELECT id,MUSW__Primary_Contact__c from MUSW__Parcel__c where MUSW__Street2__c =:addres1 AND MUSW__City__c=:city AND MUSW__State__c=:state AND MUSW__Post_Zip_Code__c=:zip AND Country__c=:country Limit 1];
                if(Dol_IntegrationUtil.isNotempty(existingParcel)){
                    if(Dol_IntegrationUtil.isNotBlank(parentId)){
                        String sObjectName = getObjAPI(parentId) ;
                        if(sObjectName == 'Contact'){
                        	existingParcel[0].MUSW__Primary_Contact__c = parentId;
                        }
                        upsert existingParcel[0];
                        success = true;
                    }
                }
                else{
                    MUSW__Parcel__c parcel = new MUSW__Parcel__c();
                    parcel.MUSW__Street2__c = addres1;
                    parcel.MUSW__City__c = city;
                    parcel.MUSW__State__c = state;
                    parcel.MUSW__Post_Zip_Code__c = zip;
                    parcel.Country__c = country;
                    if(Dol_IntegrationUtil.isNotBlank(parentId)){
                        String sObjectName = getObjAPI(parentId) ;
                        system.debug('sObjectName'+sObjectName);
                        if(sObjectName == 'Contact'){
                            system.debug('sObjectNameconatct');
                            
                            parcel.MUSW__Primary_Contact__c = parentId;
                        }
                	}
                    System.debug('parcel' + parcel);
                    if(parcel != null){
                        upsert parcel;
                        if(Dol_IntegrationUtil.isNotBlank(parcel.id)){
                            success = true;
                        }
                    } 
                  }
            	}
            }catch(Exception e){
            System.debug('Dol_AddressValidationService - Exception: '+e);
            DebugErrorLoggger.LogError(e, '', '','Dol_AddressValidationService','saveAddress','saveAddress Method failed');  
        }
		
		return success;
	}
    public class AddrWrapper {
		@auraEnabled	public String country {get;set;}
		@auraEnabled	public String street {get;set;}
        @auraEnabled	public String street2 {get;set;}
		@auraEnabled	public String city {get;set;}
		@auraEnabled	public String state {get;set;}
		@auraEnabled	public String zip {get;set;}
	}

}