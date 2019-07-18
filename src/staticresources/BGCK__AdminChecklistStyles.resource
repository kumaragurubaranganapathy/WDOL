
/*Draggable/Sortable Styles*/
.drop-target {
	width: 100%;
	min-height: 65vh;
	max-height: 65vh;
	overflow-y: auto;
	background: white;
	border: 3px transparent inset;
}

.drop-target.over {
	border: 3px rgba(0,112,210, 0.8) inset;
}
.jq-draggable {
	width: 90%;
}

.ui-draggable.active-draggable, .ui-draggable.selected, .jq-draggable.selected {
	border: 2px solid rgb(0, 112, 210); 
	box-shadow: 0px 2px 4px 0px rgba(0,0,0,.40);
}
.jq-helper {
	border: 2px solid rgb(0, 112, 210); 
	box-shadow: 0px 2px 4px 0px rgba(0,0,0,.40);
	width: 300px;
	background: rgba(255,255,255,0.8);
}

/*Layout Styles*/

.collapsed-vertical.main-screen, .collapsed-vertical.init-screen {
	min-height: 0;
	max-height: 0;
	overflow: hidden;
}

.init-screen { 
	transition-property: min-height;
	transition-duration: 0.5s;
	transition-timing-function: ease;
}

.main-screen {
	transition-property: max-height;
	transition-duration: 0.5s;
	transition-timing-function: ease;
}

header.tab-header {
    border: 1px solid rgb(122, 124, 127);
    border-radius: 6px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    min-width: 60px;
    max-width: 60px;
    position: relative;
    box-shadow: 0px 0px 2px 1px rgb(137, 142, 150);
}

.tab-header h1 {
	position: absolute;
	top: 125px;
	left: -50px;
	width: 160px;
	transform: rotate(-90deg);
	text-align: center;

}

.tab-body.slds-size--1-of-1 {
	flex: 0 1 90%;
}
.tab-body.collapsed {
	width: 0%;
	overflow: hidden;
	padding: 0;
	flex: 0 !IMPORTANT;
}

.tab-body {
	overflow: hidden;
	transition-property: width;
	transition-duration: .5s;
	transition-timing-function: ease-in-out;
	padding: 0 1rem;
}

.section.slds-card {
	border: none;
	background: rgb(244, 246, 249);
}

.questions-scrollable {
	max-height: 100vh;
	overflow-y: auto;
}

.questions, .question-types {
	position: relative;
}

.sections-list {
	max-height: 90vh;
	overflow-y: auto;
}
/*Buttons & Typography*/

.add-new-section {
	position: absolute;
	top: 1%;
	right: 1%;
}

.add-new-section button {
	display: block;
	font-size: 50px;
}

.back-to-versions {
	position: absolute;
	top: 1%;
	left: 3px;
	z-index: 10;
}
.sortable-item.over {
	border: 2px dashed #000;
}
li.sortable-item.dragging {
	border-color: blue;
}

.collapsed-vertical .back-to-versions {
	display: none;
}

.bgck-bold {
	font-weight: bold;
}

/*Forms that sit on top of the table views*/

.form-wrapper {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	z-index: 100;
	background: white;
}

.form-wrapper.hidden {
	height: 0;
	overflow: hidden;
}
.slds-lookup__menu {
	display: block;
}
.slds-lookup__menu.slds-hide {
	display: none;
}


/*Dependent Questions*/
button.selected-subQ .slds-icon {
	fill: red;
}

.add-sub-question.active {
	border: 1px solid red;
}

/* DataTables */

.tab-body table.dataTable {
	border-collapse: collapse;
}

.tab-body tbody {
	border-left: 1px solid #111;
	border-right: 1px solid #111;
}

/*sizing */
.full-width {
	width: 100%;
}