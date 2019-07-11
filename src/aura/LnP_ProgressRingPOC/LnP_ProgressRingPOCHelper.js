({
	init : function(component, event) {
		this.update(component, event);
	},
    update : function(component, event) {
        var percent = component.get('v.percent') / 100;
        
        var isLong = percent > 0.5 ? 1 : 0;
        var arcX = Math.cos(2 * Math.PI * percent);
        var arcY = Math.sin(2 * Math.PI * percent);
        var path = 'M 1 0 A 1 1 0 ' + isLong + ' 1 ' + arcX + ' ' + arcY + ' L 0 0';
        
        component.set('v.svg', '<svg viewBox="-1 -1 2 2"><path class="slds-progress-ring__path" d="' + path + '" /></svg>');
    },
    percentageChange : function(component, event){
        var percentage = event.getSource().get("v.value");
        component.set("v.percent", percentage);
        this.update(component, event);
    }
})