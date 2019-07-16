/*************************************************************************************************************
**
**************************************************************************************************************
** Class Name    : DataObjectService
** Description   : This class exposes a service on the source Org that's called from the target Org to
**                  transmit the data from the source to the target. The target is supposed to call this
**                  service with request and appending the object name in the URL, shown below
**                  URL mapping after the endpoint: "/DataService/<EnterObjectNameHere>"
** Version       : 1.0
** Built By      : 
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/

@RestResource(urlMapping = '/DataService/*')
global class DataObjectService  {

    /**
    * Method name  : doGet
    * Description  : This method is called when an HTTP Get request is recieved.
    * Return Type  : Returns the SObject records in the JSON format of the specified object name in the URL mapping.
    *                If the object name is invalid, null value is returned and the response status code is set to 404.
    * Parameter    : None.
    **/
    @HttpGet
    global static SOBJECT [] doGet() {
        System.debug('DataObjectService.doGet() method executed to get the object data ... ');
        ObjectWrapper response = new ObjectWrapper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String result = ''; //Rest result message;

        String sObjectName = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
        if (Schema.GetGlobalDescribe().containsKey(sObjectName)) { //If the object name is valid.

            Map<String, Schema.SObjectField> M = //Dynamically get the SObject's fields and build query string.
                Schema.GetGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();

            String fieldString = '';
            Integer counter = 1;
            for (String fieldName : M.keySet()) {
                Schema.DescribeFieldResult dfr = M.get(fieldName).getDescribe();
                System.debug(fieldname);
                if (! dfr.isCalculated()  ) {
                    if (counter == M.size()) {
                        fieldString += fieldName ;
                        break;
                    } else {
                        fieldString += fieldName + ', ';
                    }
                } else  if (dfr.isCalculated() && fieldName == label.API_record_type_name) {
                    if (counter == M.size()) {
                        fieldString += fieldName ;
                        break;
                    } else {
                        fieldString += fieldName + ', ';
                    }
                }
                else if(dfr.isCalculated()&& (fieldName=='External_Id_of_Parent__c'||fieldname=='External_Id_of_Question__c'))
                {
                     if (counter == M.size()) {
                        fieldString += fieldName ;
                        break;
                    } else {
                        fieldString += fieldName + ', ';
                    }
                }
                if (fieldString.endsWith(', ') && (counter == M.size())) {
                    fieldstring.trim();
                    fieldstring = fieldstring.reverse();
                    fieldstring = fieldstring.replacefirst(',', '');
                    fieldstring.trim();
                    fieldstring = fieldstring.reverse();
                }
                counter++;
            }
            response.objRecords = Database.query('SELECT ' + fieldString + ' FROM ' + sObjectName );
            res.StatusCode = 200;
            res.addHeader(result, 'Succefully found the records of ' + sObjectName);
            return response.objRecords;
        }
        else { //If the object name is invalid.
            res.StatusCode = 404;
            res.addHeader(result, 'Please enter the correct object API name '+sObjectName);
            return null;
        }
    }

    global class ObjectWrapper {
        public List<SObject> objRecords;
        public String status;
        public String message;

        public ObjectWrapper() {
            objRecords = new List<SObject>();
        }
    }
}