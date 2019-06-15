({
  init: function(cmp) {

        var currentValue = cmp.get("v.value");
        if (!$A.util.isEmpty(currentValue)) {
          currentValue = currentValue.split(';');
        }
        var defaultValue = cmp.get("v.defaultValue");
        if (!$A.util.isEmpty(defaultValue)) {
          defaultValue = defaultValue.split(';');
        }
        var actualCmp = $A.getComponent(cmp.getGlobalId());
        var action = actualCmp.get("c.getPicklistValues");
        action.setParams({
          'sObjectName' : cmp.get("v.sobjectName"),
          'fieldName' : cmp.get("v.fieldName")
        });
        action.setCallback(this, function(response){

          if (response.getState() === 'SUCCESS' && cmp.isValid()) {


            var choices = response.getReturnValue();
            var options = [];
            if (cmp.get("v.multiple") === false) {
              options.push({'class' : 'optionClass', 'label' : 'Please select', 'value' : null});
              if (cmp.get("v.required")) {
                options[0].disabled = true;
              }
            } else { // if multiple
              var select = cmp.getElement();
              if (select)
                select.setAttribute('size', '4'); // need to manually set the size of ui:inputSelect because it doesn't do it automatically like html select would
            }

            choices.forEach(function(ch){
              var o = {
                'class' : 'optionClass', 
                'label' : ch,
                'value' : ch
              };
              if (!$A.util.isEmpty(currentValue) && currentValue.includes(ch)) {
                o.selected = true;
              }

              if ($A.util.isEmpty(currentValue) && !$A.util.isEmpty(defaultValue) && defaultValue.includes(ch)) {
                o.selected = true;
              }
              options.push(o);
            });
            cmp.set("v.options", options);
            // this is from the ui:inputSelect code
            if ($A.util.isEmpty(cmp.get("v.options")) && !$A.util.isEmpty(cmp.get("v.body"))) {
                cmp.set("v.renderBody", true);
            }
        }
        });
       
      $A.enqueueAction(action);   

  },

})