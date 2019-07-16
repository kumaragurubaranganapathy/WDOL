/*************************************************************************************************************
** User Story: 77--Addresses on Contacts and Accounts
**************************************************************************************************************
** Class Name    : Address_CC
** Description   : Creates new addresses and junction objects between either contact or account
** Version       : 1.0
** Built By      : Srikanth Kottam
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
** Srikanth Kottam                09/07/2018                    1                          Created
** 
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/

public class Address_CC
{
    @TestVisible
    private ApexPages.StandardController con;
    public boolean countryIsSelected {get; set;}
    public boolean localAddressIsSelected {get; set;}
    public boolean isInternational {get; set;}
    public List<GeoResult> geoResults {get; set;}
    public Integer selectedIndex {get; set;}
    public String selectedInternationalCountry {get; set;}
    public Id recordId {get;set;}
    public boolean newAddress{get;set;}
    public string retURL{get;set;}
   

    public Address_CC(ApexPages.StandardController controller) 
    {
        con = controller;

        if(String.isNotEmpty(((MUSW__Parcel__c)con.getRecord()).Country__c))
            selectCountry();

        geoResults = new List<GeoResult>();
        newAddress = false;
    }
    
    /**
    * Method name  : selectCountry
    * Description  : determines if selected country is international or not
    * Return Type  : void
    * Parameter    : None
    **/
    public void selectCountry()
    {
        retURL = ApexPages.currentPage().getParameters().get('retURL'); 
        String country = ((MUSW__Parcel__c)con.getRecord()).Country__c;
        
        isInternational = false;
        if(country != label.Str_United_States)
        {
            selectedInternationalCountry = country;
            isInternational = true;
        }
        countryIsSelected = true;
    }
    
    /**
    * Method name  : getInternationalCountries
    * Description  : Gets the picklist values for all international countries
    * Return Type  : List<SelectOption> -  the picklist options for countries
    * Parameter    : None
    **/
    public List<SelectOption> getInternationalCountries()
    {
        List<SelectOption> options = new List<SelectOption>();    
            
        for(Schema.PicklistEntry f : MUSW__Parcel__c.Country__c.getDescribe().getPicklistValues())
            if(f.getLabel() != label.Str_United_States)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
        return options;
    }

    /**
    * Method name  : findAddresses
    * Description  : uses AddressService to validate addresses and get list of geocoded addresess
    * Return Type  : void
    * Parameter    : None
    **/
    public void findAddresses()
    {   
        try{
            localAddressIsSelected = false;
        	geoResults.clear();
        	MUSW__Parcel__c addressRecord = (MUSW__Parcel__c)con.getRecord();
        	/*AddressService.GeocodeServiceSoap geoService = new AddressService.GeocodeServiceSoap();
        
        	//GeocodeWebserviceSettings__c geoSettings = UserInfo.getOrganizationId() == '00Dt0000000GynC' ? GeocodeWebserviceSettings__c.getInstance('production') : GeocodeWebserviceSettings__c.getInstance('sandbox');       
        	GeocodeWebserviceSettings__c geoSettings;
        	Boolean org = [Select Id, isSandbox From Organization limit 1][0].isSandbox;
        	if(org == true){
                	geoSettings = GeocodeWebserviceSettings__c.getInstance(label.Str_Sandbox);
            }else{
	                geoSettings = GeocodeWebserviceSettings__c.getInstance(label.Str_production);
            }
        	List<AddressService.GeocodedResult> geoResultsFromWS = geoService.GeocodeAddress(geoSettings.Username__c, geoSettings.Password__c, addressRecord.MUSW__Street2__c, null, addressRecord.MUSW__City__c, addressRecord.MUSW__State__c, addressRecord.MUSW__Post_Zip_Code__c, True, 2, 'ohcounty').resultSet.GeocodedResult;
        
        	for(AddressService.GeocodedResult gr_ws : geoResultsFromWS){   
            AddressService.ArrayOfString str = gr_ws.boundaryFileResults;
            String county = str.string_x[0];
            if(county != null && county.length() > 5){
                 county = county.substring(5,county.length());
             }
            if(gr_ws.matchCode.left(1) == 'E')
                continue;
        
            GeoResult gr = new GeoResult();
            
            gr.AddressLine1 = gr_ws.AddressLine1;
            gr.AddressLine2 = gr_ws.AddressLine2;
            gr.City = gr_ws.City;
            gr.state = gr_ws.state;
            gr.zipCode = gr_ws.zipCode;
            gr.matchCode = gr_ws.matchCode;
            gr.locationQualityCode = gr_ws.locationQualityCode;
            gr.locationConfidenceCode = gr_ws.locationConfidenceCode;
            gr.latitude = gr_ws.latitude;
            gr.longitude = gr_ws.longitude;
            gr.validated = true;
            gr.index = geoResults.size();
            gr.county = county;
            geoResults.add(gr);
        }*/
            
            // Instantiate a new http object
            Http h = new Http();
            String url = '';
            
            transient Boolean org = [Select Id, isSandbox From Organization][0].isSandbox;
            if(org == true){
                url = 'callout:Wisconsin_Endpoint_Test/address/v1/validate';
            }else{
                url = 'callout:Wisconsin_Endpoint_Prod/address/v1/validate';
            }
            
             // Instantiate a new HTTP request, specify the method (PUT) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('PUT');
            req.setHeader('Content-Type', 'application/json');
            
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('AddressLine1', addressRecord.MUSW__Street2__c);
            gen.writeStringField('City', addressRecord.MUSW__City__c);
            gen.writeStringField('State', addressRecord.MUSW__State__c);
            if(addressRecord.MUSW__Post_Zip_Code__c != null && addressRecord.MUSW__Post_Zip_Code__c != '') gen.writeStringField('PostalCode', addressRecord.MUSW__Post_Zip_Code__c);
            gen.writeStringField('CountryName', 'US');
            gen.writeEndObject();
            
            String reqBody = gen.getAsString();
            system.debug(reqBody);
            req.setBody(reqBody);
            
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            system.debug(res.getBody());
        
            GeoResult result = new GeoResult();
            result.index = 0;
            result.validated = true;
            
            JSONParser parser = JSON.createParser(res.getBody());
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                    String fieldName = parser.getText();
                    parser.nextToken();
                    String fieldValue = parser.getText();
                    if(fieldName == 'AddressLine1'){
                        result.addressLine1 = fieldValue;
                    }else if(fieldName == 'AddressLine2'){
                        result.addressLine2 = fieldValue;
                    }else if(fieldName == 'City'){
                        result.city = fieldValue;
                    }else if(fieldName == 'State'){
                        result.state = fieldValue;
                    }else if(fieldName == 'PostalCode'){
                        result.ZipCode = fieldValue;
                    }else if(fieldName == 'CountyName'){
                        result.County = fieldValue;
                    }else if(fieldName == 'Latitude'){
                        result.latitude = Double.valueOf(fieldValue);
                    }else if(fieldName == 'Longitude'){
                        result.longitude = Double.valueOf(fieldValue);
                    }
                }
            }
            
            result.validated = true;
            result.index = geoResults.size();
                
            geoResults.add(result);

        	boolean addressFound = false;
        	for(GeoResult gr : geoResults){
            	if( gr.AddressLine1 == addressRecord.MUSW__Street2__c &&
                	gr.City == addressRecord.MUSW__City__c &&
                	gr.state == addressRecord.MUSW__State__c &&
                	gr.zipCode == addressRecord.MUSW__Post_Zip_Code__c &&
                	gr.county == addressrecord.County__c)
            	{
                addressFound = true;

                selectedIndex = gr.index;
                localAddressIsSelected = true;

                break;
            }
        }

        	if(!addressFound){
            	GeoResult input_gr = new GeoResult();

            	input_gr.AddressLine1 = addressRecord.MUSW__Street2__c;
            	input_gr.City = addressRecord.MUSW__City__c;
            	input_gr.state = addressRecord.MUSW__State__c;
            	input_gr.zipCode = addressRecord.MUSW__Post_Zip_Code__c;
            	input_gr.county = addressRecord.county__c;
            	input_gr.validated = false;
            	input_gr.index = geoResults.size();

            	geoResults.add(input_gr);
        	}
        	}catch(DmlException e){
            	ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AddressForAccountNewControllerExt', null, 'findAddresses', 'AddressForAccountNewControllerExt', label.str_HIGH);
        	}

    }
    

    /**
    * Method name  : selectAddress
    * Description  : sets localAddressIsSelected flag if address from georesults is chosen
    * Return Type  : PageReference
    * Parameter    : None
    **/
    public PageReference selectAddress()
    {
        localAddressIsSelected = true;
        return null;
    }
    
    /**
    * Method name  : saveLocalAddress
    * Description  : saves parcel object with data from georesults and calls juntction object creation function
    * Return Type  : PageReference
    * Parameter    : None
    **/
    public PageReference saveLocalAddress(){
        MUSW__Parcel__c addressRecord = (MUSW__Parcel__c)con.getRecord();
      /*  GeoResult gr = geoResults[selectedIndex];
        system.debug('addressRecord>>>>>>'+addressRecord);
        addressRecord.MUSW__Street2__c = gr.AddressLine1;
        addressRecord.MUSW__City__c = gr.City;
        addressRecord.MUSW__State__c = gr.state;
        addressRecord.MUSW__Post_Zip_Code__c = gr.zipCode;
        addressRecord.Validated__c = gr.validated;
        addressRecord.county__c = gr.county;  */
        system.debug('addressRecord>>>>>>'+addressRecord);
        boolean newAddress = addressRecord.Id == null ? true : false;
        //PageReference pr = con.save();
        upsert addressRecord;
        PageReference pr = new PageReference('/' + addressRecord.Id);
        
        //system.debug('>>>>>>>>>>>> addressRecord ' + addressRecord.Id);
        createAddressJunctionObj(addressRecord);
        
        if(string.isBlank(retURL)){
            return pr;
        }else{
            return new pagereference(retURL);
        }
    }

    /**
    * Method name  : saveInternationalAddress
    * Description  : saves parcel object and calls junction object creation method
    * Return Type  : PageReference
    * Parameter    : None
    **/
    public PageReference saveInternationalAddress(){
        MUSW__Parcel__c addressRecord = (MUSW__Parcel__c)con.getRecord();
        addressRecord.Country__c = selectedInternationalCountry;
        system.debug('addressRecord>>>>>>'+addressRecord);
        boolean newAddress = addressRecord.Id == null ? true : false;
        //PageReference pr = con.save();
        upsert addressRecord;
        PageReference pr = new PageReference('/' + addressRecord.Id);
        
        //system.debug('>>>>>>>>>>>> addressRecord ' + addressRecord.Id);
        createAddressJunctionObj(addressRecord);
        return pr;
    }

    /**
    * Method name  : createAddressJunctionObj
    * Description  : creates junction object between either the account or the contace with the newly created parcel object
    * Return Type  : void
    * Parameter    : None
    **/    
    public void createAddressJunctionObj(MUSW__Parcel__c addressRecord){
        Parcel_Account__c junctionAccountObj;
        MUSW__Parcel_Contact2__c junctionContactObj;
        
        try{
            if(addressRecord.MUSW__Primary_Contact__c!=null){
                junctionContactObj = new MUSW__Parcel_Contact2__c(MUSW__Contact__c = addressRecord.MUSW__Primary_Contact__c, MUSW__Parcel__c = addressRecord.Id);
                if(junctionContactObj != null){
                    insert junctionContactObj;  
                }
            }
            if(addressRecord.Primary_Account__c !=null){
                junctionAccountObj = new Parcel_Account__c(Account__c =addressRecord.Primary_Account__c, Parcel__c = addressRecord.Id);
                if(junctionAccountObj != null){
                    insert junctionAccountObj;  
                }
            }
        }catch(DmlException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,System.Label.Err_PageStatement));
           // ErrorLogger.logGeneralException(e, UserInfo.getUserId(), 'AddressForAccountNewControllerExt', null, 'createAddressJunctionObj', 'AddressForAccountNewControllerExt', label.str_HIGH);
        }
    }

    /**
    * Wrapper class for holding geo location results
    **/
    public class GeoResult{
        public Integer index {get; set;}
        public String AddressLine1 {get; set;}
        public String AddressLine2 {get; set;}
        public String City {get; set;}
        public String state {get; set;}
        public String zipCode {get; set;}
        public String matchCode {get; set;}
        public String locationQualityCode {get; set;}
        public Integer locationConfidenceCode {get; set;}
        public Double latitude {get; set;}
        public Double longitude {get; set;}
        public boolean validated {get; set;}
        public string County {get; set;}
    }
}