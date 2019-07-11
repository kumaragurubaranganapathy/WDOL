({
	onRender : function(component, event, helper) {
	    
	    console.log('........onRender..........');

		var relatedSObject_Id = component.get("v.recordID");
		
		var relatedSobjectName = component.get("v.relatedSobjectName");
		
		console.log('doInit.......'+relatedSObject_Id+'.........'+relatedSobjectName);
		
	 	helper.fetchRelatedEmploymentHistoryRecords(component, event, helper, relatedSObject_Id, relatedSobjectName);
		
	//	helper.fetchRelatedEducationalHistoryRecords(component, event, helper, relatedSObject_Id, relatedSobjectName);
	}
})