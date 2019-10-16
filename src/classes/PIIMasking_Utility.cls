/*************************************************************************************************************
** User Story: 31137 TECH: Create a new batch interface using Apex to loop over sObjects defined in Custom Metadata
**************************************************************************************************************
** Class Name    : PIIMasking_Utility
** Description   : Sets the batch job to be kicked off the masking the object fields specified in the VF Page.
**                  Classname: PIIMasking_MainInterface_Constructor.cls is the controller for the VFPage.
** Version       : 1.0
** Built By      : Masood Mahmood
**------------------------------------------------------------------------------------------------------------
** Modification Log:
**------------------
** Developer                         Date                    Version                     Description
**------------------------------------------------------------------------------------------------------------
** Masood Mahmood                   08/23/2016                  1                        Created
** Rohit Gowrishetty                10/26/2017                  1                        Edited for Custom Labels
** Review Log:
**---------------
** Reviewer                         Date                    Version                      Description
** Kaistha, Aayush                  09/15/2016                   1                        Reviewed
**------------------------------------------------------------------------------------------------------------
**
**  **********************************************************************************/

global class PIIMasking_Utility {
    String sObjectName, fieldname;
    Set<String> fieldnames = new Set<String> ();    
    global static final boolean isSandbox = [select Id, IsSandbox from Organization Limit 1][0].issandbox;
    
    public PIIMasking_Utility(String sObjectName, Set<String> fname) {
        this.sObjectName = sObjectName;
        this.fieldnames= fname;
    }
    
    /**
    * Method name  : maskFields
    * Description  : Recieves the object fields specified in the VF Page to be masked 
    *                and invokes PIIMasking_Batch_MainInterface.execute() to schedule the batch job.
    * Return Type  : void
    * Parameter    : Database.BatchableContext BC, List<sObject> scope
    **/
    public void maskFields() {
        if(isSandbox){ //Run only in the sandbox org.
            try{             
                String queryStr = DOL_AppConstants.NULL_EMPTY_STRING + 'SELECT ';
                Integer size = fieldnames.size();
                for(String a :  fieldnames){
                    size= size-1;
                    if(size==0){
                        queryStr += a;
                    }
                    else{
                        queryStr += a +',';
                    }
                }
                queryStr += ' from ' + sObjectName;
              //  system.debug('PIIMasking_Utility.maskFields()...Query String===>>>' + queryStr);
                PIIMasking_Batch_MainInterface batch = new PIIMasking_Batch_MainInterface(queryStr, sObjectName,fieldnames);
                String name = label.Str_Job_run_on   + ' ' + sObjectName +' '+label.Str_run_at+' '+ system.now();
                //System.scheduleBatch(batch, name, 0);
                Database.executeBatch(batch, 1000);
            }
            catch(System.QueryException qe){
               // System.debug('PIIMasking_Utility.maskFields() exception ===>>> ' + qe.getmessage() + '\n' +
                         //   'PIIMasking_Utility.maskFields() exception ===>>> ' + qe.getLineNumber());
            }
            finally{
              //  System.debug('PIIMasking_Utility.maskFields() finally clause. ');
            }
        }
    }  
}