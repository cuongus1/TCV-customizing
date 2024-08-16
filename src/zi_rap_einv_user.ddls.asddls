@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Views For EInvoices Username password'
define root view entity ZI_RAP_EINV_USER
  as select from zrap_einv_user as EInvoiceUser
  composition [0..*] of ZI_RAP_EINV_SERIAL as _EInvoicesSerial
  association [1..1] to I_CompanyCode      as _Companycode on $projection.Companycode = _Companycode.CompanyCode
{
  key companycode        as Companycode,
  key usertype           as Usertype,
      username           as Username,
      password           as Password,
      sellertax          as Sellertax,
      locallastchangedby as Locallastchangedby,
      locallastchangedat as Locallastchangedat,
      lastchangedat      as Lastchangedat,
      /* Make association public */
      _EInvoicesSerial,
      _Companycode
}
