trigger updateEndorsementStatusOnProviderDelete  on Electronic_Notary_Provider_Information__c (before delete) {
    
    Map<Id,List<Electronic_Notary_Provider_Information__c>> mapProvider = new Map<Id,List<Electronic_Notary_Provider_Information__c>>(); 
    Set<Id> updateEndoId = new Set<Id>();
    Set<Id> endoId = new Set<Id>();
    for(Electronic_Notary_Provider_Information__c provider : Trigger.old)
    {
        endoId.add(provider.Endorsement__c);
        
    } 
       List<Electronic_Notary_Provider_Information__c> lstprov = [SELECT id,Endorsement__c FROM Electronic_Notary_Provider_Information__c where Endorsement__c IN:endoId ];
       system.debug('lstprov :'+lstprov );
       for(Electronic_Notary_Provider_Information__c provider : lstprov)
       {
           if(mapProvider.containsKey(provider.Endorsement__c))
        {
            List<Electronic_Notary_Provider_Information__c > lstProvider = mapProvider.get(provider.Endorsement__c);
            lstProvider.add(provider);
            mapProvider.put(provider.Endorsement__c,lstProvider);
        }
        else
        {
            mapProvider.put(provider.Endorsement__c,new List<Electronic_Notary_Provider_Information__c>{provider});
        }
       }
    system.debug('mapProvider :'+mapProvider);
    for(Id endoId : mapProvider.keyset())
    {
        if(mapProvider.get(endoId).size() == 1)
        {
            updateEndoId.add(endoId);
        }
    }
    system.debug('updateEndoId :'+updateEndoId);
    if(!updateEndoId.isEmpty())
    {
        List<Endorsement__c> lstupdateEndo = [SELECT id,Status__c FROM Endorsement__c where id IN: updateEndoId];
        system.debug('lstupdateEndo  :'+lstupdateEndo );
        for(Endorsement__c endo : lstupdateEndo)
        {
            endo.Status__c  = 'Remove';
        }
        update lstupdateEndo;
    }
    
}