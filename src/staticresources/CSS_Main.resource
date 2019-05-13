/*
$total_cols : 0 !global;
$grid-nth-omega : 0;

$base-font-size : 16px;
$grid-gutter: 0;
$grid-padding: 0;
$grid-column-width : 0;
$grid-type : magic;

$breaks : ($total_cols);
*/
@import url(https://fonts.googleapis.com/css?family=Arvo);
*, *:before, *:after {
  -moz-box-sizing: border-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
}
@font-face {
    font-family: raleway-regular;
    src: url(../DDStyle/Fonts/raleway-regular.woff);
}
@font-face {
    font-family: OpenSans-Regular;
    src: url(../DDStyle/Fonts/OpenSans-Regular.woff);
}
@font-face {
    font-family: OpenSans-Semibold;
    src: url(../DDStyle/Fonts/OpenSans-Semibold.woff);
}
/**
These are styles that should be global
*/
/**
Fonts and tag defaults
*/
.serifa {
  font-family: "Serifa", "Arvo", "Rockwell", serif !important;
}

/*Top Level Hack ... Must Match the padding of nav li*/
.glyphicon {
  padding-right: 16px;
}
body,html{
	height:100%;
}
body {
  background-color: #FFFFFF;
  font-size: 14px;
  font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif;
}

h1, h2, h3, h4, h5, h6{
  font-family: "Raleway-Regular", Verdana, Helvetica, sans-serif;
}
h1,h2{
	color: #1d4F81;
}

h1 {
  font-size: 3em;
}
h2 {
  font-size: 2em;
  margin-top: 0px;
}
h3,h5,p {
	color: #222;
}
h3,h4 {
  font-size: 1.25em;
  font-weight: 600;
}
h4 {
  color: #777;
  padding: 15px 0;
}

h5 {
  font-size: 1em;
  font-weight: 600;
}

h6 {
  font-size: 11px;
  font-weight: 600;
  margin-bottom: 5px;
}
p{
	font-size: 1em;
	font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif;
}
/*Mobile only*/
@media (max-width: 767px) {
  h1 {
    font-size: 32px;
  }

  h5 {
    font-size: 14px;
  }
}
hr {
  border-top: 1px solid #f9c118;
  
}

/**
Nav Links
*/
nav > .container {
  max-width: 1000px;
}
.customheader {
	background-color: #074078; 
	width:100%;
}
nav .tablet-nav {
  align-items: flex-end;
  display: flex;
  height: 55px;
  justify-content: space-between;
}

nav .tablet-nav > a {
  float: left;
}

nav .tablet-nav > a > div > span {
  font-size: 1.1em;
}

nav .nav-links {
  align-items: flex-end;
  display: flex;
  height: 100%;
  justify-content: flex-end;
  list-style: none;
  margin-bottom: 0;
  padding: 0;
}

nav .nav-links > li {
  align-items: flex-end;
  display: flex;
  font-size: 14px;
  height: 100%;
  justify-content: center;
  margin: 5px 0 0 10px;
  min-width: 30px;
  padding-bottom: 5px;
  padding-left: 16px;
  text-align: right;
  text-transform: uppercase;
}

nav .nav-links > li.active {
  background-color: #f9c118;
  border-bottom-right-radius: 30%;
  border-bottom-left-radius: 30%;
}

nav .nav-links > li.active > a > span {
  color: #000;
}
nav .nav-links > li.active > a > span strong{
  font-size: 1.25em;
  padding-left: 3px;
  font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif;
}
.nav-links li a {
    color: #fff;
    font-family: "OpenSans-Semibold", Verdana, Helvetica, sans-serif;
}
nav .nav-links > li.shopping-cart {
  background-image: url(../DDStyle/_assets/ic_cart_retina.png);
  background-repeat: no-repeat;
  background-position: 7px 32px;
  background-size: 16px;
}

nav .nav-links > li.active.shopping-cart {
  background-image: url(../DDStyle/_assets/ic_cart_white_retina.png);
}

nav .nav-links > #username-dropdown {
  position: relative;
}
#username-dropdown{
  z-index:10000 !important;
}
nav .nav-links > #username-dropdown > #username-dropdown-content {
  display: none;
}

nav .nav-links > #username-dropdown > #username-dropdown-content.show {
  background-color: #FFFFFF;
  border: 1px solid #BBBBBB;
  display: block;
  height: auto;
  left: -50px;
  padding: 0 8px;
  position: absolute;
  top: 50px;
}

nav .nav-links > #username-dropdown > #username-dropdown-content.show > ul {
  list-style: none;
  text-align: left;
  padding: 12px;
}

nav .nav-links > #username-dropdown > #username-dropdown-content.show > ul > li {
  margin-bottom: 10px;
}

nav .nav-links > #username-dropdown > #username-dropdown-content.show > ul > li:last-child {
  margin-bottom: 0;
}
nav .navUserName{
    color:#FFF;
    font-family: "OpenSans-Semibold", Verdana, Helvetica, sans-serif;
    cursor: pointer;
}
/*Hamburger Icon*/
nav #hamburger-menu {
  color: #AAAAAA;
}

nav #hamburger-menu:hover {
  color: #888888;
  cursor: pointer;
}

label {
  /*font-size: 12px;*/
  font-weight: normal;
}

section {
  padding: 30px 0;
}

/**
Footer
*/
footer {
  padding: 30px 0;
  align-items: center;
  background-color: #074078;
  bottom: 0;
  display: flex;
  height: 100px;
  position: relative;
  color: #fff;
}

/* footer::before {
  content: "";
  border: 3px solid #ef1a2a;
  border-radius: 50%;
  position: absolute;
  left: -30px;
  top: 20px;
  height: 60px;
  width: 60px;
} */

footer .tablet-footer {
  align-items: flex-end;
  display: flex;
  justify-content: space-between;
}

footer .tablet-footer > div {
  float: right;
  font-size: 14px;
}

footer .tablet-footer > .footer-links {
  display: flex;
  justify-content: flex-start;
  list-style: none;
  margin-bottom: 0;
  padding: 0;
  font-family: "OpenSans-Semibold", Verdana, Helvetica, sans-serif;
}

footer .tablet-footer > .footer-links > li {
  font-size: 14px;
  font-weight: 600;
  text-align: right;
  text-transform: uppercase;
  padding-right: 20px;
}
.footer-links li a {
    color: #fff;
}
@media (max-width: 767px) {
  footer {
    height: auto;
  }

  footer .container {
    margin: 0 0 0 65px;
    padding: 0 0 20px 0;
    width: 100%;
  }

  footer .tablet-footer {
    display: block;
    margin: 45px 0 0;
    padding: 0;
  }

  footer .tablet-footer > div {
    width: 100%;
  }

  footer .tablet-footer > .footer-links {
    display: block;
    width: 100%;
  }

  footer .tablet-footer > .footer-links > li {
    text-align: left;
    margin-bottom: 10px;
    width: 100%;
  }
}
/* Prevent text from overlapping red O */
@media (min-width: 768px) and (max-width: 808px) {
  footer .tablet-footer {
    margin-left: 15px;
  }
}
@media (min-width: 992px) and (max-width: 1032px) {
  footer .tablet-footer {
    margin-left: 15px;
  }
}
/**
Display overrides
*/
@media (min-width: 768px) {
  .baseline-flex {
    display: flex;
    align-items: baseline;
  }

  .center-flex {
    display: flex;
    align-items: center;
  }

  .start-flex {
    display: flex;
    align-items: flex-start;
  }
}
/**
Buttons
> Need Active and Hover States for buttons
*/
.btn {
  -webkit-border-radius: 2px;
  -moz-border-radius: 2px;
  border-radius: 2px;
  font-size: 14px;
  min-width: 120px;
  padding: 8px 16px;
}

.btn-primary {
	background-color: #146c9c;
	border-color: #294459;
	color: #fff;
	font-weight: bold;
	border-radius: 5px;
	font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif;
	text-transform: uppercase;
}

.btn-primary:hover {
  background-color: #8d969f;
  border-color: #294459;
  color: #fff;
}

.btn-primary:active {
  background-color: #294459;
  border-color: #294459;
  color: #fff;
}
.btn-primary:focus {
  border: 1px solid #FFFFFF;
}
a.btn-primary:visited {
    color:#FFF;
}
.btn-secondary, a.btn-secondary, a.btn-secondary:visited {
  	background-color: #F9C118;
    border-color: #c1a963;
    border-radius: 5px;
    color: #333;
    font-weight: bold;
    text-transform: uppercase;
}

.btn-secondary:hover, a.btn-secondary:hover {
  background-color: #c7c6c3;
  color: #333;
}

