.progress-bar {
 /* background-color: #535252;
  border-radius: 6px;
  height: 120px;
  justify-content: center;*/
  margin: 0 auto;
  display: flex;
  float: initial;
  min-width: 930px;
}
.progress-bar > .progress-section {
  border-radius: 5px;
  margin: 5px 2px;
  padding: 5px 10px;
}
.progress-bar > .progress-section:hover {
  background-color: #4b4b4b;
}
.progress-bar > .progress-section:hover > div > span {
  background-color: #4b4b4b;
}
.progress-bar > .progress-section > div {
  background-color: #999999;
  border-radius: 50%;
  height: 26px;
  margin: 15px auto;
  position: relative;
  width: 26px;
}
.progress-bar > .progress-section > div > span {
  background-color: #555555;
  border-radius: 50%;
  height: 22px;
  left: 2px;
  position: absolute;
  top: 2px;
  width: 22px;
}
.progress-bar > .progress-section.in-progress > div {
  background-image:
        linear-gradient(140deg, transparent 50%, #b5dc10 50%),
        linear-gradient(270deg, #b5dc10 50%, transparent 50%);
}
/* active colors should override in-progress colors */
.progress-bar > .progress-section.active {
  background-color: #424242;
}
.progress-bar > .progress-section.active > div > span {
  background-color: #424242;
}
.progress-bar > .progress-section.active:hover {
  background-color: #3a3a3a;
}
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
.progress-bar > .progress-section.error > div {
  background-color: #ff8768;
}
.progress-bar > .progress-section.error > div > span {
  background-color: #ff8768;
  background-image: url(../DDStyle/_assets/ic_exclamation_retina.png);
  background-repeat: no-repeat;
  background-position: 9px 4px;
  background-size: 4px;
}
.progress-bar > .progress-section > h6 {
  color: #ffffff;
}
SF Quick Metadata LookupVersion: 1.3
Search For
Apex ClassVisualForce Page Apex TriggerVF Component
Custom ObjectCustom SettingStatic ResourceUser
Search By
API NameLabelFilter By App
Search Result
For Suggestion and Issue Contact Me
