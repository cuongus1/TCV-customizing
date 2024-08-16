@EndUserText.label: 'BO projection view EInvoice Items'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_RAP_EINV_ITEMS
  as projection on zi_rap_einv_items
{
  key Companycode,
  key Accountingdocument,
  key Fiscalyear,
  key Buzei,
      Material,
      Itemname,
      Noted,
      Taxcode,
      Taxpercentage,
      Quantity,
      Baseunit,
      Unittext,
      Price,
      Currency,
      Amount,
      Vat,
      Total,
      Pricev,
      Amountv,
      Vatv,
      Totalv,
      /* Associations */
      _EInvoicesHeader : redirected to parent ZC_RAP_EINV_HEADER
}
