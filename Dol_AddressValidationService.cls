public class Dol_AddressValidationService {

    private static Dol_WebServiceAddress.ResponseArray validateAddress(Dol_WebServiceAddress.RequestArray request) {
    	try{
    		Dol_AddressCheckService.BasicHttpBinding_IService validAddress = new Dol_AddressCheckService.BasicHttpBinding_IService();
        	return validAddress.doAddressCheck(request);
    	}catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','Dol_AddressValidationService','validate','validate address Method failed');
            return null;
        }

        
    }

    public static void validate(String addrLine1,String addrLine2,String city, String state, String zip){
    	List<Dol_WebServiceAddress.Record_element> recordList = new List<Dol_WebServiceAddress.Record_element>();
    	String licenseKey ;
    	//String addrLine1 = '501 Murphy Ranch RD';
    	//String city = 'Milpitas';
    	//String state = 'CA';
    	//String zip = '95035';

    	try {
    		Dol_Integration_Settings__mdt customSettings = [SELECT MasterLabel, DeveloperName, Value__c  FROM Dol_Integration_Settings__mdt where DeveloperName ='Address_LicenseKey' Limit 1];
    		if(customSettings != null){
    			licenseKey = customSettings.Value__c.trim();
    		}
	    	Dol_WebServiceAddress.City_element cityElement = new Dol_WebServiceAddress.City_element();
	    	cityElement.Name = city;
	    	
	    	Dol_WebServiceAddress.State_element stateElement = new Dol_WebServiceAddress.State_element();
	    	stateElement.Abbreviation = state;
	    	
	    	//Dol_WebServiceAddress.Zip_element zipElement = new Dol_WebServiceAddress.Zip_element();
	    	//zipElement.Code = zip;



	    	Dol_WebServiceAddress.Address_element  address = new Dol_WebServiceAddress.Address_element();
	    	address.Address1 = addrLine1;
	    	address.Address2 = addrLine2; 
	    	address.City = cityElement;
	    	address.State = stateElement;
	    	address.Zip = zip;

	    	//Dol_WebServiceAddress.Type_element typeElement = new Dol_WebServiceAddress.Type_element();
	    	//typeElement.Address = address;
	    	//typeElement.Zip = zipElement;
	    	//address.TypeElement = typeElement;

	    	

	    	Dol_WebServiceAddress.Record_element record = new 	Dol_WebServiceAddress.Record_element();
	    	record.Address = address;

	    	recordList.add(record);

	    	Dol_WebServiceAddress.RequestArray request = new Dol_WebServiceAddress.RequestArray();
	    	request.CustomerID = licenseKey;
	    	request.Record = recordList;
	    	System.debug('request=='+request);
	    	Dol_WebServiceAddress.ResponseArray respone = new Dol_WebServiceAddress.ResponseArray();
	    	Dol_AddressCheckService.BasicHttpBinding_IService validAddress = new Dol_AddressCheckService.BasicHttpBinding_IService();
	    	//respone = validAddress.doAddressCheck(request);
	    	respone = validateAddress(request);

	    	System.debug('respone=='+respone);
	    	System.debug('respone==Version'+respone.Version);
	    	System.debug('respone==Results'+respone.Results);
	    	System.debug('Addressjson=='+json.serialize(respone.record[0].Address));
    	}catch (Exception e){
            System.debug('exception occoured'+e.getMessage()+e.getStackTraceString());
            DebugErrorLoggger.LogError(e, '', '','Dol_AddressValidationService','doCall','doCall to validate address Method failed');
        }

    }
    public static Dol_WebServiceAddress.ResponseArray retrive(){
    	//Dol_WebServiceAddress.ResponseArray res = new Dol_WebServiceAddress.ResponseArray();
    	String requestbody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'+ 'xmlns:urn="urn:MelissaDataAddressCheckService"'+'xmlns:urn1="urn:mdWebServiceAddress">'+
						    ' <soapenv:Header />'+
						    ' <soapenv:Body>'+
						       ' <urn:doAddressCheck>'+
						            ' <urn:Request>'+
						                ' <urn1:TransmissionReference></urn1:TransmissionReference>'+
						                ' <urn1:CustomerID>100794913</urn1:CustomerID>'+
						                ' <urn1:OptAddressParsed>?</urn1:OptAddressParsed>'+
						                ' <urn1:Record>'+
						                    ' <urn1:RecordID></urn1:RecordID>'+
						                    ' <urn1:Company>?</urn1:Company>'+
						                    ' <urn1:LastName>?</urn1:LastName>'+
						                    ' <urn1:Urbanization>?</urn1:Urbanization>'+
						                    ' <urn1:Address1>501 murphy ranch rd</urn1:Address1>'+
						                    ' <urn1:Address2>?</urn1:Address2>'+
						                    ' <urn1:Suite>?</urn1:Suite>'+
						                    ' <urn1:City>Milpitas</urn1:City>'+
						                    ' <urn1:State>CA</urn1:State>'+
						                    ' <urn1:Zip>95035</urn1:Zip>'+
						                    ' <urn1:Plus4>?</urn1:Plus4>'+
						                    ' <urn1:Country>?</urn1:Country>'+
						                ' </urn1:Record>'+
						            ' </urn:Request>'+
						        ' </urn:doAddressCheck>'+
						    ' </soapenv:Body>'+
						' </soapenv:Envelope>';
		Dol_WebServiceAddress.ResponseArray res = new Dol_WebServiceAddress.ResponseArray();
		//String requestbody= '<soapenv:Envelopexmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"xmlns:urn="urn:MelissaDataAddressCheckService"xmlns:urn1="urn:mdWebServiceAddress"><soapenv:Header/><soapenv:Body><urn:doAddressCheck><urn:Request><urn1:TransmissionReference></urn1:TransmissionReference><urn1:CustomerID>100794913</urn1:CustomerID><urn1:OptAddressParsed>?</urn1:OptAddressParsed><urn1:Record><urn1:RecordID></urn1:RecordID><urn1:Company>?</urn1:Company><urn1:LastName>?</urn1:LastName><urn1:Urbanization>?</urn1:Urbanization><urn1:AddressLine1>501murphyranchrd</urn1:AddressLine1><urn1:AddressLine2></urn1:AddressLine2><urn1:Suite>?</urn1:Suite><urn1:City>milpitas</urn1:City><urn1:State>ca</urn1:State><urn1:Zip>95035</urn1:Zip><urn1:Plus4>?</urn1:Plus4><urn1:Country>?</urn1:Country></urn1:Record></urn:Request></urn:doAddressCheck></soapenv:Body></soapenv:Envelope>';
    	Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
		request.setHeader('SOAPAction', 'doAddressCheck');
		request.setEndpoint('https://addresscheck.melissadata.net/v2/SOAP/Service.svc');
		request.setMethod('POST');
		request.setBody(requestbody);
		
		System.debug('http request--> '+request);


		//HttpResponse response = http.send(request);
		HttpResponse response = new HttpResponse();
		response = new Http().send(request);
		System.debug('http response--> '+response);
		//if(response.getStatusCode() == 200){
			res = (Dol_WebServiceAddress.ResponseArray) System.JSON.deserialize(response.getBody(), Dol_WebServiceAddress.ResponseArray.class);
		//}
		System.debug('response=='+res);
		return res;
	}

}