@EndUserText.label: 'Parameter for Cancel EInvoices'
@Metadata.allowExtensions: true

define abstract entity zrk_cancel_einv
  //  with parameters parameter_name : parameter_type
{
//  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_RAP_SH_USERTYPE' , element: 'Zvalue' }
//  }]
//  @ObjectModel.text.element: [ 'usertype' ]
//  @ObjectModel : {
//    filter.enabled: false
//  }
  @UI.textArrangement: #TEXT_ONLY
  @EndUserText.label: 'User Type'
  usertype     : zde_usertype;

//  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_RAP_SH_NOTITAX' , element: 'Zvalue' }
//  }]
//  @ObjectModel.text.element: [ 'noti_taxtype' ]
//  @ObjectModel : {
//    filter.enabled: false
//  }
  @UI.textArrangement: #TEXT_ONLY
  @EndUserText.label: 'Loại thông báo'
  noti_taxtype : abap.char(30);

  @EndUserText.label: 'Số thông báo'
  noti_taxnum  : abap.char(30);

  @EndUserText.label: 'Ngày CQT thông báo'
  noti_taxdt   : abap.char(50);

  @EndUserText.label: 'Địa danh'
  place        : abap.char(100);

  @EndUserText.label: 'Tính chất thông báo'
//  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_RAP_SH_NOTITYPE', element: 'Zvalue' } }]
  @ObjectModel.filter.enabled: false
  @UI.textArrangement: #TEXT_ONLY
  noti_type    : abap.char(30);

}
