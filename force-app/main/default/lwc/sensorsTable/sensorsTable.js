import { LightningElement, wire, track } from 'lwc';
import getSensorList from '@salesforce/apex/SensorConroller.getSensorList';
export default class SensorsTable extends LightningElement {
    @track data;
    @wire(getSensorList)
    wiredSensors({ error, data }) {
        if (data) {
            this.data = data;
            console.log(JSON.stringify(data));
        } else if (error) {
            console.log(error);
        }else{
            console.log('unknown error')
        }
    }
    columns = columns;
}
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Sensor model', fieldName: 'Sensor_model__c' },
    { label: 'Status', fieldName: 'Status__c' },
    { label: 'Base Station', fieldName: 'Base_Station__r.Name' }
];