.btn-secondary:active, a.btn-secondary:active {
  background-color: #c7c6c3;
  color: #333;
}
.btn-secondary:focus, a.btn-secondary:focus {
  color: #333;
  border: 1px solid #38000b;
}
.btn-tertiary {
  background-color: #e5e5e2;
  color: #525051;
  border-radius: 5px;
  border: 1px solid #b3b7b9;
  font-weight: bold;
  text-transform: uppercase;
}

.btn-tertiary:hover, .btn-tertiary:active {
  background-color: #c7c6c3;
}
.btn-tertiary:focus {
  border: 1px solid #000000;
}
.btn-dropDownSmall{
    color: #333;
    background-color: #f9c118;
    border-color: #c1a963;
    text-transform: uppercase;
    border-radius: 5px;
    font-weight: bold;
    font-size: 0.7em !important;
}
.btn-dropDownSmall .glyphicon { padding: 0 0 0 5px;}
/**
Colors
*/
/*background-color: #b5dc10; green-progress
background-color: #ff8768; red-progress
background-color: #ef1a2a; red-bright
background-color: #7a0f23; red-dark
background-color: #3b6280; blue
background-color: #6f0016; blue-dark
background-color: #f1f0ed; gray-light
background-color: #eae8e5; gray
background-color: #BBBBBB; gray-dark
background-color: #888888; gray-darker*/
.green-progress {
  background-color: #b5dc10;
}

.yellow-progress {
  background-color: #f6c053;
}

.red-progress {
  background-color: #ff8768;
}

.red-bright {
  background-color: #ef1a2a;
}

.red-dark {
  background-color: #7a0f23;
}

.blue {
  background-color: #3b6280;
}

.blue-dark {
  background-color: #2F4E66;
}

.background-light {
  background-color: #f1f0ed;
}

.background-dark {
  background-color: #eae8e5;
}

.gray-dark {
  background-color: #BBBBBB;
}

.gray-darker {
  background-color: #888888;
}

.font-white {
  color: #ffffff;
}

a {
  color: #0072c6;
}
a:visited {
  color: #0072c6;
}
a:focus,a:hover {
	color: #0072c6;
	text-decoration: underline;
}

a.secondary {
  color: #ffffff;
}

a.secondary:visited {
  color: #ffffff;
}

.row-margin {
  margin-bottom: 20px;
}

.no-padding {
  padding-left: 0 !important;
  padding-right: 0 !important;
  margin-right: 15px !important;
}
.no-leftPadding{
    padding-left: 0px;
}
.label-padding {
  padding-left: 1px;
}

.cancel-link {
  color: #525051;
  display: inline-block;
  font-weight: bold;
  text-decoration: none !important;
  text-transform: uppercase;
  
}

.form-group_n {
  margin-bottom: 15px;
  position: relative;
}

.btn-ghost {
  background-color: transparent;
  border: 1px solid #cccccc;
  color: #525051;
  font-weight: bold;
  text-transform: uppercase;
}

.expand-toggle {
  float: right;
  margin-top: 20px;
  padding: 15px 0 15px 15px;
}
.expand-toggle:before {
  content: '';
  background-image: url(../DDStyle/_assets/ic_carat_down_retina.png);
  background-repeat: none;
  display: block;
  position: relative;
  width: 13px;
  height: 9px;
}
.expand-toggle.open:before {
  content: '';
  background-image: url(../DDStyle/_assets/ic_carat_up_retina.png);
  background-repeat: none;
  display: block;
  position: relative;
  width: 13px;
  height: 9px;
}
.expand-toggle:hover, .glyphicon-trash, #editContainer .glyphicon, .toggeling-icon .glyphicon, .toggeling-icon-address .glyphicon  {
  cursor: pointer;
}
 .business-card .toggeling-icon .glyphicon {
  margin-right: -14px;
  float: right;
}
.toggle-collapse {
  display: none;
}

#style-guide section {
  overflow: hidden;
}

/*Hacking Placeholder for Date Picker*/
input[type="date"]::-webkit-input-placeholder {
  visibility: hidden !important;
}

select {
  display: block;
  width: 100%;
  height: 34px;
  padding: 6px 12px;
  font-size: 14px;
  line-height: 1.42857143;
  color: #555;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  -webkit-border-radius: 4px;
  -moz-border-radius: 4px;
  border-radius: 4px;
}

.btn-white {
  color: #373a3c;
  background-color: #fff;
  border-color: #ccc;
  font-weight: bold;
  text-transform: uppercase;
}
.btn-white:hover {
  color: #373a3c;
  background-color: #e6e6e6;
  border-color: #adadad;
}

.btn-square-icon {
  background-color: transparent;
  padding: 2px 2px 2px 2px;
  border: 0px;
  min-width: 0px;
}

.list-style-none {
  padding: 0;
  list-style: none;
  margin-bottom: 0;
}

.ellipsize {
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

.form-child-panel {
  box-shadow: lightgray 0px 0px 5px;
  border: 1px solid lightgray;
  border-radius: 4px;
  padding: 8px;
  box-shadow: 0px 0px 8px lightgray;
  margin: 8px 0px;
}

.form-textarea-fixed {
  resize: none;
}
.form-control {
	background-color:#fff;
}
.form-control:focus {
/*  border-color: #CCCCCC;
  box-shadow: none;*/
}

.animated-form .required::before {
  content: '*';
  color: #000000;
  position: absolute;
  left: -12px;
}

.animated-form .form-group {
  margin-top: 30px;
  position: relative;
}

.animated-form .form-group > label {
  color: #666;
  font-size: 14px;
  font-weight: 400;
  left: 13px;
  position: absolute;
  top: 7px;
  /* Animate */
  -moz-transition: all 0.3s ease;
  -ms-transition: all 0.3s ease;
  -o-transition: all 0.3s ease;
  -webkit-transition: all 0.3s ease;
  transition: all 0.3s ease;
}

.animated-form .form-group > .animated {
  color: #333; /*#5C5C5C;*/
  font-size: 14px;
  left: 10px;
  top: -22px;
  /* Animate */
  -moz-transition: all 0.3s ease;
  -ms-transition: all 0.3s ease;
  -o-transition: all 0.3s ease;
  -webkit-transition: all 0.3s ease;
  transition: all 0.3s ease;
}

.animated-form .form-group > span {
  position: absolute;
  bottom: 0;
  left: 4px;
  width: 0%;
  height: 2px;
  background: #72a4cb;
  transition: all 0.6s;
}

.form-group-inanimated {
  margin-top: 30px;
  margin-bottom: 15px;
  position: relative;
}
.form-group-inanimated > label {
  position: absolute;
  top: -22px;
  padding-left: 8px;
}
.form-group-inanimated.label-normal > label {
  position: static;
  padding-left: 8px;
}

.animated-form .form-group > .active {
  width: calc(100% - 8px);
}

/* Error States */
.animated-form .error::before {
  color: #FF0000;
}

.animated-form .error > label, .warningText {
  color: #FF0000 !important;
}

.animated-form .error > span {
  background-color: #FF0000;
}

.radioWrapper {
  background-color: #FFFFFF;
  border: 1px solid #DDD;
  display: inline-block;
  margin-top: 10px;
  padding: 5px;
}
.radioWrapper:last-of-type {
  margin-left: 10px;
}
.radioWrapper label, .panel-title label {
  margin-left: 7px;
}

.addedlist {
  background-color: #e5e5e5 !important;
  padding: 15px;
  margin-bottom: 4px;
  border-radius:5px;
}

#results_length, .dataTables_length {
  display: none !important;
}

table.dataTable tbody tr {
  background-color: #FFFFFF;
  font-weight: bold;
  /* height: 55px;*/
} 

table.dataTable.display tbody tr.even > .sorting_1, table.dataTable.order-column.stripe tbody tr.even > .sorting_1 {
  background-color: #FFFFFF !important;
}

table.dataTable.display tbody tr.odd > .sorting_1, table.dataTable.order-column.stripe tbody tr.odd > .sorting_1 {
  background-color: #FFFFFF !important;
}

.dataTables_wrapper .dataTables_info {
  display: none;
}

.squareIconBtnAddr {
  background-color: transparent !important;
}

select[multiple], select[size] {
  -moz-border-radius: 4px;
  -webkit-border-radius: 4px;
  border-radius: 4px;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  color: #222;
  display: block;
  font-size: 14px;
  height: 34px;
  line-height: 1.42857143;
  padding: 6px 12px;
  width: 100%;
}

.animated-form .form-group > .dateOnlyInput {
  position: relative;
  left: 0px;
  background: none;
}

.errorRed {
  color: red;
  width: 100%;
  position: relative !important;
  background: none !important;
  font-size: 12px !important;
}

.multiple-picklist {
  height: auto !important;
}

