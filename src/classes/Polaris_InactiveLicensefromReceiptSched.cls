global class Polaris_InactiveLicensefromReceiptSched implements Schedulable {

    global void execute(SchedulableContext sc){
        if(! Dol_IntegrationUtil.isBatchRunning('Polaris_InactiveLicensefromReceiptBatch')){
            Polaris_InactiveLicensefromReceiptBatch batch = new Polaris_InactiveLicensefromReceiptBatch();
            Database.executeBatch(batch);
        }
    }
}