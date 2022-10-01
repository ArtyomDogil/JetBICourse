import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
//import PARSER from '@salesforce/resourceUrl/PapaParse';

export default class LoaderForCSV extends LightningElement {
    parserInitialized = false;
    /*renderedCallback() {
        if(!this.parserInitialized){
            loadScript(this, PARSER)
                .then(() => {
                    this.parserInitialized = true;
                })
                .catch(error => console.error(error));
        }
    }*/
}