select[disabled] {
  opacity: 0.5;

}
select[disabled]:hover{
  cursor:not-allowed !important;
}
[disabled].form-control, fieldset[disabled] .form-control{
  cursor:default !important;
}
.reviewsectionerror {
  display: inline-block;
  vertical-align: middle;
}

.reviewsectionerror > div {
 /* background-color: #ff8768;*/
  border-radius: 50%;
  height: 26px;
  margin: 2px;
  position: relative;
  width: 26px;
}

.reviewsectionerror > div > span {
  background-color: #d42031;
  background-image: none;
  border-radius: 50%;
  height: 22px;
  left: 2px;
  position: absolute;
  top: 2px;
  width: 22px;
}
.reviewsectionerror > div > span:before {
  content: "!";
  color: #FFF;
  font-size: 1.20em;
  font-weight: 700;
  left: 9px;
  position: relative;
  top: -2px;
}

.errorDetail {
 /* background-color: #eae8e5;*/
  padding-top: 0px;
  padding-bottom: 0px;
  display: inline-block;
  margin: 4px;
}

.errorDetail > p {
  vertical-align: middle;
  margin-bottom: 0;
  padding: 4px;
  display: inline-block;
}
#appendErrorList .row:first-child > h3, .injectQuestions .form-group { margin-top: 0px;}
.lookup-icon {
  position: absolute;
  right: 0;
  top: 10px;
  color: grey;
}

/*
unauth only
*/
a.toggle-anchor {
  color: #000000;
  margin: 0px 10px;
}

a.toggle-anchor:hover {
  cursor: pointer;
  text-decoration: none;
}

a.toggle-anchor:visited {
  color: #000000;
}

a.toggle-anchor.active {
  border-bottom: 2px solid #146c9c;
  text-decoration: none;
}

.or-divider {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  padding-top: 10px;
  height: 355px; /*height for login page divider */ 
}
@media only screen and (min-width: 992px) {
  .or-divider {
    padding-top: 30px;
  }
}

.or-divider > p {
  margin: 0;
  width: 100%;
}

.or-divider > div {
  display: none;
}
@media only screen and (min-width: 992px) {
  .or-divider > div {
    border-left: 1px solid #f9c118;
    display: block;
    min-height: 68px;
  }
}

/*
auth only
*/
.home > section .license-applications {
  margin-bottom: 20px;
}

.home > section .license-applications > a {
  text-align: right;
}

@media (max-width: 767px) {
  .home > section .license-applications > a {
    text-align: left;
  }
}
.home > section .home-notifications {
  height: 300px;
  overflow-y: auto;
}

.home > section .home-notification-list {
  list-style: none;
  padding: 0;
}

.home > section .home-notification-list > li {
  background-color: #eae8e5;
  margin-bottom: 5px;
  padding: 15px;
}

.home > section .home-notification-list > li > div {
  font-weight: 700;
}

.home > section .home-notification-list > li > div:before {
  color: red;
  content: "\2022 ";
  font-size: 18px;
  position: relative;
  left: -6px;
  top: 1px;
}

.home > section .license.licBack {
  padding: 20px;
}

/*Authorized Homepage Progress Bar*/
.home > section .ce-progress {
  background-color: #eae8e5;
  border-radius: 5px;
  height: 100px;
  margin: 10px 5px 0;
  padding: 15px 0;
  text-align: center;
}

.home > section .ce-progress > p {
  font-size: 12px;
  margin-bottom: 15px;
}

