@EndUserText.label: 'Parameter for Integration EInvoices'
@Metadata.allowExtensions: true
@Search.searchable: true
define abstract entity zrk_inte_einvoice
  //  with parameters parameter_name : parameter_type
{

  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCode', element: 'CompanyCode' } }]
//  @ObjectModel.text.element: [ 'companycode' ]
  @UI.selectionField: [{ position: 10 }]
  @EndUserText.label: 'Company code'
  companycode : bukrs;
//  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_RAP_SH_USERTYPE' , element: 'Zvalue' }
//  }]
//  @ObjectModel.text.element: [ 'usertype' ]
//  @ObjectModel: {
//    filter.enabled: false
//  }
  @EndUserText.label: 'User Type'
  @UI.selectionField: [{ position: 20 }]
  @UI.textArrangement: #TEXT_ONLY
  usertype    : zde_usertype;
  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_RAP_EINV_SERIAL' , element: 'Etype'  }}]
  @ObjectModel.text.element: [ 'usertype' ]
  @ObjectModel: {
    filter.enabled: false
  }
  @UI.selectionField: [{ position: 30 }]
  @EndUserText.label: 'EInvoice Type'
  @UI.textArrangement: #TEXT_ONLY
  etype       : zde_e_type;

  //  test_run    : abap.char(1);

}
