@EndUserText.label: 'Parameter Adjust EInvoices'
define abstract entity ZRK_ADJUST_EINV 
  //  with parameters parameter_name : parameter_type
{
  @Consumption.valueHelpDefinition: [{ entity: {name: 'zc_rap_einv_header' , element: 'AccountingDocument' }
  }]
  @ObjectModel.text.element: [ 'Belnrsrc' ]
  @EndUserText.label: 'Adjust Document'
  Belnrsrc : zde_e_belnrsrc;
  @EndUserText.label: 'Adjust Fiscal Year'
  Gjahrsrc : zde_e_gjahrsrc;
//  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZC_RAP_SH_ADJTYPE' , element: 'Zvalue' }
//  }]
//  @ObjectModel.text.element: [ 'Typedc' ]
//  @ObjectModel : {
//    filter.enabled: false
//  }
  @UI.textArrangement: #TEXT_ONLY
  @EndUserText.label: 'Adjust Type'
  Typedc   : zde_e_typedc;

}
