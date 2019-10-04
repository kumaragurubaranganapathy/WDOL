@isTest(seeAllData=true)
public class Dol_AddressValidationService_Test{
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
         
     		Dol_AddressValidationService.validateAddress('501 MURPHY RANCH RD','','MILPITAS', 'CA', '95035');
         	Dol_AddressValidationServiceBckOffice.validateAddress('501 MURPHY RANCH RD','','MILPITAS', 'CA', '95035');
          test.stopTest();
  }
  
    @isTest 
     public static void testmethod2(){
         Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'testaccount');
         insert acc;
         contact con = new contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'test Last' , Accountid = acc.id);
         insert con;
         test.startTest();
     		Dol_AddressValidationService.getObjAPI(con.id);
         	MUSW__Parcel__c parcelobj = new MUSW__Parcel__c();
         	Dol_AddressValidationService.getStates(parcelobj, 'MUSW__State__c');
         	Dol_AddressValidationServiceBckOffice.getStates(parcelobj, 'MUSW__State__c');
         	Dol_AddressValidationServiceBckOffice.getCountyValue('WA', 'Washington');
         	Dol_AddressValidationService.saveAddress('501 MURPHY RANCH RD,apt 286,MILPITAS,CA,95035,United States',false, con.id,'');
        	Dol_AddressValidationServiceBckOffice.saveAddress('501 MURPHY RANCH RD,MILPITAS,CA,95035,United States',false,TRUE,'', acc.id);
         	
         //string selectedAddress,Boolean isAptInfo,Boolean isAddrValidated, String countyValue,String parentId
          test.stopTest();
  }
    @isTest 
     public static void testmethod3(){
         Account acc = new Account(name = DOL_AppConstants.NULL_EMPTY_STRING + 'testaccount');
         insert acc;
         contact con = new contact(LastName = DOL_AppConstants.NULL_EMPTY_STRING + 'test Last' , Accountid = acc.id);
         insert con;
         MUSW__Parcel__c parcel = new MUSW__Parcel__c();
         parcel.Primary_Account__c = acc.id;
         parcel.Contact__c = con.id;
         parcel.MUSW__Primary_Contact__c = con.id;
         parcel.MUSW__Street2__c ='501 MURPHY RANCH RD';
         parcel.MUSW__City__c= 'MILPITAS';
         parcel.MUSW__City__c= 'MILPITAS';
         parcel.MUSW__State__c= 'CA';
         parcel.MUSW__Post_Zip_Code__c= '95035'; 
         parcel.Country__c = 'United States';
         insert parcel; 
         //List<MUSW__Parcel__c> existingParcel = [SELECT id,Account__c,Contact__c,Primary_Account__c ,MUSW__Primary_Contact__c ,MUSW__Unit__c,County__c ,Melissa_Address_Verified__c  from MUSW__Parcel__c where MUSW__Street2__c =:addres1 AND MUSW__Street2__c != null AND MUSW__City__c=:city AND MUSW__City__c !=null AND MUSW__State__c=:state AND MUSW__State__c!= null AND MUSW__Post_Zip_Code__c=:zip AND MUSW__Post_Zip_Code__c != null AND Country__c=:country AND Country__c != null Limit 1];
                
         test.startTest();
         	Dol_AddressValidationServiceBckOffice.getCountyValue('CA', 'Milpitas');
     		Dol_AddressValidationServiceBckOffice.saveAddress('501 MURPHY RANCH RD,apt 286,MILPITAS,CA,95035,United States',TRUE,TRUE,'', acc.id);
         	Dol_AddressValidationServiceBckOffice.saveAddress('501 MURPHY RANCH RD,apt 286,MILPITAS,CA,95035,United States',TRUE,TRUE,'', con.id);
            Dol_AddressValidationServiceBckOffice.saveAddress('501 MURPHY RANCH RD,MILPITAS,CA,95035,United States',false,false,'', acc.id);
          test.stopTest();
  }
  
}