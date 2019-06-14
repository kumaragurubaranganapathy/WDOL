({
    
    doInit: function(component, event) {
        try {
            var cmpId = this.getInt(component.getGlobalId());/* RD: defect 14735 */
            component.set('v.cmpId', cmpId);
        } catch(e) { 
            this.consoleLog(e.stack, true); 
        }
    },
    
   
    doRender : function(component, event) {
        try {
            var cmpId = this.getInt(component.getGlobalId());/* RD: defect 14735 */            
            var div = document.querySelector('.trim-line-' + cmpId);
           
            if(div){
                var originalContent = div.textContent;
                var linesAllowed = component.get('v.noOfLines');
                
                this.trim(div, originalContent, linesAllowed);
                
                var that = this;
                window.addEventListener('resize', function() {
                    that.trim(div, originalContent, linesAllowed)
                });
            }
        } catch(e) { 
            this.consoleLog(e.stack, true); 
        }
    },
    
    
    trim: function(div, originalContent, linesAllowed) {
        try {
            var didWeTrim = false;
            div.textContent = originalContent;
            
            if(getComputedStyle(div).height && this.getInt(getComputedStyle(div).lineHeight)){
                var lines = this.getInt(getComputedStyle(div).height) / this.getInt(getComputedStyle(div).lineHeight);
                
                while (lines > linesAllowed) {
                    div.textContent = div.textContent.substring(0, div.textContent.length - 1);
                    didWeTrim = true;
                    lines = this.getInt(getComputedStyle(div).height) / this.getInt(getComputedStyle(div).lineHeight);
                }
                if (didWeTrim) {
                    div.textContent = div.textContent.substring(0, div.textContent.length - 3) + '...';
                }
            }
        } catch(e) {
            this.consoleLog(e.stack, true); 
        }
    },
    
    
    getInt: function(str) {
        try {
            return parseInt(str.match(/\d+/)[0], 10);
        } catch(e) { 
            this.consoleLog(e.stack, true); 
        }
    }
})