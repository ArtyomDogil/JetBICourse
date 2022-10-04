import { LightningElement } from 'lwc';
export default class ParkingCloudComponent extends LightningElement {
    hanldeProgressValue(event) {
        this.template.querySelector('c-sensors-table').sensorTable();
    }
}