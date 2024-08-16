@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for EInvoice Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_rap_einv_items
  as select from zrap_einv_items as EInvoiceItems
  association to parent zi_rap_einv_header as _EInvoicesHeader on  $projection.Companycode        = _EInvoicesHeader.Companycode
                                                               and $projection.Accountingdocument = _EInvoicesHeader.Accountingdocument
                                                               and $projection.Fiscalyear         = _EInvoicesHeader.Fiscalyear
{
  key companycode        as Companycode,
  key accountingdocument as Accountingdocument,
  key fiscalyear         as Fiscalyear,
  key buzei              as Buzei,
      material           as Material,
      itemname           as Itemname,
      noted              as Noted,
      taxcode            as Taxcode,
      taxpercentage      as Taxpercentage,
      quantity           as Quantity,
      baseunit           as Baseunit,
      unittext           as Unittext,
      price              as Price,
      currency           as Currency,
      amount             as Amount,
      vat                as Vat,
      total              as Total,
      pricev             as Pricev,
      amountv            as Amountv,
      vatv               as Vatv,
      totalv             as Totalv,
      /* Make association public */
      _EInvoicesHeader
}
