import { LightningElement, api, wire, track } from 'lwc';
import getSensorList from '@salesforce/apex/SensorConroller.getSensorList';
import deleteSensor from '@salesforce/apex/SensorConroller.deleteSensor';
export default class SensorsTable extends LightningElement {
    @track data;
    @api idRecord;
    @wire(getSensorList)
    wiredSensors({ error, data }) {
        if (data) {
            this.data = data;
            console.log(JSON.stringify(data));
        } else if (error) {
            console.log(error);
        } else {
            console.log('unknown error')
        }
    }
    columns = columns;
    record = {};

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

}
const actions = [
    { label: 'Delete', name: 'delete' },
];
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Sensor model', fieldName: 'Sensor_model__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Base Station', fieldName: 'Base_Station__c' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];