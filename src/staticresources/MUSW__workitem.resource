window.WorkItemVO = (function() {
    var getUniqueId = function() {
        return 'id-' + Math.random().toString(36).substr(2, 16);
    };

    var wi =  function(existingWorkItemVO, masterWorkItemVO){
        var workItemVO = !$A.util.isEmpty(existingWorkItemVO) ? existingWorkItemVO : masterWorkItemVO;
        for(var key in workItemVO){
            this[key] = workItemVO[key];
        }
    
        this.isDirty = false;
        this.deletableWorkItemIds= [];

        if(!$A.util.isEmpty(existingWorkItemVO)){
            this.existingWorkItems = JSON.parse(JSON.stringify(existingWorkItemVO.workItem));
        }
        if(!$A.util.isEmpty(masterWorkItemVO)){
            this.masterWorkItemIds = masterWorkItemVO.masterWorkItemIds;
            this.masterWorkItems = JSON.parse(JSON.stringify(masterWorkItemVO.workItem));
            this.isRequired = masterWorkItemVO.isRequired;
            this.isDeletable = masterWorkItemVO.isDeletable;
            this.isClonable = masterWorkItemVO.isClonable;
        }
    };
    wi.prototype.deleteWorkItem = function(){
        if(!this.isTemplate){
            // track deletable work item id if the work item exist
            if(!$A.util.isEmpty(this.existingWorkItems)){
                this.deletableWorkItemIds = this.existingWorkItems.map(function(wi){
                    return wi.Id;
                });
            }
            //reset the workitem to the template work items
            this.workItem = JSON.parse(JSON.stringify(this.masterWorkItems));
            this.isTemplate = true;
            this.isDirty = false;
        }
    };

    wi.prototype.getDeletableWorkItemIds = function() {
        var idsToDelete = this.deletableWorkItemIds;
        if (this.isAggregate) {
            this.workItem.forEach(function(item){
                if (item.MUSW__Quantity__c < 1 && item.Id != null) {
                    idsToDelete.push(item.Id);
                } 
            });
        } 
        return idsToDelete;
    }

    wi.prototype.getUpsertableWorkItemRecords = function() {
        var workItemRecords = [];
        if (! this.isTemplate) {
            if (this.isAggregate) {
                workItemRecords = this.workItem.filter(function(item){
                    return item.MUSW__Quantity__c > 0;
                });
            } else {
                workItemRecords = this.workItem;
            }
        }
        return workItemRecords;
    }

    wi.prototype.getCost = function() {
        var cost = 0;
        if (! this.isTemplate) {
            cost = this.workItem.reduce(function(total, item){
                var val = (item.MUSW__Value_Per_Unit__c >= 0) ? item.MUSW__Value_Per_Unit__c : 0;
                var quantity = (item.MUSW__Quantity__c >= 0) ? item.MUSW__Quantity__c : 0;
                total = total + val * quantity;
                return total;
            }, 0);
        }
        this.cost = cost;
        return cost;
    }

    wi.prototype.addWorkItem = function(){
        if(this.isTemplate){
            this.isTemplate = false;
        }
    };
    
    wi.prototype.updateWorkItems = function(workitems){
        this.isDirty = true;
        this.workItem = workitems;
    };

    wi.prototype.copy = function() {
        var copiedWI = Object.create(WorkItemVO.prototype);
        copiedWI =  Object.assign(copiedWI, this);
        copiedWI.identifier = getUniqueId();
        copiedWI.existingWorkItems = undefined;
        copiedWI.workItem = JSON.parse(JSON.stringify(this.masterWorkItems));
        copiedWI.isDirty = false;
        copiedWI.isDeletable = true;
        copiedWI.isRequired = false;
        return copiedWI;
    };

    wi.prototype.validateItems = function(workItems){
        var isValid;
        var errorMessage = this.errorMessage;
        if ($A.util.isEmpty(errorMessage)) {
            isValid = true;
            if(!this.isTemplate){
                if($A.util.isEmpty(workItems)){
                    isValid = false;
                    errorMessage = "Invalid data, cannot validate empty work items.";
                }

                var validateIndex = workItems.findIndex(function(item){
                    return item.MUSW__Quantity__c > 0;
                });
                var isZeroTotalWorkItemQuantity = validateIndex < 0;
                if(isValid && isZeroTotalWorkItemQuantity){
                    if(this.isRequired && this.isAggregate){
                        isValid = false;
                        errorMessage = "At least one of the options should have a value.";
                    }else if(this.isRequired){
                        isValid = false;
                        errorMessage = "Quantity must be at least one.";
                    }
                }
            }
            this.errorMessage = errorMessage;
        } else {
            isValid = false;
        }
        return {
            "identifier" : this.identifier,
            "isValid" : isValid,
            "errorMessage" : errorMessage
        };
    };

    wi.prototype.validate = function(){
        return this.validateItems(this.workItem);
    };

    return wi;
}());


window.WorkItemDetailVO = (function(){
    var detailVO = function(workItemVO){
        var wi = workItemVO;
        this.title = wi.displayName;
        this.metaData = {
            identifier : wi.identifier,
            category : wi.category,
            displayName :  wi.displayName,
            isAggregate : wi.isAggregate,
            isRequired : wi.isRequired,
            isDeletable : wi.isDeletable,
            isClonable : wi.isClonable
        };
        this.cost = workItemVO.getCost();
        var inputFields;
        if (! wi.isAggregate) { 
            inputFields = wi.fields;
            //need to clone the item not pass by reference
            this.data = JSON.parse(JSON.stringify(wi.workItem[0]));
            this.prefix = wi.workItem[0].MUSW__Quantity__c + " x ";
            this.inputFields = inputFields;
        } else {
            inputFields = wi.workItem.map(function(workItem){
                return {
                    label: workItem.MUSW__Description__c,
                    apiName: workItem.MUSW__Description__c,
                    type: "number"
                };
            });
            this.inputFields = inputFields;
            this.data = wi.workItem.reduce(function(result, item){
                if(item.MUSW__Quantity__c && item.MUSW__Quantity__c>0){
                    result[item.MUSW__Description__c] = item.MUSW__Quantity__c;
                }
                return result;
            },{});
        }
        var data = this.data;
        this.subtitle = inputFields.reduce(function(result, field) {
            if (field.apiName !== "MUSW__Quantity__c" && ! $A.util.isEmpty(data[field.apiName])) {
                result = result + data[field.apiName] + " " + field.label + ", ";
            }
            return result;
        }, "").trim();
        var lastChar = this.subtitle.slice(-1);
        if (lastChar == ',') {
            this.subtitle = this.subtitle.slice(0, -1);
        }
        this.isEditMode = false;
    };
    return detailVO;
})();