.home > section .ce-progress > .ce-progress-bar {
  background: linear-gradient(90deg, #ff8768 4%, #bbbbbb 6%);
  /*This will need to be updated with js*/
  border-radius: 5px;
  display: block;
  height: 6px;
  margin: 0 auto;
  width: 80%;
}

/*Mobile*/
@media (max-width: 767px) {
  .home > section .home-notification-list > li {
    display: flex;
    flex-wrap: wrap;
  }

  .home > section .home-notification-list > li > div {
    order: 2;
  }

  .home > section .home-notification-list > li > span {
    order: 1;
  }

  .home > section .home-notification-list > li > p {
    order: 3;
  }
}
/*Tablet*/
@media (min-width: 768px) {
  .home > section .home-notification-list > li > div {
    display: inline-block;
    width: 80%;
  }
}
.home > section .start-flex > div:first-child {
  padding-top: 25px;
}

/*
both
*/
.home > section > .img-background {
  background-image: url(../DDStyle/_assets/jumbotron_statehouse.jpg);
  background-color: none;
  padding: 120px 0;
  position: relative
}

.home > section > .img-background > .img-overlay {
  background-color: rgba(0, 0, 0, 0.35);
  position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
}

.home > section > .img-background .header-btn-group {
  margin-top: 20px;
}

.home > section > .img-background .header-btn-group > a,
.home > section > .img-background .header-btn-group > button {
  margin-right: 10px;
}

@media (max-width: 767px) {
  .home > section > .img-background .header-btn-group {
    text-align: center;
  }

  .home > section > .img-background .header-btn-group > button {
    margin: 10px 0;
    width: 100%;
  }

  .home > section > .img-background .header-btn-group :nth-last-child(-n+2) {
    margin-bottom: 20px;
  }
}
/*License Applications*/
.home > section .licenses {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-start;
  margin: 0 auto;
}

.home > section .licenses.placeholder {
  width: auto;
}

.home > section .licenses.placeholder > .license-container {
  height: 420px;
}

.home > section .license-container {
  height: 520px;
  float: left;
  margin: 10px 15px 10px 0;
  width: 250px;
}

.home > section .license {
  background-color: #FFFFFF;
  background-image: url(../DDStyle/_assets/bg_license_retina.png);
  background-position: 7px 7px;
  background-repeat: no-repeat;
  background-size: 94% 96%;
  height: 400px;
  padding: 20px 10px 10px;
  width: 100%;
}

.home > section .license
.home > section .license:hover {
  cursor: pointer;
}

.home > section .license > span {
  background-image: url(../DDStyle/_assets/img_license_retina.png);
  background-repeat: no-repeat;
  background-size: contain;
  display: block;
  height: 50px;
  margin: 10px auto;
  width: 120px;
}

.home > section .license > span.business {
  background-image: url(../DDStyle/_assets/img_license_business_retina.png);
}

.home > section .license > div {
  border-top: 1px solid #DDDDDD;
  display: flex;
  flex-wrap: wrap;
  height: calc(100% - 85px);
  margin: 0 15px;
  padding: 10px 0 20px;
  position: relative;
}
.home > section .license > div div.license-badge {
  position: absolute;
  top: -10px;
  left: 0;
  right: 0;
  text-align: center;
}
.home > section .license > div div.license-badge .badge {
  background-color: #73a4cc;
  font-weight: normal;
  font-size: 11px;
  padding: 4px 10px;
}
.home > section .license > div div.license-badge .badge .renew {
  background-color: #ae051d;
}
.home > section .license > div div.license-badge .badge.renew {
  background-color: #ae051d;
}

.home > section .license > div > div {
  font-size: 11px;
}

.home > section .license > div > div > p {
  color: #888888;
  margin-top: 20px;
}

.home > section .license > div > a {
  align-self: flex-end;
  color: #72a4cb;
  font-size: 10px;
  font-weight: 600;
}

.home > .ce-progress {
  text-align: center;
}

.home > .ce-progress > p {
  font-size: 12px;
  margin-bottom: 15px;
}

.home > .ce-progress > .ce-progress-bar {
  background: linear-gradient(90deg, #ff8768 4%, #bbbbbb 6%);
  /*This will need to be updated with js*/
  border-radius: 5px;
  display: block;
  height: 6px;
  margin: 0 auto;
  width: 80%;
}

/*Media*/
@media (min-width: 992px) {
  .home > section .license-container {
    width: 240px;
  }

  .home > section .license-container:nth-child(3n) {
    margin-right: 0;
  }
}
@media (max-width: 991px) {
  .home > section .license-container:nth-child(2n) {
    margin-right: 0;
  }

  .home > section .licenses {
    min-width: 0;
  }
}
@media (max-width: 767px) {
  .home > section .license-container {
    margin: 10px 15px;
  }
}
/*License Place Holder*/
.home > section .license-place-holder {
  align-items: center;
  background-color: #f1f0ed;
  background: none;
  border: 2px solid #DDDDDD;
  display: flex;
  justify-content: center;
}

.home > section .license-place-holder > div {
  border: 2px solid #BBBBBB;
  border-radius: 50%;
  height: 50px;
  margin: 0;
  padding: 0;
  position: relative;
  width: 50px;
}

.home > section .license-place-holder > div:before {
  content: "+";
  color: #BBBBBB;
  font-size: 36px;
  font-weight: 100;
  left: 12px;
  position: absolute;
  top: -5px;
}

/*Wagner's Overrides*/
.p-padding {
  line-height: 1.7;
  padding-top: 20px;
}

.row-padding {
  padding-bottom: 20px;
}


.business-show {
  margin-top: 30px;
}

.ext-progress {
  margin: 10px 5px 0;
  padding: 15px 0;
  text-align: center;
}

.ext-progress-bar {
  background: linear-gradient(90deg, #ff8768 4%, #bbbbbb 5%);
  border-radius: 5px;
  display: block;
  height: 6px;
  margin: 0 auto;
  width: 80%;
}
.ext-progress-bar.Pending {
  background: linear-gradient(90deg, #ff8768 25%, #bbbbbb 5%);
}
.ext-progress-bar.Generate {
  background: linear-gradient(90deg, #ff8768 50%, #bbbbbb 5%);
}
.ext-progress-bar.Submitted {
  background: linear-gradient(90deg, #dedc50 75%, #bbbbbb 5%);
}
.ext-progress-bar.Active {
  background: linear-gradient(90deg, #dedc50 100%, #bbbbbb 5%);
}
.ext-progress-bar.Inactive {
  background: linear-gradient(90deg, #ff8768 100%, #bbbbbb 5%);
}

.progress-bar {
  background-color: #FFF; /*#535252;
  border-radius: 65px;
  height: 120px;*/
  display: flex;
  float: initial;
  justify-content: center;
  margin-top: -120px;
  min-width: 930px;
  width: 100%;
  transition: all 0.5s;
  box-shadow: none;
}
.progress-section:after {
	content: "";
	position: absolute;
	left: 0;
	bottom: 0;
	width: 0;
	height: 0;
	border-left: 20px solid white;
	border-top: 20px solid transparent;
	border-bottom: 20px solid transparent;
}
.progress-section:first-child:after { border-left : 0px; }
.progress-section:before {
	content: "";
	position: absolute;
	right: -20px;
	bottom: 0;
	width: 0;
	height: 0;
	border-left: 20px solid #1d4f81;
	border-top: 20px solid transparent;
	border-bottom: 20px solid transparent;
}
.progress-bar > .progress-section {
	border-radius: 0px !important;
	margin: 0px 11px !important;
	width: 200px;
	height: 40px;
	position: relative;
	background: #1d4f81;
}

.progress-bar > .progress-section:hover {
  background-color: #4b4b4b;
  cursor: pointer;
}

.progress-bar > .progress-section:hover > div > span {
  background-color: #4b4b4b;
}

.progress-bar > .progress-section > div {
  
  background-color: transparent !important; 
  border-radius: 0; 
  height: auto !important;
  margin: auto !important; 
  width: auto !important; 
  display:none !important; 
}

.progress-bar > .progress-section > div > span {
  height: 22px;
  position: absolute;
  width: 22px;  
  left: 174px !important; 
  top: -16px !important; 
  background-color: #f9c118 !important;
}

.progress-bar > .progress-section.in-progress > div {
  background-image: linear-gradient(140deg, rgba(0, 0, 0, 0) 50%, #b5dc10 50%), linear-gradient(270deg, #b5dc10 50%, rgba(0, 0, 0, 0) 50%);
}
.progress-section:focus{ outline: 1px dotted #333; }
/* active colors should override in-progress colors */
.progress-bar > .progress-section.active { background-color: #f9c118 !important; }
.progress-bar > .progress-section.active:before { border-left: 20px solid #f9c118 !important; }
.progress-bar > .progress-section.active > h6 { color:#333; }
.progress-bar > .progress-section.active:hover > h6 { color:#FFF; }
.progress-bar > .progress-section.active > div > span { background-color: #424242; }
.progress-bar > .progress-section:hover:before  { border-left: 20px solid #4b4b4b !important;}
.progress-bar > .progress-section.active:hover {  background-color: #4b4b4b !important;  }

.progress-bar > .progress-section.active:hover > div > span {
  background-color: #3a3a3a;
}

.progress-bar > .progress-section.complete > div {
  background-color: #b5dc10;
}

.progress-bar > .progress-section.complete > div > span {
  background-color: #b5dc10;
  background-image: url(../DDStyle/_assets/ic_check_black_retina.png);
  background-repeat: no-repeat;
  background-position: 6px 6px;
  background-size: 10px;
}

.progress-bar > .progress-section.active.complete:hover > div > span {
  background-color: #b5dc10;
}

.progress-bar > .progress-section.error > div {
  background-color: transparent !important;
  display:block !important;
}

.progress-bar > .progress-section.error > div > span {
  background-color: #d42031 !important;
  background-image: none !important;
  /*background-repeat: no-repeat;
  background-position: 9px 4px;
  background-size: 4px;*/
}
.progress-bar > .progress-section.error > div > span:before {
  content: "!";
  color: #FFF;
  font-size: 1.30em;
  font-weight: 700;
}
.progress-bar > .progress-section.active.error:hover > div > span {
  background-color: #ff8768;
}

.progress-bar > .progress-section > h6 {
  font-size: 1.2em; padding-left: 11px; margin: 8px 0px;
}

@media (min-width: 1200px) {
  .progress-bar {
    margin-left: auto;
    margin-right: auto;
  }
}
@media (min-width: 992px) {
  .progress-bar > .mobile-dropdown {
    display: none;
  }
}
@media (max-width: 991px) {
  .progress-bar {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    margin: 0 auto;
    min-width: 0;
    overflow: scroll;
    width: 100%;
	box-shadow: none;
  }

  .progress-bar > .progress-section {
    display: none;
    height: 110px;
    order: 3;
    width: 80%;
  }

  .progress-bar > .progress-section.active {
    display: block;
    order: 1;
    margin-left: 5px;
  }

  .progress-bar > .mobile-dropdown {
    display: block;
    margin: 0 auto;
    order: 2;
    position: relative;
    width: 22px;
  }

  .progress-bar > .mobile-dropdown:before {
    color: #ffffff;
    content: '\e114';
    font-size: 20px;
    left: 1px;
    position: absolute;
    top: 45px;
    display: inline-block;
    font-family: 'Glyphicons Halflings';
    font-style: normal;
    font-weight: 200;
    line-height: 1;
    -webkit-font-smoothing: antialiased;
  }
}
#internal-header {
  overflow: hidden;
  *zoom: 1;
  border-bottom: #cccccc;
  margin: 0;
  padding: 2.5rem 0 2.5rem 6rem;
 /* border-bottom: 1px solid #f9c118;*/
}

#internal-header h1 img {
  margin-right: 2rem;
}
#internal-header p {
  color: #525051;
  padding: 0;
  width: 70%;
}

#internal-header a {
  color: #3b6280;
  text-decoration: none;
}
#internal-header a:hover {
  text-decoration: none;
}


.internal .below-the-fold {
 /* border-top: 1px solid #f9c118;*/
}

.btn-very-small {
  font-size: 0.7em !important;
  
}

.btn-very-small .glyphicon {
  padding-right: 5px !important;
}

nav .nav-links > li {
  font-size: 12px;
}

.btn {
  font-size: 12px;
}

.btn-right {
  margin-left: 25px;
}

footer .tablet-footer > .footer-links > li {
  font-size: 12px;
}

.questionRadio {
  border: 2px solid #555555;
  height: 16px;
  width: 16px;
  border-radius: 50%;
  background: #ffffff;
}

.addressEdit {
  border-top: 1px solid gray;
  padding-top: 10px;
}

.addedlistTwo {
  list-style: none !important;
}

.gError {
  padding-left: 5%;
  padding-right: 5%;
  width: 95% !important;
}

.squareIconBtnAddr {
  width: 25px !important;
  min-width: 0;
  padding: 2px;
  border: 0;
  background-color: #eae8e5;
}

.iconHolder {
  text-align: right;
}

select {
  display: block;
  width: 100%;
  height: 34px;
  padding: 6px 12px;
  font-size: 14px;
  line-height: 1.42857143;
  color: #555;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  -webkit-border-radius: 4px;
  -moz-border-radius: 4px;
  border-radius: 4px;
}

.boardPickList::before {
  left: 4px !important;
  top: 18px !important;
}

.boardPickList label {
  color: #5C5C5C;
  font-size: 12px;
  left: 15px;
}

.animated-form .form-group > .noSpanStyle {
  position: relative !important;
}

.alert {
  padding-left: 20px !important;
}

.singleLine, .labeloverflowing {
  white-space: nowrap;
}

.individualBtnRow {
  margin-top: 20px;
  text-align: center;
}

.individualBtnRow input {
  margin-left: 10px;
}

.spinner {
  background: rgba(0, 0, 0, 0.5);
  bottom: 0;
  left: 0;
  position: fixed;
  top: 0;
  right: 0;
  z-index: 99999;
  -webkit-transition: opacity 400ms ease-in-out;
  -moz-transition: opacity 400ms ease-in-out;
  transition: opacity 400ms ease-in-out;
}

.spinner .spinner-icon {
  /*position: absolute;
  left: 50%;
  top: 50%;
  background-image: url("../DDStyle/_assets/loading4.gif");
  background-size: cover;
  height: 100px;
  width: 100px;
  margin-left: -50px;
  margin-top: -50px;*/
  
 	position: fixed; 
	left: 47%; 
	top: 39%; 
	padding: 10px; 
	z-index: 99990
}

.mobile-nav {
  padding-top: 30px;
}
.mobile-nav.open .mobile-navigation {
  display: block;
  padding: 10px;
}
.mobile-nav .glyphicon {
  padding-right: 0;
}
.mobile-nav .mobile-navigation {
  background-color: #ebe9e6;
  display: none;
  padding: 10px;
  margin-top: 10px;
}
.mobile-nav .mobile-navigation .mobile-nav-links {
  margin: 0;
  padding: 0;
  list-style: none;
}
.mobile-nav .mobile-navigation .mobile-nav-links li {
  padding-bottom: 10px;
}
.mobile-nav .mobile-navigation .mobile-nav-links li a:hover {
  text-decoration: none;
}

#mobile-username-dropdown-content {
  display: none;
}
#mobile-username-dropdown-content .user-links {
  margin-top: 10px;
}

#mobile-username-dropdown:hover {
  cursor: pointer;
}
#username-dropdown-content li a {
    color: #333;
}
#username-dropdown a {
  cursor: pointer;
}

.modal-content {
  -moz-border-radius: 0;
  -webkit-border-radius: 0;
  border-radius: 0;
  padding: 20px 40px;
}
.modal-content h4 {
  color: #000;
}
.modal-content .modal-footer {
  border-top: 0 !important;
  text-align: center !important;
}
.modal-content .modal-header {
  border-bottom: 0 !important;
}

.animated-input-group {
  margin-top: 30px;
  margin-bottom: 15px;
  position: relative;
}
.animated-input-group.activeSpan {
  position: absolute;
  bottom: 0;
  left: 4px;
  width: 95.5%;
  margin-left: 1.8%;
  height: 2px;
  background: #72a4cb;
  transition: all 0.6s;
}

.non-animated-input-group {
  margin-top: 30px;
  margin-bottom: 15px;
  position: relative;
}
.non-animated-input-group label {
  color: #5C5C5C;
  font-size: 12px;
  left: 10px;
  position: absolute;
  top: -18px;
}

.requiredElement::before {
  content: '*';
  color: #000000;
  font-weight: bold;
  position: absolute;
  left: -12px;
}

.errorElement {
  color: red !important;
}

.errorElement::before {
  color: red !important;
}

.errorElement > label {
  color: red !important;
}

.errorElement .activeSpan {
  background: red !important;
}

.animated-input-group {
  margin-top: 30px;
  margin-bottom: 15px;
  position: relative;
}

.animated-input-group .InputLabel {
  color: #666;
  font-size: 14px;
  font-weight: 400;
  /*left: 13px;*/
  position: absolute;
  top: 7px;
  transition: all 0.3s ease;
  -moz-transition: all 0.3s ease;
  -ms-transition: all 0.3s ease;
  -o-transition: all 0.3s ease;
  -webkit-transition: all 0.3s ease;
  margin-left: 10px;
}

.animated-input-group .bottomShade {
  position: absolute;
  bottom: 0;
  left: 4px;
  width: 0%;
  height: 2px;
  background: #72a4cb;
  transition: all 0.6s;
}

.animated-input-group span.activeSpan {
  position: absolute;
  bottom: 0;
  left: 4px;
  width: 95.5%;
  margin-left: 1.8%;
  height: 2px;
  background: #72a4cb;
  transition: all 0.6s;
}

.animated-input-group .InputLabel_In {
  color: #444;
  /*font-size: 12px;*/
  font-weight: 400;
  /* left: 10px;*/
  top: -22px;
  /* Animate */
  -moz-transition: all 0.3s ease;
  -ms-transition: all 0.3s ease;
  -o-transition: all 0.3s ease;
  -webkit-transition: all 0.3s ease;
  transition: all 0.3s ease;
}

.sass-sandbox {
  max-width: 90rem;
  margin-left: auto;
  margin-right: auto;
  background-color: lime;
}
.sass-sandbox:after {
  clear: both;
  display: table;
  height: 0;
  overflow: hidden;
  content: '';
}
@media only screen and (min-width: 640px) {
  .sass-sandbox {
    background-color: tan;
  }
}
@media only screen and (min-width: 640px) {
  .sass-sandbox {
    background-color: tan;
  }
}
@media only screen and (min-width: 960px) {
  .sass-sandbox {
    background-color: blue;
  }
}
@media only screen and (min-width: 960px) {
  .sass-sandbox {
    background-color: yellow;
  }
}

/*TODO

Create 4 divs layout inside ofr the sass-sandbox
and go over @include cols(4);

@include breakpoint (tablet-wide){
                @include cols(5 omega);
                float: none;
                margin-right: auto;
            }
*/
#license-details label {
   font-weight: bold;
}
#license-details span {
  display: block;
 
}
#license-details .print {
  color: #3b6280;
  font-size: 12px;
  font-weight: bold;
  text-transform: uppercase;
}
#license-details .print img {
  margin-top: -6px;
  padding-right: 10px;
}
#license-details .print:hover {
  text-decoration: none;
}

#license-details div.row {
  margin-bottom: 30px;
}

.search-header h2 {
  display: inline-block;
  padding-right: 10px;
}

.search-filters .clear {
  clear: both;
}
.search-filters .col-sm-1, .search-filters .col-sm-3, .search-filters .col-sm-2, .search-filters .col-sm-4, .search-filters .col-sm-5, .search-filters .col-sm-6, .search-filters .col-sm-7 {
  padding-left: 0;
}

.search-submit .btn {
  margin-top: 24px;
}


#results_wrapper .expand-no-icon:before, #resultsT_wrapper .expand-no-icon:before {
  content: '';
  background-image: none;
  background-repeat: none;
  display: block;
  position: relative;
  width: 13px;
  height: 9px;
}
#results_wrapper .expand-no-icon.open:before, #resultsT_wrapper .expand-no-icon.open:before {
  content: '';
  background-image: none;
  background-repeat: none;
  display: block;
  position: relative;
  width: 13px;
  height: 9px;
}

