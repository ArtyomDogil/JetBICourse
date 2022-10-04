import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSensorList from '@salesforce/apex/SensorConroller.getSensorList';
import deleteSensor from '@salesforce/apex/SensorConroller.deleteSensor';
import getDefaultPageSize from '@salesforce/apex/SensorConroller.getDefaultPageSize';

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
    @track recordsToDisplay = [];
    @track totalPages; //Total no.of pages
    @track totalRecords = 0; //Total no.of records
    @api idRecord;

    defaultPageSize;
    columns = COLUMNS;
    record = {};
    pageSizeOptions = [10, 25, 50, 100, 200]; //Page size options
    records = []; //All records available in the data table
    pageSize; //No.of records to be displayed per page
    pageNumber = 1; //Page number

    @api sensorTable() {
        getSensorList()
            .then((result) => {
                if (result != null) {
                    this.records = result;
                    this.totalRecords = result.length;
                    this.paginationHelper();
                }
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while get records',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
    }

    // connectedCallback method called when the element is inserted into a document
    connectedCallback() {
        getDefaultPageSize()
            .then((result) => {
                if (result != null) {
                    this.defaultPageSize = result;
                    var options = this.template.querySelector('.slds-select').options;
                    for (var i=0; i<options.length; i++) {
                        if (this.defaultPageSize == options[i].value) {
                            options[i].selected = true;
                        }
                    }

                    getSensorList()
                        .then((result) => {
                            if (result != null) {
                                this.records = result;
                                this.totalRecords = result.length; // update total records count
                                this.pageSize = this.defaultPageSize; //set pageSize with default value as first option
                                this.paginationHelper(); // call helper menthod to update pagination logic
                            }
                        })
                        .catch((error) => {
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error while get records',
                                    message: error.message,
                                    variant: 'error',
                                }),
                            );
                        });
                }
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while get settigs',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
    }

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
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error while delete records',
                            message: 'Problem with delete',
                            variant: 'error',
                        }),
                    );
                }
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error while delete records',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
    }

    deleteRow(row) {
        const id = row.Id;
        const index = this.findRowIndexById(id);
        if (index !== -1) {
            this.records = this.records
                .slice(0, index)
                .concat(this.records.slice(index + 1));
            this.totalRecords = this.totalRecords - 1;
            this.paginationHelper();
        }
    }

    findRowIndexById(id) {
        let ret = -1;
        this.records.some((row, index) => {
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