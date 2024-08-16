@EndUserText.label: 'BO projection view Serial Form'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
//@Search.searchable: true
define view entity ZC_RAP_EINV_SERIAL
  as projection on ZI_RAP_EINV_SERIAL as EInvoiceSerial
{
  key Companycode,
  key Usertype,
  key Fiscalyear,

  key Etype,
      Datetype,
      Form,
      Serial,
      /* Associations */
      _EInvoicesUser : redirected to parent ZC_RAP_EINV_USER
}
