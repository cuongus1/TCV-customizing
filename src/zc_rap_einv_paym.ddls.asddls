@EndUserText.label: 'BO projection view for Payment Method'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_RAP_EINV_PAYM
  provider contract transactional_query
  as projection on ZI_RAP_EINV_PAYM as EINVpaym
{
  key Zlsch,
      Paymtext,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat
}
