@EndUserText.label: 'BO projection view Username Password'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_RAP_EINV_USER
  provider contract transactional_query
  as projection on ZI_RAP_EINV_USER as EInvoiceUser
{
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCode', element: 'CompanyCode' } }]
  key Companycode,

      @Search.defaultSearchElement: true
            @Consumption.valueHelpDefinition:
            [{ entity: { name : 'ZI_DOMAIN_FIX_VAL' , element: 'low' } ,
               additionalBinding: [{ element: 'domain_name',
                                     localConstant: 'ZDE_USERTYPE', usage: #FILTER }]
                                     , distinctValues: true
            }]
  key Usertype,
      Username,
      Password,
      Sellertax,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      /* Associations */
      _EInvoicesSerial : redirected to composition child ZC_RAP_EINV_SERIAL,
      _Companycode
}
