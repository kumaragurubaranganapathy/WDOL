// Constants
var maxSFFileSize = 25000000; // 25MB = 2.5e+7 bytes
var maxBBFileSize = 300000000; // 300MB = 3e+8 bytes
var BLUEBEAM = 'Bluebeam'; // Submission__c.BG_Destination__c picklist value
var SALESFORCE = 'Salesforce'; // Submission__c.BG_Destination__c picklist value

function UploadHelper() {

    /**
    * Checks that file is < max file size for the given destination
    * @param File file
    * @param String destination (Salesforce or Bluebeam)
    * @return Boolean
    */
    this.isFileSizeOkay = function(file, destination) {
        var valid = true;
        var maxSize = (destination === SALESFORCE) ? maxSFFileSize : maxBBFileSize;
        if (file.size > maxSize) {
            valid = false;
        }
        return valid;
    };

    /**
    * Checks that file is valid type 
    * @param File file
    * @param String destination (Salesforce or Bluebeam)
    * @return Boolean
    */
    this.isFileTypeOkay = function(file, destination) {
        var valid = false;
        var fileExtensions = ['dwg', 'zip', 'ps', 'pdf', 'txt'];
        var sftypes = ['image','text','video','audio'];
        var bbtypes = ['image'];
        var types = (destination === SALESFORCE) ? sftypes : bbtypes;
        var applicationSubtypes = ['msword',
                                    'vnd.ms-excel',
                                    'vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                    'vnd.openxmlformats-officedocument.wordprocessingml.document'];
        var fileExtension = file.name.split('.').pop().toLowerCase(); // grab the chunk of characters after last .
        if (fileExtensions.includes(fileExtension)) {
            valid = true;
        } else {
            // need to check types 
            var fulltype = file.type.split('/');
            var type = fulltype[0];
            var subtype = fulltype[1];
            if (types.includes(type)) {
                valid = true;
            } else if (type === 'application' && applicationSubtypes.includes(subtype)) {
                valid = true;
            }
        }
        return valid;
    };

    /**
    * Reads a file's content into a ContentVersion SObject. Is an async process, so this returns a promise which can be handled by caller
    * @param DOMelement input
    * @param File object
    * @param String submissionId (optional)
    * @return JQuery Deferred Promise
    */
    this.getDeferredFileReader = function(input, file, submissionId) {
        
        var reader = new FileReader();
        reader.file = file;
        if (!submissionId) {
            submissionId = input.dataset.submissionid;
        }
        
        var def = $j.Deferred();
        
        reader.onload = function(e) {
            var cv = new sforce.SObject("ContentVersion");
            cv.pathOnClient = this.file.name;
            cv.FirstPublishLocationId = submissionId;
            var binary = "";
            var bytes = new Uint8Array(e.target.result);
            var length = bytes.byteLength;
            for (var i=0;i<length;i++){
                binary += String.fromCharCode(bytes[i]);
            }
            cv.versionData = (new sforce.Base64Binary(binary)).toString();
            def.resolve(cv, submissionId);
        }
        reader.readAsArrayBuffer(file);
        return def.promise();
    };

    /**
    * Creates an ajax request uploading a file to the url provided
    * @param FileVO fileInfo - wrapper the contains file info including the url 
    * @param File - js file object - the file to be uploaded
    * @return Deferred promise
    */
    this.doAjaxUploadFile = function(fileInfo, fileObj) {
        return $j.ajax({
            type: 'PUT',
            crossOrigin: true,
            url: fileInfo.uploadUrl,
            contentType: false,
            processData: false,
            data: fileObj,
            beforeSend: function(xhr) {
                xhr.setRequestHeader('Access-Control-Allow-Methods', 'PUT');
                xhr.setRequestHeader('Access-Control-Allow-Origin', '*');
                xhr.setRequestHeader('Content-Type', fileInfo.contentType);
                xhr.setRequestHeader('x-amz-server-side-encryption', 'AES256');
            },
            xhr: function() {
                var thisxhr = new window.XMLHttpRequest();
                // this is where progress tracking per file can happen
                return thisxhr;
                
            },
            success: function(response) {
                // this file successfully uploaded
                console.log(response);
            },
            error: function(response){
                // error uploading this file
                console.log('error',response);
            }
        })
    };

    /**
    * Javascript representation of apex class UploadFilesController.BluebeamFileInfoVO
    * @param String projectId id of bb project where these files are going
    */
    this.BluebeamFileInfoVO = function(projectId) {
        this.projectId = projectId;
        this.fileInfos = [];
    };

    /**
    * Wrapper object to contain adhoc submissions and their related file
    * @param MUSW__Submission__c submission
    * @param File fileObj
    * @param Integer index - index in adhocSubmissions list 
    */
    this.SubmissionWrapper = function(submission, fileObj, index) {
        this.submission = submission; // MUSW__Submission__c 
        this.fileObj = fileObj;
        this.index = index;
        this.deleted = false;
    };

    /**
     * Takes list of parameters to send to Apex method and returns a promise to be handled by caller
     * once the function has completed. 
     * If isRetry is true and the call fails again, then the promise will be rejected, indicating that the token refresh is taking a long time or 
     * something is wrong.
     * @param String submissionIds 
     * @param String fileNames 
     * @param String parentId 
     * @param Boolean isRetry 
     * @return Promise
     */
    this.getBluebeamUploadUrls = function(submissionIds, fileNames, parentId, isRetry) {
        var def = $j.Deferred();
        // calls RemoteAction
        MUSW.UploadFilesController.retrieveBluebeamUploadUrls(submissionIds, fileNames, parentId,
        function(result, event) {
            if (event.status) {
                if (!result.success && isRetry){
                    // refreshing token is taking a long time - this is unlikely, and probably means something is wrong
                    def.reject('We are unable to process your file upload at this time. Please reload the page and try again.');
                } else {
                    def.resolve(result);
                }
            } else {
                def.reject(event.message);
            }
        },{escape:false});
        return def.promise();
    }

    this.handleGoBack = function(retUrl) { 
        if (retUrl[0] === '/') {
            retUrl = retUrl.substring(1);
        }
        if ('{!$User.UIThemeDisplayed}'  == 'Theme4d') {
            sforce.one.navigateToURL(retUrl);
        } else {
            window.location.assign('/' + retUrl);
        }
    }
}


// polyfill for IE so that can use includes() on arrays
// https://tc39.github.io/ecma262/#sec-array.prototype.includes
if (!Array.prototype.includes) {
Object.defineProperty(Array.prototype, 'includes', {
    value: function(searchElement, fromIndex) {

    if (this == null) {
        throw new TypeError('"this" is null or not defined');
    }

    // 1. Let O be ? ToObject(this value).
    var o = Object(this);

    // 2. Let len be ? ToLength(? Get(O, "length")).
    var len = o.length >>> 0;

    // 3. If len is 0, return false.
    if (len === 0) {
        return false;
    }

    // 4. Let n be ? ToInteger(fromIndex).
    //    (If fromIndex is undefined, this step produces the value 0.)
    var n = fromIndex | 0;

    // 5. If n ≥ 0, then
    //  a. Let k be n.
    // 6. Else n < 0,
    //  a. Let k be len + n.
    //  b. If k < 0, let k be 0.
    var k = Math.max(n >= 0 ? n : len - Math.abs(n), 0);

    function sameValueZero(x, y) {
        return x === y || (typeof x === 'number' && typeof y === 'number' && isNaN(x) && isNaN(y));
    }

    // 7. Repeat, while k < len
    while (k < len) {
        // a. Let elementK be the result of ? Get(O, ! ToString(k)).
        // b. If SameValueZero(searchElement, elementK) is true, return true.
        if (sameValueZero(o[k], searchElement)) {
        return true;
        }
        // c. Increase k by 1. 
        k++;
    }

    // 8. Return false
    return false;
    }
});
}