@font-face{
    font-family:'Merriweather-Regular';
    src:url(/lightningwashington/resource/Merriweather/Merriweather-Regular.ttf); /*1560421450000*/
}
@font-face{
    font-family:'SourceSansPro-Regular';
    src:url('/lightningwashington/resource/Source_Sans_Pro/Source_Sans_Pro/SourceSansPro-Regular.ttf');
}
button[title="View File Details"] {
    display: none;
}
button[title="Upload New Version"] {
    display: none;
}
.forceToastMessage{
    width: 615px;
    height: 82px;
}
.uiMessage .warning{
    border-color:none !important;
}
.slds-theme--warning{
   background-color: #fff1d2;
  
   border-left: 10px solid #fdb81;
}
.slds-theme--error{
  background-color: #f9dede;
  
  border-left: 10px solid #cd2026;
}
.slds-theme--success{
   background-color: #e7f4e4;
   
   border-left: 10px solid #2e8540;
}
.slds-theme--info{
   background-color: #e1f3f8;
   
   border-left: 10px solid #00bfe7;
}
.toastTitle{
  font-weight:bold;
  color:#1b1c1a;
  font-family:'Merriweather-Regular';
  
}
.toastMessage{
   color:#212121;
   font-family:'SourceSansPro-Regular';
   font-weight: normal;
  font-style: normal;
  font-stretch: normal;
  line-height: 1.53;
  letter-spacing: normal;

}
.slds-theme--error .slds-icon_small,.slds-theme--success .slds-icon_small,.slds-theme--warning .slds-icon_small,.slds-theme--info .slds-icon_small{
   fill:black;
   margin-top:6px;
}
.slds-button--icon-inverse,.slds-button--icon-border-inverse,.forceToastMessage .slds-button{
    color:black;
    border:none;
}
/* uiMessages styles*/

.uiMessage.warning{
    background-color: #fff1d2 !important;
    border:transparent;
    border-left: 10px solid #fdb81e;
   
}
.uiMessage.error{
    background-color: #f9dede !important;
    border:transparent;
    border-left: 10px solid #cd2026;
    
}
.uiMessage.info{
    background-color: #e1f3f8 !important;
    border:transparent;
    border-left: 10px solid #00bfe7;
   
}
.uiMessage.success{
    background-color: #e7f4e4 !important;
    border:transparent;
    border-left: 10px solid #2e8540;
    
}
.uiMessage{
    margin:0 !important;
    padding:10px !important;
}
.uiBlock .bBody{
   overflow:visible !important;
}