table .moreInformation, table .print {
  background-color: transparent;
  border: 0;
}
table .moreInformation {
  color: #3b6280;
  text-transform: uppercase;
}
table .print {
  background-image: url(../DDStyle/_assets/ic_print.png);
  background-repeat: no-repeat;
  text-indent: -9999px;
}

/table.dataTable tbody tr.expanded-detail {
  background-color: #f9f8f7;
}

table.dataTable tbody tr.expanded-detail td table tr {
  background-color: #f9f8f7;
}

table.dataTable thead .sorting_asc {
  background-image: url(../DDStyle/_assets/ic_sort_default.png) !important;
}

table.dataTable thead .sorting_desc {
  background-image: url(../DDStyle/_assets/ic_sort_a_z.png) !important;
}

table.dataTable thead .sorting_asc {
  background-image: url(../DDStyle/_assets/ic_sort_z_a.png) !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
  background: #F9C118 !important;
  border: 1px solid #c1a963 !important;
  border-radius: 5px;
  color: #333;
  font-weight: bold;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.current:after {
  content: none;
}
.paginate_button.next {
  background-color: #FFFFFF;
  background-image: url(../DDStyle/_assets/ic_carat_right_cart_grey.png);
  background-repeat: no-repeat;
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  border-radius: 3px;
  border: 1px solid #ddd !important;
  padding: 4px 4px !important;
  text-align: center;
  background-position: 6px;
  text-indent: -999999px;
}
.paginate_button.next:hover {
  background-color: #FFFFFF !important;
  background-image: url(../DDStyle/_assets/ic_carat_right_cart_grey.png) !important;
  background-repeat: no-repeat !important;
  -webkit-border-radius: 3px;
  -moz-border-radius: 3px;
  border-radius: 3px;
  border: 1px solid #ddd !important;
  padding: 4px 4px;
  text-align: center;
  background-position: 6px !important;
  text-indent: -999999px;
}
.dataTables_wrapper .paginate_button.next:hover {  background-image: none !important; }
.dataTables_wrapper table thead, .business-card table thead { color: #525051;  background-color: #ddd;  }
.dataTables_wrapper table tr, .business-card table tr { border: 1px solid #ccc; overflow: hidden; padding: 20px; position: relative;   }
.dataTables_wrapper input[type=search] { 
        border: 1px solid #ccc; border-radius: 4px; color: #555; box-shadow: inset 0 1px 1px rgba(0,0,0,.075); padding: 6px 12px;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.disabled,
.dataTables_wrapper .dataTables_paginate .paginate_button.first,  
.dataTables_wrapper .dataTables_paginate .paginate_button.last,
.dataTables_wrapper .dataTables_paginate .paginate_button.next {
  background-color: #146c9c !important;
  color: #FFF !important;
  background-image: none;
  -webkit-border-radius: 5px;
  -moz-border-radius: 5px;
   border-radius: 5px;
   border: 1px solid #294459 !important;
   padding: 0.5em 1em !important;
   text-align: center;
   text-indent: 0px;
   font-weight: bold;
   cursor: pointer !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button.disabled:hover{
   color: #FFF !important;
}
.paginate_button.previous {
  display: none !important;
}
.licenseLookup .paginate_button.previous {
  display: inline-block !important;
  background-color: #146c9c !important;
  color: #FFF !important;
  border: 1px solid #294459 !important;
}

#continuing-education #internal-header button {
  margin-top: 5px;
}
#continuing-education .top-filters {
  padding-bottom: 0;
}
#continuing-education .top-filters .sort {
  padding: 0;
}
#continuing-education .license {
  overflow: hidden;
  *zoom: 1;
  background-color: #FFFFFF;
  border: 1px solid #cccccc;
  padding: 15px;
}
#continuing-education .license div {
  padding-bottom: 10px;
}
@media only screen and (min-width: 960px) {
  #continuing-education .license div {
    padding-bottom: 0;
  }
}
@media only screen and (min-width: 960px) {
  #continuing-education .license .date {
    display: block;
  }
}
#continuing-education .license .date-wrapper {
  color: #999999;
}
@media only screen and (min-width: 960px) {
  #continuing-education .license .date-wrapper {
    text-align: center;
  }
}
#continuing-education .license .title-wrapper {
  padding: 0 15px;
}
#continuing-education .license .title-wrapper h3 {
  margin: 0;
}
#continuing-education .license .title-wrapper h4 {
  color: #999999;
  font-size: 16px;
  padding: 0;
}
#continuing-education .license .progress-bar-wrapper {
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px;
  border-radius: 10px;
  background-color: #ddddda;
  height: 30px;
  overflow: hidden;
  position: relative;
  width: 100%;
}
#continuing-education .license .progress-bar-wrapper .progress-percent {
  -moz-border-radius: 10px;
  -webkit-border-radius: 10px;
  border-radius: 10px;
  -moz-transition-duration: 0.5s;
  -o-transition-duration: 0.5s;
  -webkit-transition-duration: 0.5s;
  transition-duration: 0.5s;
  -moz-transition-timing-function: ease-in-out;
  -o-transition-timing-function: ease-in-out;
  -webkit-transition-timing-function: ease-in-out;
  transition-timing-function: ease-in-out;
  height: 30px;
  position: relative;
}
#continuing-education .license .progress-bar-wrapper .progress-percent.prog-red {
  background-color: #ff8768;
  width: 25%;
}
#continuing-education .license .progress-bar-wrapper .progress-percent.prog-yellow {
  -moz-transition-duration: 0.5s;
  -o-transition-duration: 0.5s;
  -webkit-transition-duration: 0.5s;
  transition-duration: 0.5s;
  -moz-transition-timing-function: ease-in-out;
  -o-transition-timing-function: ease-in-out;
  -webkit-transition-timing-function: ease-in-out;
  transition-timing-function: ease-in-out;
  background-color: #fbac4f;
  width: 50%;
}
#continuing-education .license .progress-bar-wrapper .progress-percent.prog-green {
  -moz-transition-duration: 0.5s;
  -o-transition-duration: 0.5s;
  -webkit-transition-duration: 0.5s;
  transition-duration: 0.5s;
  -moz-transition-timing-function: ease-in-out;
  -o-transition-timing-function: ease-in-out;
  -webkit-transition-timing-function: ease-in-out;
  transition-timing-function: ease-in-out;
  background-color: #b5dc10;
  width: 100%;
}
#continuing-education .license .progress-bar-wrapper .progress-percent .num-hours {
  -moz-border-radius: 50%;
  -webkit-border-radius: 50%;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.2);
  color: #FFFFFF;
  font-size: 10px;
  padding: 3px 6px;
  position: absolute;
  top: 20%;
  right: 2px;
}
#continuing-education .license .actions-wrapper button {
  margin-bottom: 10px;
}
#continuing-education .license .toggle-more .expand {
  float: right;
  margin-top: 20px;
  padding: 15px 0 15px 15px;
}
#continuing-education .license .toggle-more .expand:before {
  content: '';
  background-image: url(../DDStyle/_assets/ic_carat_down_retina.png);
  background-repeat: none;
  display: block;
  position: relative;
  width: 13px;
  height: 9px;
}
#continuing-education .license .toggle-more .expand.open:before {
  content: '';
  background-image: url(../DDStyle/_assets/ic_carat_up_retina.png);
  background-repeat: none;
  display: block;
  position: relative;
  width: 13px;
  height: 9px;
}
#continuing-education .license .toggle-more .expand:hover {
  cursor: pointer;
}
#continuing-education .license-detail {
  background-color: #f8f8f7;
  display: none;
  min-height: 30px;
  overflow: hidden;
  padding: 15px;
}
#continuing-education .button-offset {
  margin-top: 23px;
}
#continuing-education table th {
  color: #999999;
  background-color: #f8f8f7;
  font-weight: normal;
  padding: 15px 15px 0 15px;
}
#continuing-education table tr {
  background-color: #e9e9e6;
  border-top: 5px solid #f8f8f7;
}
#continuing-education table tr td {
  height: 71px;
  margin-top: 5px;
  padding: 15px;
}
#continuing-education table button {
  background-color: transparent;
  color: #999999;
}
#continuing-education table button.squareIconBtnAddr {
  color: #000;
}
@media only screen and (min-width: 960px) {
  #continuing-education form div:first-of-type {
    padding-left: 0;
  }
}
#continuing-education .button-offset-add {
  margin-top: 29px;
}
#continuing-education .completed {
  background-color: #b5dc10;
  padding: 10px;
  -moz-border-radius: 50%;
  -webkit-border-radius: 50%;
  border-radius: 50%;
}

