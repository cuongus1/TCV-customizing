@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help For Accounting Document'
@Metadata.allowExtensions: true
define root view entity zi_sh_belnr
  as select from I_JournalEntry
  //composition of target_data_source_name as _association_name
{
      @UI.lineItem: [{ position: 10}]
      @UI.identification: [{ position: 10}]
      @EndUserText.label: 'Companycode'
  key CompanyCode                  as CompanyCode,
      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear                   as FiscalYear,
      @UI.lineItem: [{ position: 30}]
      @UI.identification: [{ position: 30}]
      @EndUserText.label: 'Accounting Document'
  key AccountingDocument           as AccountingDocument,
      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40}]
      @EndUserText.label: 'Accounting Document Type' 
      AccountingDocumentType       as AccountingDocumentType,
      @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50}]
      @EndUserText.label: 'Document Date' 
      DocumentDate                 as DocumentDate,
      @UI.lineItem: [{ position: 60 }]
      @UI.identification: [{ position: 60 }]
      @EndUserText.label: 'Posting Date'
      PostingDate                  as PostingDate,
      @UI.lineItem: [{ position: 70 }]
      @UI.identification: [{ position: 70 }]
      @EndUserText.label: 'Fiscal Period'
      FiscalPeriod                 as FiscalPeriod,
      @UI.lineItem: [{ position: 80 }]
      @UI.identification: [{ position: 80 }]
      @EndUserText.label: 'Created by User'
      AccountingDocCreatedByUser   as AccountingDocCreatedByUser,
      @UI.lineItem: [{ position: 90 }]
      @UI.identification: [{ position: 90 }]
      @EndUserText.label: 'Transaction Code'
      TransactionCode              as TransactionCode,
      @UI.lineItem: [{ position: 100 }]
      @UI.identification: [{ position: 100 }]
      @EndUserText.label: 'InterCompany Transaction'
      IntercompanyTransaction      as IntercompanyTransaction,
      @UI.lineItem: [{ position: 110 }]
      @UI.identification: [{ position: 110 }]
      @EndUserText.label: 'Document Reference ID'
      DocumentReferenceID          as DocumentReferenceID,
      @UI.lineItem: [{ position: 120 }]
      @UI.identification: [{ position: 120 }]
      @EndUserText.label: 'Transaction Currency'
      TransactionCurrency          as TransactionCurrency,
      @UI.lineItem: [{ position: 130 }]
      @UI.identification: [{ position: 130 }]
      @EndUserText.label: 'Reverse Document'
      ReverseDocument              as ReverseDocument,
      @UI.lineItem: [{ position: 140 }]
      @UI.identification: [{ position: 140 }]
      @EndUserText.label: 'Revese Fiscal Year'
      ReverseDocumentFiscalYear    as ReverseDocumentFiscalYear,
      @UI.lineItem: [{ position: 150 }]
      @UI.identification: [{ position: 150 }]
      @EndUserText.label: 'Ledger'
      Ledger                       as Ledger,
      @UI.lineItem: [{ position: 160 }]
      @UI.identification: [{ position: 160}]
      @EndUserText.label: 'Accounting Document Header text' 
      AccountingDocumentHeaderText as AccountingDocumentHeaderText,
      @UI.lineItem: [{ position: 170 }]
      @UI.identification: [{ position: 170}]
      @EndUserText.label: 'Exchange rate'
      AbsoluteExchangeRate         as AbsoluteExchangeRate
}
where
  CompanyCode = '6710'
