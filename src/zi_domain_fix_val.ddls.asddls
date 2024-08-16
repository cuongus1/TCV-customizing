@EndUserText.label: 'Custom entity for Search Help'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.query.implementedBy: 'ABAP:ZCL_GET_DOMAIN_FIX_VALUES'
define root custom entity ZI_DOMAIN_FIX_VAL
  // with parameters parameter_name : parameter_type
{
      @EndUserText.label     : 'domain name'
      @UI.hidden  : true
  key domain_name : sxco_ad_object_name;
      @UI.hidden  : true
  key pos         : abap.numc( 4 );
      @EndUserText.label     : 'lower_limit'
      low         : abap.char( 10 );
      @EndUserText.label     : 'upper_limit'
      high        : abap.char(10);
      @EndUserText.label     : 'Description'
      description : abap.char(60);


}
