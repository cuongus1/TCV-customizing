@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for EInvoices Form Serial'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_RAP_EINV_SERIAL
  as select from zrap_einv_serial as EInvoiceSerial
  association to parent ZI_RAP_EINV_USER as _EInvoicesUser on  $projection.Companycode = _EInvoicesUser.Companycode
                                                           and $projection.Usertype    = _EInvoicesUser.Usertype
{
      @Search.defaultSearchElement: true
  key companycode as Companycode,
      @Search.defaultSearchElement: true
  key usertype    as Usertype,
  key fiscalyear  as Fiscalyear,
  key etype       as Etype,
      datetype    as Datetype,
      form        as Form,
      serial      as Serial,
      _EInvoicesUser
}