#my_profile .profileCircle {
  -moz-border-radius: 75px;
  -webkit-border-radius: 75px;
  border-radius: 75px;
  background-color: #FFFFFF;
  border: 1px solid #cccccc;
  color: #000;
  font-size: 35px;
  font-weight: bold;
  line-height: 90px;
  text-align: center;
  width: 95px;
  -webkit-box-shadow: 6px 6px 36px 0px #cccccc;
  -moz-box-shadow: 6px 6px 36px 0px #cccccc;
  box-shadow: 6px 6px 36px 0px #cccccc;
}
#my_profile a.controls, .verifyLicense a.controls {
  color: #0072c6;
  display: inline-block;
  font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif;
  font-size: 1.1em;
  margin-top: 10px;
  text-transform: uppercase;
}
#my_profile .name-change a {
  color: #3b6280;
  text-decoration: underline;
}
#my_profile .name-change p {
  color: #525051;
  margin-bottom: 0;
}
#my_profile #profilePage_LeftSide h1 {
  margin-top: 0;
}
#my_profile .glyphicon, .verifyLicense .glyphicon-print {
  padding-right: 5px;
}
/*#my_profile .row {
  margin-bottom: 20px;
}*/
#my_profile #profileEditPanel .row {
  margin-bottom: 0;
}
#my_profile .divider {
  min-height: 1px;
  background-color: #f9c118;
}
#my_profile #AddressList li {
  background-color: #e9e9e6;
  border-top: 5px solid #f2f1ee;
  padding: 15px;
}

.form-group_na {
  margin-top: 8px;
}

.profileReadPanel .row label {
  font-weight: bold;
  display: block;
}

.row {
  margin-left: -1px !important;
  clear: both;
}

.militaryInfoView {
/*  margin-left: 20px; TBD*/ 
}

.militaryInfoView .row {
  line-height: 25px;
}

.militaryInfoView .row label {
  font-weight: bold;
  display: block;
}

.profile_btns {
  margin-left: 20px;
  margin-top: 15px;
}

.profile_btns_myProfile{
  margin-left: 20px;
  margin-top: -2px;
}

.top-padding{
	margin-top:12px;
}

.profile_links {
  margin-top: 15px;
  text-decoration: underline;
}

