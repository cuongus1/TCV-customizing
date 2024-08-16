@EndUserText.label: 'Custom Entity for EInvoice Header'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_RAP_EINV_GENERATE'
    }
}
@UI:{
    headerInfo: { typeName: 'EInvoices General',
                  typeNamePlural: 'EInvoices General',
                  title: { type: #STANDARD, label: 'Document', value: 'accountingdocument' },
                  description: { value: 'accountingdocument'}
    }
//    presentationVariant: [{ sortOrder: [{ by: 'Accountingdocument', direction: #ASC }] }]
}
@Metadata.allowExtensions: true
@Search.searchable: true
define root custom entity zcs_rap_einv_header
  // with parameters parameter_name : parameter_type
{
      @UI.facet          : [{id : 'General',
                    purpose: #STANDARD,
                    position: 10,
                          isPartOfPreview: true,
                    label: 'General',
                    type : #COLLECTION,
                          targetQualifier: 'General'
                    },
                              {id : 'BasicInfo',
                    purpose: #STANDARD,
                    parentId       : 'General',
                    position       : 10,
                    isPartOfPreview: true,
                    label: 'Basic Info',
                    type :  #FIELDGROUP_REFERENCE,
                    targetQualifier: 'QFBasicInfo'
                     },
                              {id : 'Items',
                    purpose: #STANDARD,
                    type : #LINEITEM_REFERENCE,
                    label: 'Items',
                    position: 20,
                    targetElement: '_EInvoiceItems'
                      }
                     ]

      @Search.defaultSearchElement: true
      @UI.selectionField : [{ position: 30 }]
      @UI.lineItem       : [{ position: 30 },{ label: 'Update Status Invoices', dataAction: 'SearchEINV', type: #FOR_ACTION }]
      @UI.identification : [{ position: 30 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 30 ,  qualifier: 'QFBasicInfo'  }]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'I_CompanyCode' , element: 'CompanyCode' }}]
  key Companycode        : bukrs;

      @UI.selectionField : [{ position: 40 }]
      @UI.lineItem       : [{ position: 40 },{ label: 'Adjust Invoices', dataAction: 'AdjustEINV', type: #FOR_ACTION }]
      @UI.identification : [{ position: 40 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 40 ,  qualifier: 'QFBasicInfo'  }]
  key Accountingdocument : belnr_d;

      @UI.lineItem       : [{ position: 50 },{ label: 'Replace Invoices', dataAction: 'ReplaceEINV', type: #FOR_ACTION }]
      @UI.identification : [{ position: 50 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 50 ,  qualifier: 'QFBasicInfo'  }]
  key Fiscalyear         : gjahr;
      //   Iconsap;
      @UI.selectionField : [{ position: 10 }]
      @UI.lineItem       : [{ position: 10},{ label: 'Inetgration Invoices', dataAction: 'InteEINV', type: #FOR_ACTION }]
      @UI.identification : [{ position: 10 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 10 ,  qualifier: 'QFBasicInfo'  }]
      Iconsap            : zde_iconsap;

      @UI.selectionField : [{ position: 20 }]
      @UI.lineItem       : [{ position: 20 },{ label: 'Cancel Invoices', dataAction: 'CancelEINV', type: #FOR_ACTION }]
      @UI.identification : [{ position: 20 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 20 ,  qualifier: 'QFBasicInfo'  }]
      Statussap          : zde_estatus_sap;

      @UI.selectionField : [{ position: 60 }]
      @UI.lineItem       : [{ position: 60 }]
      @UI.identification : [{ position: 60 }]
      Postingdate        : budat;

      @UI.selectionField : [{ position: 70 }]
      @UI.lineItem       : [{ position: 70 }]
      @UI.identification : [{ position: 70 }]
      Documentdate       : bldat;

      @UI.lineItem       : [{ position: 80 }]
      @UI.identification : [{ position: 80 }]
      Entrydate          : zde_e_createdon;

      @UI.lineItem       : [{ position: 90 }]
      @UI.identification : [{ position: 90 }]
      Doctype            : blart;

      @UI.lineItem       : [{ position: 100 }]
      @UI.identification : [{ position: 100 }]
      Exchangerate       : zde_e_kursf;

      @UI.lineItem       : [{ position: 110 }]
      @UI.identification : [{ position: 110 }]
      Taxcode            : zde_mwskz;

      @UI.lineItem       : [{ position: 120 }]
      @UI.identification : [{ position: 120 }]
      @UI.selectionField : [{ position: 120 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 120 ,  qualifier: 'QFBasicInfo'  }]
      Customer           : zde_kunnr;

      @UI.lineItem       : [{ position: 130 }]
      @UI.identification : [{ position: 130 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 130 ,  qualifier: 'QFBasicInfo'  }]
      Bname              : zde_bname;

      @UI.lineItem       : [{ position: 140 }]
      @UI.identification : [{ position: 140 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 140 ,  qualifier: 'QFBasicInfo'  }]
      Baddr              : zde_baddr;

      @UI.lineItem       : [{ position: 150 }]
      @UI.identification : [{ position: 150 }]
      Bbank              : zde_e_bbank;

      @UI.lineItem       : [{ position: 160 }]
      @UI.identification : [{ position: 160 }]
      Bacct              : zde_e_bbankacct;

      @UI.lineItem       : [{ position: 170 }]
      @UI.identification : [{ position: 170 }]
      Btax               : zde_e_btax;

      @UI.lineItem       : [{ position: 180 }]
      @UI.identification : [{ position: 180 }]
      Bmail              : zde_e_bmail;

      @UI.lineItem       : [{ position: 190 }]
      @UI.identification : [{ position: 190 }]
      Btel               : zde_e_btel;

      @UI.selectionField : [{ position: 200 }]
      @UI.lineItem       : [{ position: 200 }]
      @UI.identification : [{ position: 200 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 200 ,  qualifier: 'QFBasicInfo'  }]
      Usertype           : zde_usertype;

      @UI.lineItem       : [{ position: 210 }]
      @UI.identification : [{ position: 210 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 210 ,  qualifier: 'QFBasicInfo'  }]
      Etype              : zde_e_type;

      @UI.lineItem       : [{ position: 220 }]
      @UI.identification : [{ position: 220 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 220 ,  qualifier: 'QFBasicInfo'  }]
      Form               : zde_e_form;

      @UI.lineItem       : [{ position: 230 }]
      @UI.identification : [{ position: 230 }]
      Serial             : zde_e_serial;

      @UI.lineItem       : [{ position: 240 }]
      @UI.identification : [{ position: 240 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 240 ,  qualifier: 'QFBasicInfo'  }]
      Seq                : zde_e_seq;

      @UI.lineItem       : [{ position: 250 }]
      @UI.identification : [{ position: 250 }]
      Datintegration     : zde_e_dateint;

      @UI.lineItem       : [{ position: 260 }]
      @UI.identification : [{ position: 260 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 260 ,  qualifier: 'QFBasicInfo'  }]
      Datissuance        : zde_e_dateph;

      @UI.lineItem       : [{ position: 270 }]
      @UI.identification : [{ position: 270 }]
      @UI.fieldGroup     : [ { type: #STANDARD,  position: 270 ,  qualifier: 'QFBasicInfo'  }]
      Timeissuance       : zde_e_timeph;

      @UI.lineItem       : [{ position: 280 }]
      @UI.identification : [{ position: 280 }]
      Datcancel          : zde_e_datecel;

      @UI.lineItem       : [{ position: 290 }]
      @UI.identification : [{ position: 290 }]
      Idkeyeinv          : zde_idkey_einv;

      @UI.lineItem       : [{ position: 300 }]
      @UI.identification : [{ position: 300 }]
      Zsearch            : zde_e_search;

      @UI.lineItem       : [{ position: 310 }]
      @UI.identification : [{ position: 310 }]
      Zreplace           : zde_e_replace;

      @UI.lineItem       : [{ position: 320 }]
      @UI.identification : [{ position: 320 }]
      Startdat           : zde_e_startdate;

      @UI.lineItem       : [{ position: 330 }]
      @UI.identification : [{ position: 330 }]
      Enddat             : zde_e_enddate;

      @UI.lineItem       : [{ position: 340 }]
      @UI.identification : [{ position: 340 }]
      Suppliertaxcode    : zde_e_suppliertaxcode;

      @UI.lineItem       : [{ position: 350 }]
      @UI.identification : [{ position: 350 }]
      Mscqt              : zde_e_mscqt;

      @UI.lineItem       : [{ position: 360 }]
      @UI.identification : [{ position: 360 }]
      Link               : zde_e_link;

      @UI.lineItem       : [{ position: 370 }]
      @UI.identification : [{ position: 370 }]
      Typedc             : zde_e_typedc;

      @UI.lineItem       : [{ position: 380 }]
      @UI.identification : [{ position: 380 }]
      Belnrsrc           : zde_e_belnrsrc;

      @UI.lineItem       : [{ position: 390 }]
      @UI.identification : [{ position: 390 }]
      Gjahrsrc           : zde_e_gjahrsrc;
      //   Statussap;

      @UI.lineItem       : [{ position: 400 }]
      @UI.identification : [{ position: 400 }]
      Statusinv          : zde_estatus_in;

      @UI.lineItem       : [{ position: 410 }]
      @UI.identification : [{ position: 410 }]
      Statuscqt          : zde_estatus_cqt;

      @UI.lineItem       : [{ position: 420 }]
      @UI.identification : [{ position: 420 }]
      Msgty              : zde_msg_ty;

      @UI.lineItem       : [{ position: 430 }]
      @UI.identification : [{ position: 430 }]
      Msgtx              : zde_msg_tx;

      @UI.hidden         : true
      Statussapold       : zde_estatussapold;
      @UI.hidden         : true
      Msgold             : zde_msg_tx;

      @UI.lineItem       : [{ position: 440 }]
      @UI.identification : [{ position: 440 }]
      Paym               : zde_e_paym;

      @UI.lineItem       : [{ position: 450 }]
      @UI.identification : [{ position: 450 }]
      @UI.selectionField : [{ position: 450 }]
      Currency           : waers;

      @UI.lineItem       : [{ position: 460 }]
      @UI.identification : [{ position: 460 }]
      Amount             : zde_e_amount;

      @UI.lineItem       : [{ position: 470 }]
      @UI.identification : [{ position: 470 }]
      Vat                : zde_e_vat;

      @UI.lineItem       : [{ position: 480 }]
      @UI.identification : [{ position: 480 }]
      Total              : zde_e_total;

      @UI.lineItem       : [{ position: 490 }]
      @UI.identification : [{ position: 490 }]
      Amountv            : zde_e_amountv;

      @UI.lineItem       : [{ position: 500 }]
      @UI.identification : [{ position: 500 }]
      Vatv               : zde_e_vatv;

      @UI.lineItem       : [{ position: 510 }]
      @UI.identification : [{ position: 510 }]
      Totalv             : zde_e_totalv;

      @UI.lineItem       : [{ position: 520 }]
      @UI.identification : [{ position: 520 }]
      Invdat             : zde_e_invdate;

      @UI.lineItem       : [{ position: 530 }]
      @UI.identification : [{ position: 530 }]
      Createdby          : zde_e_createdby;

      @UI.lineItem       : [{ position: 540 }]
      @UI.identification : [{ position: 540 }]
      Createdon          : zde_e_createdon;

      @UI.lineItem       : [{ position: 550 }]
      @UI.identification : [{ position: 550 }]
      Createdtime        : zde_e_createdtime;

      @UI.hidden         : true
      Stblg              : abap.char(10);
      @UI.hidden         : true
      Stjah              : fis_stjah_no_conv;
      @UI.hidden         : true
      Xreversing         : abap.char(1);
      @UI.hidden         : true
      Xreversed          : abap.char(1);
      @UI.hidden         : true
      Locallastchangedby : abp_locinst_lastchange_user;
      @UI.hidden         : true
      Locallastchangedat : abp_locinst_lastchange_tstmpl;
      @UI.hidden         : true
      Lastchangedat      : abp_lastchange_tstmpl;
      _EInvoiceItems     : composition [0..*] of zcs_rap_einv_items;

}
