/*************************************************************************************************************
** User Story: 
**************************************************************************************************************
** Name             : dataimportqueueable
** Description      :  
** Version          : 1.0
** Built By         : 
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
** Modification Log:
**--------------------------
** Developer                         Date                    Version                      Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**
** Aishwaria Rangineni              11/15/2017                2.0             Added comments and indented the code
**
**
** Review Log:
**---------------
** Reviewer                  Date           Version               Description
**-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
**
*************************************************************************************************************/


global class dataimportqueueable implements Queueable {

    global String body2, parent1,child1;
    public dataimportqueueable(String child,String parent, String  body){
       parent1= parent; 
        child1= child;
        body2= body;
    }
    public void execute(QueueableContext context) {
                   DataMigrationUtil datainstance = new DataMigrationUtil(child1,parent1);
                    List<Sobject> objectsDeserialized = (List<Sobject>) JSON.deserialize(body2, List<Sobject>.class);
                    System.debug('objectsDeserialized '+objectsDeserialized);
        if(objectsDeserialized.size()!=0){
                         datainstance.insertRecords(objectsDeserialized, 50000);  
                    } 
    }
    
}