#class-lookup table, table#licTable, table#srTable, table#permTable, table#myPayments, table#results, table#resultsT  {
  width: 100% !important;
}
#class-lookup #internal-header a img {
  margin-top: -2px;
}
#class-lookup .input-offset {
  margin-top: 5px;
}
#class-lookup #sort-by {
  float: right;
  margin-right: 15px;
}
#class-lookup #top-filters {
  padding: 30px 0;
  position: relative;
  clear: both;
}
#class-lookup #top-filters #sort-by {
  float: right;
}
#class-lookup .class-card {
  background-color: #fff;
  border: 1px solid #cccccc;
  padding: 30px;
  position: relative;
  margin-top: 20px;
}
#class-lookup .class-card .date-cost .day {
  font-size: 18px;
}
#class-lookup .class-card .date-cost .date {
  font-size: 18px;
  font-weight: bold;
  padding-bottom: 5px;
}
#class-lookup .class-card .date-cost .times {
  color: #999999;
  font-size: 14px;
  margin-bottom: 20px;
}
#class-lookup .class-card .date-cost .cost {
  padding-top: 10px;
}
@media only screen and (min-width: 992px) {
  #class-lookup .class-card .date-cost .cost {
    padding-left: 35px;
  }
}
#class-lookup .class-card .class-details h1 {
  font-size: 32px;
  margin-bottom: 0;
}
#class-lookup .class-card .class-details h2 {
  color: #999999;
  font-size: 14px;
  margin-top: 10px;
}
#class-lookup .class-card .hours {
  -moz-border-radius: 15px;
  -webkit-border-radius: 15px;
  border-radius: 15px;
  background-color: #3b6280;
  color: #fff;
  font-size: 14px;
  padding: 5px 10px;
  position: absolute;
  top: 30px;
  right: -10px;
}
#class-lookup .class-card .hours .num {
  font-size: 20px;
  font-weight: bold;
  padding-right: 5px;
}

#file-a-complaint section {
  padding: 30px 0 0 0;
}

#cart .breadcrumb {
  background-color: transparent;
  padding: 10px 0px;
}
#cart .breadcrumb li {
  color: #525051;
  font-weight: bold;
}
#cart .breadcrumb li.active span {
  border-bottom: 2px solid #f9c118;
  color: #074078;  
}
#cart .breadcrumb li.active + li:before {
  content: "\00bb";
 /* background-image: url(../DDStyle/_assets/ic_carat_right_cart_blue.png);
  background-repeat: no-repeat;*/
  color: #074078;
  padding: 0 10px;
  font-size: 1.5em;
}
#cart .breadcrumb > li + li:before {
  content: "\00bb";
  /*background-image: url(../DDStyle/_assets/ic_carat_right_cart_grey.png);
  background-repeat: no-repeat;*/
  color: #074078;
  padding: 0 10px;
  font-size: 1.5em;
}
#cart table thead {
  color: #525051;
}
#cart table.innerFeesTable  thead tr {
  background-color: #ddd;
}
#cart table tr {
  border-bottom: 1px solid #f2f1ee;
  overflow: hidden;
  position: relative;
}
#cart .total-text {
  padding: 0 10px 0 20px;
}
#cart .money, #cart #total-amount {
  font-weight: bold;
}
#cart #total-amount {
  padding-right: 20px;
}
#cart p.redirected {
  margin-bottom: 50px;
}
#cart table.innerFeesTable tbody tr:nth-child(even) {background-color: #efefef; }
#cart table.innerFeesTable tbody tr:nth-child(odd) {background-color: #FFF; }
#contact table thead, #waiver table thead {
  color: #525051;
  background-color: #ddd;
}
#contact table thead tr, #waiver table thead tr {
  background-color: transparent;
  border-bottom: 1px solid #cccccc;
}
#contact table tr, #waiver table tr {
  background-color: #fff;
  border: 1px solid #ccc;
  overflow: hidden;
  padding: 20px;
  position: relative;
}
#contact table tr th, #waiver table tr th {
 /* padding: 20px;*/
 padding: 8px;
}
#contact table td, #waiver table td {
 /* padding: 20px; */
 padding: 8px;
}
#my-liceneses #filters {
  margin-bottom: 10px;
}
#my-liceneses #filters .new-license {
  text-align: right;
}
#my-liceneses .myEachLicense {
	background-color: #fff;
    border: 1px solid #0A4e73;
    clear: both;
    margin-top: 10px;
    padding: 10px;
    border-radius: 5px;
	display: flex;
	align-items: center;
}
#my-liceneses .myEachLicense h4, #my-liceneses .myEachLicense p {
  color: #535252;
  font-size: 16px;
  margin: 0;
  padding: 0;
}
#my-liceneses .myEachLicense .ce-progress p {
  padding-top: 20px;
}
#my-liceneses .myEachLicenseChild {
	background-color: #f8f8f7;
	border: 1px solid #cccccc;
	margin-bottom: -1px;
	padding: 20px;
}
#my-liceneses .myEachLicenseChild:last-child {
	margin-bottom: 10px;
}
#my-liceneses .ce-progress {
  text-align: center;
}
#my-liceneses .ce-progress > p {
  font-size: 12px;
  margin-bottom: 15px;
}
#my-liceneses .ce-progress > .ce-progress-bar {
  background: linear-gradient(90deg, #ff8768 4%, #bbbbbb 6%);
  /*This will need to be updated with js*/
  border-radius: 5px;
  display: block;
  height: 6px;
  margin: 37px auto 0 auto;
  width: 80%;
}
#my-liceneses .ce-prog-label {
  text-align: center;
}
#my-liceneses .renew {
  -moz-border-radius: 500px;
  -webkit-border-radius: 500px;
  border-radius: 500px;
  background-color: #EF1217;
  color: #fff;
  font-size: 11px;
  letter-spacing: 3px;
  left: -22px;
  padding: 5px 15px;
  position: absolute;
  text-transform: uppercase;
  top: 50px;
  z-index: 1;
}
#my-liceneses .license-status             { font-size: 12px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; }
#my-liceneses .license-substatus          { font-size: 12px; font-weight: 400; color: #535252; display: inline-block; margin-bottom: 10px; }
#my-liceneses .license-exp-date           { font-size: 12px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; }
#my-liceneses .license-exp-date-value     { font-size: 12px; font-weight: 400; color: #535252; }
#my-liceneses .endorsement-type           { font-size: 16px; font-weight: 700; }
#my-liceneses .endorsement-number         { font-size: 14px; font-weight: 400; display: inline-block; margin-bottom: 10px;}
#my-liceneses .endorsement-status         { font-size: 12px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; }
#my-liceneses .endorsement-substatus      { font-size: 12px; font-weight: 400; color: #535252; display: inline-block; margin-bottom: 10px; }
#my-liceneses .endorsement-exp-date       { font-size: 12px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; }
#my-liceneses .endorsement-exp-date-value { font-size: 12px; font-weight: 400; color: #535252; }

/* Small Devices, Tablets */
@media only screen and (min-width : 768px) {
#my-liceneses .license-number         { display: inline; margin-bottom: 0;}
#my-liceneses .license-substatus      { display: inline; margin-bottom: 0; }
#my-liceneses .endorsement-number     { display: inline; margin-bottom: 0;}
#my-liceneses .endorsement-substatus  { display: inline; margin-bottom: 0; }
}
#my-liceneses .dropdown-toggle  {
min-width: 0;
padding: 8px 12px;
font-weight: 700;
text-transform: uppercase;
background-color: #cfd5db;
border-color: #a5a3a3;
border-radius: 5px;
font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif;
}
#my-liceneses .dropdown-toggle > .glyphicon  { padding-right: 0; }
#my-liceneses .btn-endorsement-apply {
color: #337ab7;
}
#my-liceneses .btn-endorsement-apply:hover {
color: #373a3c;
}
.dropdown-toggle:focus {
    outline: 1px dotted gray;
}
.nopadding { padding: 0 !important; }
.dashboard section{ padding:10px 0; }  
.modal-title {     border-bottom: 1px solid #bbb; padding-bottom: 6px; }
/* Custom, iPhone Retina */
@media only screen and (min-width : 320px) {}

/* Extra Small Devices, Phones */
@media only screen and (min-width : 480px) {}


/* Medium Devices, Desktops */
@media only screen and (min-width : 992px) {}

/* Large Devices, Wide Screens */
@media only screen and (min-width : 1200px) {}


#support h3 {
  font-size: 19px;
  line-height: 1.4;
  margin: 0;
}
#support label {
  color: #5C5C5C;
}
#support .panel-heading, #support .panel-body {
  border: 1px solid #a7a3a3;
}
#support .panel-heading {
  background-color: #fff;
  margin-bottom: 10px;
  overflow: hidden;
  padding: 12px 100px 12px 20px;
  position: relative;
}
#support .panel-heading h3{
	font-size: 16px;
}
#support .panel-body span > span > span {
	font-size: 1em !important;
}
#support .panel-heading .expand-toggle {
  position: absolute;
  top: 0;
  right: 20px;
  margin-top: 0px;
  padding: 15px 0 0 15px;
}
#support .panel-body {
  background-color: #eee;
  margin: -20px auto 10px auto;
  padding: 20px 20px 10px 20px;
  width: 98%;
}
.notification, .errorHidden, .hiddenText { 
  position: absolute; 
  overflow: hidden; 
  clip: rect(0 0 0 0); 
  height: 1px; width: 1px; 
  margin: -1px; padding: 0; border: 0; 
}
    .injectQuestions legend, #appInstructions legend{
        font-size:1em;
        margin-bottom: 0px;
        border: 0px;
    }
    #appInstructions fieldset{
        padding-bottom: 20px;
    }
    .checkBoxAlign{
        margin-top: 18px;
    }
    .quesItems legend{
        font-size:14px;
        border: 0px;
        margin-bottom: 2px;
    }
    .quesItems label {
        font-size: 14px;
        
    }
    .tiptextContainer{
        position: relative;
        margin-top: 30px;
        padding: 0px;
    }
    
