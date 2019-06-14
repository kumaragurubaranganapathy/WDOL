{
  "columns": [
    {
      "ascendingLabel": "Z-A",
      "descendingLabel": "A-Z",
      "fieldNameOrPath": "Name",
      "hidden": false,
      "label": "Number",
      "selectListItem": "Name",
      "sortDirection": "ascending",
      "sortIndex": 0,
      "sortable": true,
      "type": "string"
    },
    {
      "ascendingLabel": "Low to High",
      "descendingLabel": "High to Low",
      "fieldNameOrPath": "MUSW__Type__c",
      "hidden": false,
      "label": "Type",
      "selectListItem": "toLabel(MUSW__Type__c)",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": true,
      "type": "picklist"
    },
    {
      "ascendingLabel": "Low to High",
      "descendingLabel": "High to Low",
      "fieldNameOrPath": "MUSW__Priority__c",
      "hidden": false,
      "label": "Priority",
      "selectListItem": "toLabel(MUSW__Priority__c)",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": true,
      "type": "picklist"
    },
    {
      "ascendingLabel": "Low to High",
      "descendingLabel": "High to Low",
      "fieldNameOrPath": "MUSW__Status__c",
      "hidden": false,
      "label": "Status",
      "selectListItem": "toLabel(MUSW__Status__c)",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": true,
      "type": "picklist"
    },
    {
      "ascendingLabel": "New to Old",
      "descendingLabel": "Old to New",
      "fieldNameOrPath": "MUSW__Due_Date__c",
      "hidden": false,
      "label": "Due Date",
      "selectListItem": "MUSW__Due_Date__c",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": true,
      "type": "date"
    },
    {
      "ascendingLabel": "Ascending",
      "descendingLabel": "Descending",
      "fieldNameOrPath": "MUSW__Permit__r.Name",
      "hidden": false,
      "label": "Permit",
      "selectListItem": "MUSW__Permit__r.Name",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": true,
      "type": "reference"
    },
    {
      "ascendingLabel": "Ascending",
      "descendingLabel": "Descending",
      "fieldNameOrPath": "MUSW__Parcel__r.Name",
      "hidden": false,
      "label": "Parcel",
      "selectListItem": "MUSW__Parcel__r.Name",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": true,
      "type": "reference"
    },
    {
      "ascendingLabel": null,
      "descendingLabel": null,
      "fieldNameOrPath": "Id",
      "hidden": true,
      "label": "Record ID",
      "selectListItem": "Id",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": false,
      "type": "id"
    },
    {
      "ascendingLabel": null,
      "descendingLabel": null,
      "fieldNameOrPath": "CreatedDate",
      "hidden": true,
      "label": "Created Date",
      "selectListItem": "CreatedDate",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": false,
      "type": "datetime"
    },
    {
      "ascendingLabel": null,
      "descendingLabel": null,
      "fieldNameOrPath": "LastModifiedDate",
      "hidden": true,
      "label": "Last Modified Date",
      "selectListItem": "LastModifiedDate",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": false,
      "type": "datetime"
    },
    {
      "ascendingLabel": null,
      "descendingLabel": null,
      "fieldNameOrPath": "SystemModstamp",
      "hidden": true,
      "label": "System Modstamp",
      "selectListItem": "SystemModstamp",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": false,
      "type": "datetime"
    },
    {
      "ascendingLabel": null,
      "descendingLabel": null,
      "fieldNameOrPath": "MUSW__Permit__c",
      "hidden": true,
      "label": "Permit",
      "selectListItem": "MUSW__Permit__c",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": false,
      "type": "reference"
    },
    {
      "ascendingLabel": null,
      "descendingLabel": null,
      "fieldNameOrPath": "MUSW__Parcel__c",
      "hidden": true,
      "label": "Parcel",
      "selectListItem": "MUSW__Parcel__c",
      "sortDirection": null,
      "sortIndex": null,
      "sortable": false,
      "type": "reference"
    }
  ],
  "id": "00BS0000002VMqA",
  "orderBy": [
    {
      "fieldNameOrPath": "Name",
      "nullsPosition": "first",
      "sortDirection": "ascending"
    },
    {
      "fieldNameOrPath": "Id",
      "nullsPosition": "first",
      "sortDirection": "ascending"
    }
  ],
  "query":
    "SELECT Name, toLabel(MUSW__Type__c), toLabel(MUSW__Priority__c), toLabel(MUSW__Status__c), MUSW__Due_Date__c, MUSW__Permit__r.Name, MUSW__Parcel__r.Name, Id, CreatedDate, LastModifiedDate, SystemModstamp, MUSW__Permit__c, MUSW__Parcel__c FROM MUSW__Inspection__c WHERE (MUSW__Status__c > '23' AND MUSW__On_Itinerary__c = false AND Name like '%45%' AND MUSW__Permit__r.Name != 'a026000000LH9KeAAL' AND MUSW__Closed_DateTime__c >= 2014-06-05T15:25:00.000Z AND MUSW__Due_Date__c != 2014-06-05 AND MUSW__Duration__c < 10.7 AND MUSW__Description__c like '%he%' AND MUSW__Priority__c != '2 Normal') OR (NOT MUSW__Description__c like '%he%') ORDER BY Name ASC NULLS FIRST, Id ASC NULLS FIRST",
  "scope": "everything",
  "sobjectType": "MUSW__Inspection__c",
  "whereCondition": {
    "conditions": [
      {
        "conditions": [
          {
            "field": "MUSW__Status__c",
            "operator": "greaterThan",
            "values": ["'23'"]
          },
          {
            "field": "MUSW__On_Itinerary__c",
            "operator": "equals",
            "values": ["false"]
          },
          { "field": "Name", "operator": "like", "values": ["'%45%'"] },
          {
            "field": "MUSW__Permit__r.Name",
            "operator": "notEquals",
            "values": ["'a026000000LH9KeAAL'"]
          },
          {
            "field": "MUSW__Closed_DateTime__c",
            "operator": "greaterThanOrEqualTo",
            "values": ["2014-06-05T15:25:00.000Z"]
          },
          {
            "field": "MUSW__Due_Date__c",
            "operator": "notEquals",
            "values": ["2014-06-05"]
          },
          {
            "field": "MUSW__Duration__c",
            "operator": "lessThan",
            "values": ["10.7"]
          },
          {
            "field": "MUSW__Description__c",
            "operator": "like",
            "values": ["'%he%'"]
          },
          {
            "field": "MUSW__Priority__c",
            "operator": "notEquals",
            "values": ["'2 Normal"]
          }
        ],
        "conjunction": "and"
      },
      {
        "field": "MUSW__Description__c",
        "operator": "notLike",
        "values": ["'%he%'"]
      }
    ],
    "conjunction": "or"
  }
}
