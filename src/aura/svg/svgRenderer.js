({
    render: function(component, helper) {
        //grab attributes from the component markup
        var classname = component.get("v.class");
        var xlinkhref = component.get("v.xlinkHref");
        var ariaHidden = component.get("v.ariaHidden");

        //verify the href safely points to a static resource
        if (!xlinkhref.startsWith("/resource/")) {
            console.error("You may only load SVG sprites coming from a static resource");
            return;
        }

        //return an svg element w/ the attributes
        var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        svg.setAttribute("class", classname);
        svg.setAttribute("aria-hidden", ariaHidden);
        var use = document.createElementNS("http://www.w3.org/2000/svg", "use");
        use.setAttributeNS("http://www.w3.org/1999/xlink", "href", xlinkhref);
        svg.appendChild(use);
        return svg;
    }
})