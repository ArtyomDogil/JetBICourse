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
    @track fileName;
    file;
    fileContents;
    fileReader;
    objectNames = OBJECT_NAMES;

    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.file = event.target.files[0];
            this.fileName = this.file.name;
        }
    }

    handleChangeCombobox(event) {
        this.typeOfObject = event.detail.value;
    }

    handleSave() {
        if(this.file) {
            this.uploadHelper();
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'No file!',
                    message: 'No file to upload!',
                    variant: 'warning',
                }),
            );
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
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Max file size!',
                    message: 'Too big file!',
                    variant: 'error',
                }),
            );
            this.file = null;
            this.fileName = null;
        }
    }

    saveToFile() {
        saveFile({ csvString: JSON.stringify(this.fileContents), typeOfObject: this.typeOfObject})
        .then(result => {
            if (result) {
                this.fileName = null;
                const selectedEvent = new CustomEvent("progressvalue", {detail: true});
                this.dispatchEvent(selectedEvent);
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success!',
                        message: this.file.name + ' - Uploaded Successfully!',
                        variant: 'success',
                    }),
                );
                this.file = null;
            } else {
                this.showLoadingSpinner = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Data processing error',
                        message: this.file.name + ' - not loaded! Check the validity of the data',
                        variant: 'error',
                    }),
                );
                this.file = null;
                this.fileName = null;
            }
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: error.message,
                    variant: 'error',
                }),
            );
            this.file = null;
        });
    }
}