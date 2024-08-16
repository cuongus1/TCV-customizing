@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for EInvoice Payment Method'
define root view entity ZI_RAP_EINV_PAYM
  as select from zrap_einv_paym as EINVpaym
  //composition of target_data_source_name as _association_name
{
  key zlsch              as Zlsch,
      paymtext           as Paymtext,
      locallastchangedby as Locallastchangedby,
      locallastchangedat as Locallastchangedat,
      lastchangedat      as Lastchangedat
      //    _association_name // Make association public
}
