({
  doInit: function(component, event, helper) {
      var news=[
          {
              'title':'Washington driver’s licenses, ID cards to change on July 1',
              'content' :'Some Washington driver’s licenses will have a new look starting July 1, a result of the state’s decision to find a way to comply with the federal Real ID law…'
          },
          {
              'title':'Global revenue from licensed goods and services reaches USD 271.66 bn',
              'content' :'Retail and related revenue generated globally by the trademark licensing business in 2017 rose 3.3% to US$271.6B, according to results from the Annual Global Licensing Industry Survey…released today by LIMA. Royalty revenue from sales of licensed merchandise and services rose 2.6% to $14.5 billion.'
          },
          {
              'title':'U.S. Department of Labor awards USD 7 million to support occupational licensing reform',
              'content' :"As part of the U.S. Department of Labor's ongoing efforts to encourage occupational licensing reform, the Department today announced the recipients of $7 million in grants.. to help states review and streamline their occupational licensing rules."
          }
      ];
      component.set("v.newsItems",news);
   var action = component.get('c.getLabel');
   action.setCallback(this,function(response){
    var state = response.getState();
      if (state === "SUCCESS") {
    component.set('v.customLblMap',response.getReturnValue());
   }
});
   $A.enqueueAction(action);
},
 
})