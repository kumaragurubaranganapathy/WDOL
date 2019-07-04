/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class GISAppController {
    @RemoteAction
    global static void assignToUser(Id objId, Id userId) {

    }
    @RemoteAction
    global static Map<String,List<MUSW.GISAppController.SObjectVO>> getActionLinks(MUSW.GISAppController.LinkParamVO params) {
        return null;
    }
    @RemoteAction
    global static List<User> getAllUsers() {
        return null;
    }
    @RemoteAction
    global static String getCreateRecordLink(MUSW.GISAppController.LinkParamVO param) {
        return null;
    }
    @RemoteAction
    global static Map<String,List<String>> getGeoFieldNames(List<String> objTypes) {
        return null;
    }
    @RemoteAction
    global static String getListViewDescribe(String objectName, String listViewId) {
        return null;
    }
    @RemoteAction
    global static MUSW.GISAppController.ResultVO getListViewResults(String objName, String encryptedListViewDescribe) {
        return null;
    }
    @RemoteAction
    global static List<MUSW.GISAppController.ListViewVO> getListViews(List<String> objNames) {
        return null;
    }
    @RemoteAction
    global static Map<String,String> getRecordTypes(String objType) {
        return null;
    }
    @RemoteAction
    global static MUSW.GISAppController.TokenVO getToken() {
        return null;
    }
    @RemoteAction
    global static MUSW.GISAppController.ResultVO queryDirectionRecords(String fieldsetName, String recordIds) {
        return null;
    }
    @RemoteAction
    global static MUSW.GISAppController.ResultVO searchByWhereClause(String whereClause, String objName, String listViewDescribeJSON) {
        return null;
    }
    @RemoteAction
    global static MUSW.GISAppController.ResultVO searchText(String txt, String objName, String listViewDescribeJSON) {
        return null;
    }
global class ActionLinkVO {
}
global class LinkParamVO {
    global LinkParamVO() {

    }
}
global class ListViewVO {
}
global class ResultVO {
}
global class TokenVO {
}
}
