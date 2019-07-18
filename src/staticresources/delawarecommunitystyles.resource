:root {
  --blue: #03528b;
  --black: #000000;
  --mustard: #edaa1e;
  --white: #ffffff;
  --grey: #c7c8c1;
  --darkgrey: #666666;
  --btnblue: #337ab7;
  --skyblue: #4bc1d2;
  --green: #008000;
  --lightsky: #87bafa7a;
}
.btn{
    background-color: var(--btnblue);
    border-color: var(--btnblue);
    color: var(--white);
	width: 200px;
}
.btn:hover{
	font-weight: bold;
}
.center-block {
    margin-right: auto;
    margin-left: auto;
}
.slds-has-error .slds-form-element__help{
	float: right;
}
.italic{
	font-style: italic;
}
.slds-form-element__legend{
	font-size: 16px;
    font-weight: normal;
}
.field-item{
    padding: 0px 25px 25px 25px;           
}
.pull-right{
    float: right;
}
@media all{
	div{
		font-size:16px;
	}
	p{
		font-size:16px;
	}
	body{
		font-size:16px;
	}
	input{
		font-size:16px;
	}
	label{
		font-size:16px;
	}
}
input::-webkit-input-placeholder {
    font-size: 16px;
	color: #c7c8c1;
    font-style: oblique;
}
a:hover{
	font-weight: bold;
}