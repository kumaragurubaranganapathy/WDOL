<aura:application access="global" extends="force:slds">

    <!-- URL Parameters -->
   
    <aura:attribute name="mode" type="String" description="Set as a URL attribute, allowing the Checklist to be put into Read Mode" default="" access="global"/>
    <aura:attribute name="pid" type="String" default="" description="Comes from the url of the page"  access="global"/>
    <aura:attribute name="retURL" type="String" description="Return URL can be specified as a url parameter on loading of the checklist. Fallback is backURL, which if also not provided, 2nd fallback is parentId" />
    <aura:attribute name="backURL" type="String" description="If provided, will be used as the destination of the Back link. If not provided, back link will direct to parentId." />
    <aura:attribute name="isIE11" type="Boolean" description="a flag to indicate if the current browser is ie11 if so we block the component from display"/>
    
    <aura:handler name="init" value="{!this}" action="{!c.onInit}"/>
    
    <aura:if isTrue='{!not(v.isIE11)}'>
    	<BGCK:QuestionChecklistComponent pid="{!v.pid}" />
        <aura:set attribute="else">
            <div style="height: 640px;">
              <section role="dialog" tabindex="-1" aria-labelledby="modal-heading-01" aria-modal="true" aria-describedby="modal-content-id-1" class="slds-modal slds-fade-in-open">
                <div class="slds-modal__container">
                  <header class="slds-modal__header">
                    <h2 id="modal-heading-01" class="slds-text-heading_medium slds-hyphenate">Update Your Browser</h2>
                  </header>
                  <div class="slds-modal__content slds-p-around_medium" id="modal-content-id-1">
                   	  <p>You're using a web browser that isn't supported by the application. To ensure all features work as expected, please switch to a 
                          <a href="https://help.salesforce.com/articleView?id=getstart_browsers_sfx.htm&amp;type=5">supported browser</a>.
                      </p>
                  </div>
                </div>
              </section>
              <div class="slds-backdrop slds-backdrop_open"></div>
            </div>
        </aura:set>
    </aura:if>
</aura:application>