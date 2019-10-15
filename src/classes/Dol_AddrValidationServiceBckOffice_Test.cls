@isTest
public class Dol_AddrValidationServiceBckOffice_Test{
    public static String responsebody = DOL_AppConstants.NULL_EMPTY_STRING + '<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">'+
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
         
        Dol_AddressValidationServiceBckOffice.validateAddress('501 MURPHY RANCH RD','','MILPITAS', 'CA', '95035');
          test.stopTest();
  }
  
    @isTest 
     public static void testmethod2(){
         Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'testaccount');
         insert acc;
         contact con = new contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'test Last' , Accountid = acc.id, Unique_ID_To_Provide__c  = 'SSN');
         insert con;
        
         MUSW__Parcel__c par = new MUSW__Parcel__c (MUSW__Street2__c= DOL_AppConstants.NULL_EMPTY_STRING + '501 MURPHY RANCH RD',MUSW__City__c= DOL_AppConstants.NULL_EMPTY_STRING + 'MILPITAS',MUSW__State__c= DOL_AppConstants.NULL_EMPTY_STRING + 'CA',MUSW__Post_Zip_Code__c= DOL_AppConstants.NULL_EMPTY_STRING + '95035',
                                    Country__c= DOL_AppConstants.NULL_EMPTY_STRING + 'United States');
         insert par;
         
         test.startTest();
        Dol_AddressValidationServiceBckOffice.getObjAPI(con.id);
          MUSW__Parcel__c parcelobj = new MUSW__Parcel__c();
          Dol_AddressValidationServiceBckOffice.getStates(parcelobj, 'MUSW__State__c');
          Dol_AddressValidationServiceBckOffice.getCountyValue('WA', 'TACOMA');
          Dol_AddressValidationServiceBckOffice.getCountyValue('CA', 'TACOMA');
          Dol_AddressValidationServiceBckOffice.saveAddress('501 MURPHY RANCH RD,MILPITAS,CA,95035,United States',false, true,'Asotin',acc.id);
          Dol_AddressValidationServiceBckOffice.saveAddress('501 MURPHY RANCH RD,MILPITAS,CA,95035,United States',false, true,'Asotin',con.id);
          Dol_AddressValidationServiceBckOffice.saveAddress('231 WEST,apt 286,CINCINNATI,OH,45202,United States',true, false,'Asotin',acc.id);
          Dol_AddressValidationServiceBckOffice.saveAddress('231 WEST,apt 286,CINCINNATI,OH,45202,United States',true, false,'Asotin',con.id);
          test.stopTest();
  }
  
}