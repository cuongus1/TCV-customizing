@EndUserText.label: 'Custom Entity for EInvoice Items'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_RAP_EINV_GENERATE'
    }
}
@UI:{
    headerInfo: { typeName: 'EInvoice Details Items',
                  typeNamePlural: 'EInvoice Details Items',
                  title: { type: #STANDARD, label: 'Document Item', value: 'Buzei' }
    }
//    presentationVariant: [{ sortOrder: [{ by: 'Buzei', direction: #ASC }] }]
}
define custom entity zcs_rap_einv_items
  // with parameters parameter_name : parameter_type
{
      @UI.facet              : [{ id: 'Items',
                  purpose    : #STANDARD,
                  type       : #IDENTIFICATION_REFERENCE,
                  label      : 'Items',
                  position   : 10
                   }]
      @UI.hidden             : true
  key companycode            : bukrs;
      @UI.hidden             : true
  key accountingdocument     : belnr_d;
      @UI.hidden             : true
  key fiscalyear             : gjahr;

      @UI.lineItem           : [{ position: 10 }]
      @UI.identification     : [{ position: 10 }]
  key buzei                  : buzei;

      @UI.lineItem           : [{ position: 20 }]
      @UI.identification     : [{ position: 20 }]
      material               : zde_matnr;

      @UI.lineItem           : [{ position: 30 }]
      @UI.identification     : [{ position: 30 }]
      itemname               : zde_tenhh;

      @UI.lineItem           : [{ position: 40 }]
      @UI.identification     : [{ position: 40 }]
      noted                  : zde_noted;

      @UI.lineItem           : [{ position: 50 }]
      @UI.identification     : [{ position: 50 }]
      taxcode                : zde_mwskz;

      @UI.lineItem           : [{ position: 60 }]
      @UI.identification     : [{ position: 60 }]
      taxpercentage          : zde_mwskzn;

      @UI.lineItem           : [{ position: 70 }]
      @UI.identification     : [{ position: 70 }]
      quantity               : zde_menge;

      @UI.lineItem           : [{ position: 80 }]
      @UI.identification     : [{ position: 80 }]
      baseunit               : meins;

      @UI.lineItem           : [{ position: 90 }]
      @UI.identification     : [{ position: 90 }]
      unittext               : zde_msehl;

      @UI.lineItem           : [{ position: 100 }]
      @UI.identification     : [{ position: 100 }]
      price                  : zde_e_price;

      @UI.lineItem           : [{ position: 110 }]
      @UI.identification     : [{ position: 110 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency', element: 'Currency' } }]
      @ObjectModel.text.element: [ 'Currency' ]
      currency               : waers;

      @UI.lineItem           : [{ position: 120 }]
      @UI.identification     : [{ position: 120 }]
      amount                 : zde_e_amount;

      @UI.lineItem           : [{ position: 130 }]
      @UI.identification     : [{ position: 130 }]
      vat                    : zde_e_vat;

      @UI.lineItem           : [{ position: 140 }]
      @UI.identification     : [{ position: 140 }]
      total                  : zde_e_total;

      @UI.lineItem           : [{ position: 150 }]
      @UI.identification     : [{ position: 150 }]
      pricev                 : zde_e_pricev;

      @UI.lineItem           : [{ position: 160 }]
      @UI.identification     : [{ position: 160 }]
      amountv                : zde_e_amountv;

      @UI.lineItem           : [{ position: 170 }]
      @UI.identification     : [{ position: 170 }]
      vatv                   : zde_e_vatv;

      @UI.lineItem           : [{ position: 180 }]
      @UI.identification     : [{ position: 180 }]
      totalv                 : zde_e_totalv;
      _EInvoices             : association to parent zcs_rap_einv_header on  $projection.companycode        = _EInvoices.companycode
                                                                         and $projection.accountingdocument = _EInvoices.accountingdocument
                                                                         and $projection.fiscalyear         = _EInvoices.FiscalYear;

}
