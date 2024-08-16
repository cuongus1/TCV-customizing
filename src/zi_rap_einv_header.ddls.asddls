@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'View for EInvoice Header'
define root view entity zi_rap_einv_header
  as select from zrap_einv_header as EInvoicesHeader
    inner join   I_JournalEntry   as Entry on  EInvoicesHeader.companycode        = Entry.CompanyCode
                                           and EInvoicesHeader.accountingdocument = Entry.AccountingDocument
                                           and EInvoicesHeader.fiscalyear         = Entry.FiscalYear
  composition [0..*] of zi_rap_einv_items as _EInvoiceItems
{
  key EInvoicesHeader.companycode        as Companycode,
  key EInvoicesHeader.accountingdocument as Accountingdocument,
  key EInvoicesHeader.fiscalyear         as Fiscalyear,
      EInvoicesHeader.iconsap            as Iconsap,
      EInvoicesHeader.postingdate        as Postingdate,
      EInvoicesHeader.documentdate       as Documentdate,
      EInvoicesHeader.entrydate          as Entrydate,
      EInvoicesHeader.doctype            as Doctype,
      EInvoicesHeader.exchangerate       as Exchangerate,
      EInvoicesHeader.taxcode            as Taxcode,
      EInvoicesHeader.customer           as Customer,
      EInvoicesHeader.bname              as Bname,
      EInvoicesHeader.baddr              as Baddr,
      EInvoicesHeader.bbank              as Bbank,
      EInvoicesHeader.bacct              as Bacct,
      EInvoicesHeader.btax               as Btax,
      EInvoicesHeader.bmail              as Bmail,
      EInvoicesHeader.btel               as Btel,
      EInvoicesHeader.usertype           as Usertype,
      EInvoicesHeader.etype              as Etype,
      EInvoicesHeader.form               as Form,
      EInvoicesHeader.serial             as Serial,
      EInvoicesHeader.seq                as Seq,
      EInvoicesHeader.datintegration     as Datintegration,
      EInvoicesHeader.datissuance        as Datissuance,
      EInvoicesHeader.timeissuance       as Timeissuance,
      EInvoicesHeader.datcancel          as Datcancel,
      EInvoicesHeader.idkeyeinv          as Idkeyeinv,
      EInvoicesHeader.zsearch            as Zsearch,
      EInvoicesHeader.zreplace           as Zreplace,
      EInvoicesHeader.startdat           as Startdat,
      EInvoicesHeader.enddat             as Enddat,
      EInvoicesHeader.suppliertaxcode    as Suppliertaxcode,
      EInvoicesHeader.mscqt              as Mscqt,
      EInvoicesHeader.link               as Link,
      EInvoicesHeader.typedc             as Typedc,
      EInvoicesHeader.belnrsrc           as Belnrsrc,
      EInvoicesHeader.gjahrsrc           as Gjahrsrc,
      EInvoicesHeader.statussap          as Statussap,
      EInvoicesHeader.statusinv          as Statusinv,
      EInvoicesHeader.statuscqt          as Statuscqt,
      EInvoicesHeader.msgty              as Msgty,
      EInvoicesHeader.msgtx              as Msgtx,
      EInvoicesHeader.statussapold       as Statussapold,
      EInvoicesHeader.msgold             as Msgold,
      EInvoicesHeader.paym               as Paym,
      EInvoicesHeader.currency           as Currency,
      EInvoicesHeader.amount             as Amount,
      EInvoicesHeader.vat                as Vat,
      EInvoicesHeader.total              as Total,
      EInvoicesHeader.amountv            as Amountv,
      EInvoicesHeader.vatv               as Vatv,
      EInvoicesHeader.totalv             as Totalv,
      EInvoicesHeader.invdat             as Invdat,
      EInvoicesHeader.createdby          as Createdby,
      EInvoicesHeader.createdon          as Createdon,
      EInvoicesHeader.createdtime        as Createdtime,
      Entry.ReverseDocument              as Stblg,
      Entry.ReverseDocumentFiscalYear    as Stjah,
      Entry.IsReversal                   as Xreversing,
      Entry.IsReversed                   as Xreversed,
      EInvoicesHeader.locallastchangedby as Locallastchangedby,
      EInvoicesHeader.locallastchangedat as Locallastchangedat,
      EInvoicesHeader.lastchangedat      as Lastchangedat,
      /* Make association public */
      _EInvoiceItems
}
