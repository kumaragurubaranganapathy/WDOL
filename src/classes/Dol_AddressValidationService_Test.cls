@isTest(seeAllData=true)
public class Dol_AddressValidationService_Test{
    public static String responsebody = '<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">'+
   '<s:Body xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"' + 'xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">'+
     '<doAddressCheckResponse xmlns=\"urn:MelissaDataAddressCheckService\">'+
        ' <doAddressCheckResult>'+
           '<Version xmlns="urn:mdWebServiceAddress">2.0.62</Version>'+
           '<TransmissionReference xmlns="urn:mdWebServiceAddress">?</TransmissionReference>'+
            '<Results xmlns="urn:mdWebServiceAddress"></Results>'+
            '<TotalRecords xmlns="urn:mdWebServiceAddress">1</TotalRecords>'+
           '<Record xmlns="urn:mdWebServiceAddress">'+
               '<RecordID>?</RecordID>'+
               '<Results>AC13,AS01</Results>'+
               '<Address>'+
                  '<Company>?</Company>'+
                  '<Urbanization>'+
                     '<Name>?</Name>'+
                  '</Urbanization>'+
                  '<Address1>501 Murphy Ranch Rd</Address1>'+
                  '<Address2></Address2>'+
                  '<Suite>Apt 450</Suite>'+
                  '<PrivateMailBox></PrivateMailBox>'+
                  '<City>'+
                     '<Name>Milpitas</Name>'+
                     '<Abbreviation>Milpitas</Abbreviation>'+
                  '</City>'+
                  '<State>'+
                     '<Name>California</Name>'+
                     '<Abbreviation>CA</Abbreviation>'+
                  '</State>'+
                  '<Zip>95035</Zip>'+
                  '<Plus4>7976</Plus4>'+
                  '<CarrierRoute>C053</CarrierRoute>'+
                  '<DeliveryPointCode>00</DeliveryPointCode>'+
                  '<DeliveryPointCheckDigit>9</DeliveryPointCheckDigit>'+
                  '<CongressionalDistrict>17</CongressionalDistrict>'+
                  '<Type>'+
                     '<Address>'+
                        '<Code>H</Code>'+
                        '<Description>Highrise</Description>'+
                     '</Address>'+
                     '<Zip>'+
                        '<Code></Code>'+
                        '<Description>Standard ZIP Code</Description>'+
                     '</Zip>'+
                  '</Type>'+
                  '<Country>'+
                     '<Abbreviation>US</Abbreviation>'+
                     '<Name>United States of America</Name>'+
                  '</Country>'+
                  '<AddressKey>95035797600</AddressKey>'+
                  '<Parsed>'+
                     '<StreetName></StreetName>'+
                     '<AddressRange></AddressRange>'+
                     '<Suffix></Suffix>'+
                     '<Direction>'+
                        '<Post></Post>'+
                        '<Pre></Pre>'+
                     '</Direction>'+
                     '<Suite>'+
                        '<Range></Range>'+
                        '<Name></Name>'+
                     '</Suite>'+
                     '<PrivateMailbox>'+
                        '<Name></Name>'+
                        '<Range></Range>'+
                     '</PrivateMailbox>'+
                     '<Garbage></Garbage>'+
                     '<RouteService></RouteService>'+
                     '<LockBox></LockBox>'+
                     '<DeliveryInstallation></DeliveryInstallation>'+
                  '</Parsed>'+
               '</Address>'+
           '</Record>'+
         '</doAddressCheckResult>'+
      '</doAddressCheckResponse>'+
   '</s:Body>'+
'</s:Envelope>';

  @isTest 
     public static void testmethod1(){
         test.startTest();
         
     		Dol_AddressValidationService.validateAddress('501 MURPHY RANCH RD','','MILPITAS', 'CA', '95035');
          test.stopTest();
  }
  
    @isTest 
     public static void testmethod2(){
         Account acc = new Account(name = 'testaccount');
         insert acc;
         contact con = new contact(LastName = 'test Last' , Accountid = acc.id);
         insert con;
         test.startTest();
     		Dol_AddressValidationService.getObjAPI(con.id);
         	MUSW__Parcel__c parcelobj = new MUSW__Parcel__c();
         	Dol_AddressValidationService.getStates(parcelobj, 'MUSW__State__c');
         	Dol_AddressValidationService.saveAddress('501 MURPHY RANCH RD,apt 286,MILPITAS,CA,95035,United States',false, con.id,'');
        Dol_AddressValidationService.saveAddress('501 MURPHY RANCH RD,apt 286,MILPITAS,CA,95035,United States',TRUE, con.id,'');
          test.stopTest();
  }
  
}