/*# sourceMappingURL=main.css.map */
/* New WI */
.left-shift {
	margin-left: -15px;
}
.btn-padding{
	padding-top: 10px;
}
.btn-paddingMid, .addEduHistBtn, .updateEduHistBtn, .addEmpHistBtn, .updateEmpHistBtn, .addlvfHistBtn, .updatelvfHistBtn {
	padding-top: 20px;
}
.btn-paddingInline {padding-top: 24px;}
.footer-bottom{
	min-height: 90%;
}
.profileReadPanel div.row, .militaryInfoView div.row {
	margin-bottom:20px;
}
.educationalHistoryList, .lvfloymentHistoryList, .employmentHistoryList{ margin-bottom: 10px; }
.aliases_textarea {
	resize: none;
}
.profileLeftColumn {
	margin-right:20px;
}
.profileLeftColumn h2 {
	margin-top:0px; 
}
.primaryNav {margin:30px 0px; }
.primaryNav ul {margin-bottom: 0px;  border-bottom: 2px solid #074078;  height: 41px; padding-left: 60px;}
.primaryNav li.selected {  height: 41px; background-color: #FFF;}
.primaryNav li a {color: #FFF; text-decoration: none; }
.primaryNav li{
	list-style: none; 
	display: inline-block; 
	border-top-left-radius: 5px; 
	border-top-right-radius: 5px; 
	padding: 10px 30px;  
	margin: 0px 2px;
	border: 1px solid #074078; 
	border-bottom: 0px; 
	font-weight: bold; 
	font-family: "OpenSans-Regular", Verdana, Helvetica, sans-serif; 
	cursor: pointer; 
	background-color: #074078; 
	height:40px;
}
.primaryNav li.selected a{
	color: #074078;
}
.headerMain {
	width:100%;
	padding: 0px;
	margin: 0px;
}
.glyphicon-plus {
	padding-right:5px;
}
.sectionPadding, .rowPadding/*, .geo_address_edit_form */{
	padding-top:30px;
}
.dropdown-menu-right {
    right: 0px;
}
.dropdown-menuTable {
    right: 38px;
    min-width: 150px;
}
.btn-space {
	margin-left: 10px;
}
.textCenter {
	text-align: center;
}
#appendErrorList {
	min-height: 300px;
}

.savedSuccess .glyphicon-ok-sign, .savedSuccess span, .attestComplete, .appCompleted .glyphicon-ok-sign, .appCompleted span, .nameAttest {
    color: #197daf;
    font-weight: bold;
    padding-right: 5px;
}
.savedSuccess span{text-transform: uppercase;}
.ReadOnlybusinessAddress:not(:empty) {
    padding-bottom:20px;
}
.btn_container {
    display: inline-block;
	padding-bottom: 20px;
}
.eachNewAttachment h3 { margin-top: 0px;}
.fileRow { margin-bottom: 5px; }
.addAttachmentBtn{ width:100%; height:100%; }
.checkboxAlign{
    margin-top: 50px !important;
}
#fixedmessage {
	position: fixed; 
  	top:0px; left: 0px; 
    color: #FF0000; 
    font-weight: bold; 
    background-color: #FFCCCC; 
    width: 100%; 
    z-index: 999; 
    padding: 5px;      
}
.btn-file input[type=file] {
	position: absolute;
    top: 0;
    right: 0;
    min-width: 100%;
    min-height: 100%;
    font-size: 12px;
    text-align: right;
    filter: alpha(opacity=0);
    opacity: 0;
    background: red;
    cursor: inherit;
    display: block
}
.eSignCheck { background-color: #eae8e5;padding-top: 5px; padding-bottom: 5px;   }
.business-card, #individualForm {
    background-color: #fff;
    border: 1px solid #0A4e73;
    border-radius: 5px;
    padding: 30px;
    position: relative;
    margin-bottom: 20px;
}
main.dashboard, main#appInstructions, main#my-credentials, main#my-permits, main#my-planReview, main#cart, 
main.scheduler, main.confirmationPage, main.pageSection { min-height:85%; }
.appInstruction ul { padding-left: 25px; }
.addressHeader { font-weight: bold; padding-bottom: 3px;  }
.selectAllItems {background-color: #f9c118; border: 0px solid #cccccc; padding: 5px 5px 5px 10px;}
.feeTable > tbody > tr > td{ border: 1px solid #ccc;}    
panel-default>.panel-heading { color: #525051;  background-color: #DDD; }
.panel-default>.panel-heading { background-color: transparent; border-bottom: 1px solid #ccc; }
.panel-body {  padding: 0px; }
.panel-heading {  padding: 5px 15px; }
.selectAllItems label { margin-left: 3px; }
.panel-title label { font-size: 0.9em; }
.search-header .glyphicon-search { padding-right: 8px; font-size: 0.8em; }
.search-header .divider{ color: #f9c118; font-size: 1.5em; font-weight: bold; }
table#results thead tr th, table#resultsT thead tr th { white-space:nowrap; padding: 10px 8px; border-bottom: 0px; }
table#results, table#resultsT { border: 1px solid #ccc; }
.dataTables_wrapper table#results tr, .dataTables_wrapper table#resultsT tr { border:0px; }
.expanded-detail div.row > div { margin-left:0px; }
table.dataTable tbody tr.expanded-detail td { padding-left:0px;  }    
.table#results>tbody>tr>td, .table#resultsT>tbody>tr>td{ border-bottom: 0px; font-weight: normal; } 
.dataTables_wrapper table#results tbody tr.odd, 
.dataTables_wrapper table#results tbody tr.odd + tr.expanded-detail,
.dataTables_wrapper table#results tbody tr.odd + tr.expanded-detail td table tr,
.dataTables_wrapper table#resultsT tbody tr.odd, 
.dataTables_wrapper table#resultsT tbody tr.odd + tr.expanded-detail,
.dataTables_wrapper table#resultsT tbody tr.odd + tr.expanded-detail td table tr {  background-color: #fff; } 
.dataTables_wrapper table#results tbody tr.even,
.dataTables_wrapper table#results tbody tr.even + tr.expanded-detail,
.dataTables_wrapper table#results tbody tr.even + tr.expanded-detail td table tr,
.dataTables_wrapper table#resultsT tbody tr.even,
.dataTables_wrapper table#resultsT tbody tr.even + tr.expanded-detail,
.dataTables_wrapper table#resultsT tbody tr.even + tr.expanded-detail td table tr {  background-color: #efefef; } 
#resultTable, #resultTableTitle { margin-right: -15px; }
a.availableSlot {
   background-color: #f9c118;
   color: #333;
   border: 1px solid #c1a963;
   display: inline-block;
   padding: 3px;
   border-radius: 4px;
   font-size: 0.9em;
   margin-left: 5px;
}
    .schedulerTable .header{
        background: #1d4f81;
    }
    .schedulerTable th { text-align: center; }
    .schedulerTable .currentday{
        background-color:#cfd5db;
    }
    
    .monthBar{text-align:center; font-weight:bold; font-size:1.2em; border: 1px solid #333;
        background: #f9c118;
        padding: 3px 0px;
    }
    .schedulerTable .header tr {
        border: 2px solid #333;
        border-top: 0px;
    }
    #showCalendar a.navigationNext{
        display: inline; float: right; text-decoration:none; color:#000000;
    }
    #showCalendar a.navigationBack{
        display: inline; float: left; text-decoration:none; color:#333; padding: 0 0 0 15px;
    }
    #calendarbody td{
        width:14%;
        height:70px;
        border:1px solid #333;
        vertical-align: top;
    }
    .currentMonthStyle{
        font-weight:bold;
        padding-left:5px;
    }
    .pastNextMonthStyle{
        font-weight:bold;
        padding-left:5px;
        color:gray;
    }
    .dayoftheweek{
        color:#ffffff;
    }
    .leftPanel ul{
    padding-left: 15px;
    }