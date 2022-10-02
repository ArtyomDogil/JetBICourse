import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveFile from '@salesforce/apex/UploaderCSVFileController.saveFile';

const MAX_FILE_SIZE = 1500000;
const OBJECT_NAMES = [
    { label: 'Base Station', value: 'BaseStation' },
    { label: 'Sensor', value: 'Sensor' },
];

export default class UploaderCsvFile extends LightningElement {
    @track showLoadingSpinner = false;
    @track typeOfObject = 'Sensor';
    file;
    fileContents;
    fileReader;
    objectNames = OBJECT_NAMES;

    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.file = event.target.files[0];
        }
    }

    handleChangeCombobox(event) {
        this.typeOfObject = event.detail.value;
    }

    handleSave() {
        if(this.file) {
            this.uploadHelper();
        } else {
            //this.fileName = 'Please select a CSV file to upload!!';
        }
    }

    uploadHelper() {
        if (this.file.size <= MAX_FILE_SIZE) {
            this.showLoadingSpinner = true;
            this.fileReader = new FileReader();
            this.fileReader.onloadend = (() => {
                this.fileContents = this.fileReader.result;
                this.saveToFile();
            });
            this.fileReader.readAsText(this.file);
        } else {
            //add Show Toast max file size
        }
    }

    saveToFile() {
        saveFile({ base64Data: JSON.stringify(this.fileContents), typeOfObject: this.typeOfObject})
        .then(() => {
            this.showLoadingSpinner = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: this.file.name + ' - Uploaded Successfully!',
                    variant: 'success',
                }),
            );
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
}
