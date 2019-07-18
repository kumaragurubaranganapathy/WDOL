.dashboard a {
  color: #337ab7;
  text-decoration: none;
}

.dashboard a:focus, a:hover {
  color: #337ab7;
  text-decoration: underline;
}

.dashboard .license-container {
  background-color: #fff;
  border: 1px solid transparent;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05);
  margin-bottom: 20px;
}

.dashboard .no-license-container {
  background-color: transparent;
  border: 0;
  box-shadow: 0;
  margin-bottom: 20px;
}

.dashboard .license-placeholder {
    align-items: center;
    background-color: #f1f0ed;
    background: none;
    border: 2px solid #DDDDDD;
    display: flex;
    justify-content: center;
}

.dashboard .license-placeholder > div {
    border: 2px solid #BBBBBB;
    border-radius: 50%;
    height: 50px;
    margin: 0;
    padding: 0;
    position: relative;
    width: 50px;
}

.dashboard .license-placeholder > div:before {
    content: "+";
    color: #BBBBBB;
    font-size: 36px;
    font-weight: 100;
    left: 12px;
    position: absolute;
    top: -5px;
}

.dashboard .license-border {
  border: 3px double #d2d7db;
  margin: 10px
}

.dashboard .license,
.dashboard .endorsements {
  padding: 15px;
  position: relative;
}

.dashboard .license {
  height: 450px;
  margin: 0 10px;
 }

.dashboard .endorsements {
  background-color: #f1f1f1;
  height: 497px;
  overflow-y: auto;
}

.dashboard .license header,
.dashboard .endorsements header,
.dashboard .endorsement-item {
  align-items: center;
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #ccc;
  padding-bottom: 15px;
}

.dashboard .license header {
  justify-content: flex-start;
  margin-bottom: 25px;
}

.dashboard .endorsements header, .endorsement-item { margin-bottom: 15px; }

.dashboard .endorsements header h5 {
  color: #535352;
}

.dashboard .license header h3.header-img--license {
    background-image: url("../DDStyle/_assets/img_license_retina.png");
    background-repeat: no-repeat;
    background-size: contain;
    display: block;
    height: 50px;
    width: 120px;
    margin-bottom: 0;
    margin-right: 26px;
}

.dashboard .license header h3.header-img--license-business {
    background-image: url("../DDStyle/_assets/img_license_business_retina.png");
    background-repeat: no-repeat;
    background-size: contain;
    display: block;
    height: 50px;
    width: 120px;
    margin-bottom: 0;
    margin-right: 26px;
}

.dashboard .license header .vdivider {
  border-left: 2px solid #d2d7db;
  padding-left: 26px;
  height: 52px;
}

.dashboard .license header span {
  font-size: 16px;
  max-width: 175px;
}

.dashboard .license header,
.dashboard .endorsements header {
  flex-wrap: wrap;
}

.dashboard .endorsement-item:last-child {
  border-bottom: 0;
  margin-bottom: 15px;
  padding-bottom: 0;
}

.dashboard .license-type { margin-bottom: 10px }
.dashboard .license-type, .license-number { font-size: 21px }

.dashboard .license-badge {
  background-color: #73a4cc;
  padding: 4px 10px;
  position: absolute;
  top: 90px;
  width:98px;
  left:50%;
  margin-left:-50px;
  text-transform: uppercase;
}

.dashboard .license-status {
  font-size: 14px;
  font-weight: normal;
  text-transform: uppercase;
}

.dashboard .license-substatus {
  color: #535252;
  font-size: 14px;
  font-weight: normal;
  padding-left: 15px;
}

.dashboard .license-exp-date--current,
.dashboard .endorsement-exp-date--current {
  color: #535352;
  font-size: 14px;
  font-weight: 700;
}

.dashboard .license-exp-date--expired,
.dashboard .endorsement-exp-date--expired {
  color: #535352;
  font-size: 14px;
  font-style: italic;
  font-weight: 400;
}

.dashboard .btn {padding: 10px 18px;}

.dashboard .dropdown-toggle {
  /*color: #3b6280;*/
  font-weight: 700;
  padding: 10px 18px;
  text-transform: uppercase;
  /*border: 1px solid #3b6280;*/
}

.dashboard .dropdown-toggle  {
    min-width: 0;
    padding: 8px 12px;
}

.dashboard .dropdown-toggle > .glyphicon  { padding-right: 0; }

.dashboard .endorsement-type {
  font-size: 16px;
  font-weight: 700;
}

.dashboard .endorsement-status {
  color: #535252;
  font-weight: 700;
}

.dashboard .endorsement-substatus {
  color: #535252;
}

/* Custom Media Queries */
@media only screen and (max-width: 340px){
  .dashboard .license-badge {
    top: 113px;
  }
}

@media only screen and (max-width: 480px)  {
  .dashboard .vdivider {
    display: none;
  }
}

@media only screen and (min-width:768px) and (max-width: 1024px)  {
  .dashboard .vdivider {
    display: none;
  }
}

/* Custom, iPhone Retina */
@media only screen and (min-width : 320px) {


}

/* Extra Small Devices, Phones */
@media only screen and (min-width : 480px) {

  .dashboard .license {
    height: 375px;
  }

  .dashboard .endorsements {
    height: 422px;
  }

}

/* Small Devices, Tablets */
@media only screen and (min-width : 768px) {
  .dashboard .license {
    height: 450px;
  }

  .dashboard .endorsements {
    height: 497px;
  }
}

/* Medium Devices, Desktops */
@media only screen and (min-width : 992px) {

}

/* Large Devices, Wide Screens */
@media only screen and (min-width : 1200px) {
  .dashboard .license {
    height: 375px;
  }

  .dashboard .endorsements {
    height: 421px;
  }
}

