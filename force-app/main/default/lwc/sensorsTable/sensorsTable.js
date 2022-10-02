import { LightningElement, api, wire, track } from 'lwc';
import getSensorList from '@salesforce/apex/SensorConroller.getSensorList';
import deleteSensor from '@salesforce/apex/SensorConroller.deleteSensor';

const ACTIONS = [
    { label: 'Delete', name: 'delete' },
];
const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Sensor model', fieldName: 'Sensor_model__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Base Station', fieldName: 'Base_Station_Name__c' },
    {
        type: 'action',
        typeAttributes: { rowActions: ACTIONS },
    },
];

export default class SensorsTable extends LightningElement {
    @track data;
    @api idRecord;
    //@wire(getSensorList)
    /*wiredSensors({ error, data }) {
        if (data) {
            this.data = data;
            console.log(JSON.stringify(data));
        } else if (error) {
            console.log(error);
        } else {
            console.log('unknown error')
        }
    }*/
    columns = COLUMNS;
    record = {};

    pageSizeOptions = [10, 25, 50, 100, 200]; //Page size options
    records = []; //All records available in the data table
    totalRecords = 0; //Total no.of records
    pageSize; //No.of records to be displayed per page
    totalPages; //Total no.of pages
    pageNumber = 1; //Page number
    recordsToDisplay = []; //Records to be displayed on the page

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteSensorRecord(row);
                break;
            default:
        }
    }

    deleteSensorRecord(row) {
        this.idRecord = row.Id;
        deleteSensor({
            sensorId: this.idRecord
        })
            .then(answer => {
                if (answer) {
                    this.deleteRow(row);
                } else {
                    console.log('unknown error')
                }
            })
            .catch(error => {
                console.log(error)
            });
    }

    deleteRow(row) {
        const id = row.Id;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.data = this.data
                .slice(0, index)
                .concat(this.data.slice(index + 1));
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.data.some((row, index) => {
            if (row.Id === id) {
                ret = index;
                return true;
            }
            return false;
        });
        return ret;
    }

    get bDisableFirst() {
        return this.pageNumber == 1;
    }

    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    // connectedCallback method called when the element is inserted into a document
    connectedCallback() {
        // fetch contact records from apex method 
        getSensorList()
            .then((result) => {
                if (result != null) {
                    this.records = result;
                    this.totalRecords = result.length; // update total records count
                    this.pageSize = this.pageSizeOptions[0]; //set pageSize with default value as first option
                    this.paginationHelper(); // call helper menthod to update pagination logic
                }
            })
            .catch((error) => {
                console.log('error while fetch contacts--> ' + JSON.stringify(error));
            });
    }

    handleRecordsPerPage(event) {
        this.pageSize = event.target.value;
        this.paginationHelper();
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.paginationHelper();
    }

    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.paginationHelper();
    }

    firstPage() {
        this.pageNumber = 1;
        this.paginationHelper();
    }

    lastPage() {
        this.pageNumber = this.totalPages;
        this.paginationHelper();
    }


    // JS function to handel pagination logic 
    paginationHelper() {
        this.recordsToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }

        // set records to display on current page
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.recordsToDisplay.push(this.records[i]);
        }
    }
}