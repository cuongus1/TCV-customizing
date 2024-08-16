CLASS zcl_rap_einv_generate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_range_option,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_option,

           tt_ranges          TYPE TABLE OF ty_range_option,
           tt_rap_einv_header TYPE TABLE OF zrap_einv_header,
           tt_rap_einv_items  TYPE TABLE OF zrap_einv_items.


    CLASS-METHODS:
      "Create Contructor
      get_Instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_rap_einv_generate,

      get_document IMPORTING ir_bukrs TYPE tt_ranges
                             ir_belnr TYPE tt_ranges
                             ir_gjahr TYPE tt_ranges
                             iv_top   TYPE int8
                             iv_skip  TYPE int8
                   EXPORTING header   TYPE tt_rap_einv_header
                             items    TYPE tt_rap_einv_items,

      get_document_new IMPORTING ir_bukrs TYPE tt_ranges
                                 ir_belnr TYPE tt_ranges
                                 ir_gjahr TYPE tt_ranges
                                 iv_top   TYPE int8
                                 iv_skip  TYPE int8
                       EXPORTING header   TYPE tt_rap_einv_header
                                 items    TYPE tt_rap_einv_items,

      zget_buyer IMPORTING i_kunnr     TYPE zde_kunnr
                           is_bseg     TYPE i_operationalacctgdocitem
                 EXPORTING es_customer TYPE zst_e_customer
                           es_return   TYPE bapiret2.
    "Custom Entities
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: mo_instance TYPE REF TO zcl_rap_einv_generate.
    CLASS-DATA: gt_buyer TYPE SORTED TABLE OF zst_e_customer WITH UNIQUE KEY bcode.
ENDCLASS.



CLASS zcl_rap_einv_generate IMPLEMENTATION.
  METHOD get_instance.
    mo_instance = ro_instance = COND #( WHEN mo_instance IS BOUND
                                           THEN mo_instance
                                           ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD get_document.

    DATA: lt_einv_log  TYPE TABLE OF zrap_einv_header,
          ls_einv_log  TYPE zrap_einv_header,

          lt_einv_line TYPE TABLE OF zrap_einv_items,
          ls_einv_line TYPE zrap_einv_items.

    SELECT   a~companycode ,
             a~accountingdocument,
             a~fiscalyear,
             a~billingdocument,
             a~accountingdocumentitem,
             a~postingdate,
             a~documentdate,
             a~financialaccounttype,
             a~accountingdocumenttype,
             a~postingkey,
             a~debitcreditcode,
             a~glaccount,
             a~customer,
             a~taxcode,
             a~product,
             a~material,
             a~documentitemtext,
             a~baseunit,
             a~quantity,
             a~amountintransactioncurrency, "
             a~amountincompanycodecurrency, "Local
             a~transactioncurrency,
             a~PaymentMethod,
             c~seq,
             c~serial,
             c~form,
             b~absoluteexchangerate,
             b~reversedocument,
             b~reversedocumentfiscalyear,
             b~isreversal,
             b~isreversed
      FROM i_operationalacctgdocitem AS a
      INNER JOIN i_journalentry AS b
          ON  a~companycode = b~companycode
          AND a~accountingdocument = b~accountingdocument
          AND a~fiscalyear = b~fiscalyear
      LEFT OUTER JOIN zrap_einv_header AS c
          ON  a~companycode = c~companycode
          AND a~accountingdocument = c~accountingdocument
          AND a~fiscalyear = c~fiscalyear
      WHERE a~CompanyCode IN @ir_bukrs
        AND a~AccountingDocument IN @ir_belnr
        AND a~FiscalYear IN @ir_gjahr
        AND a~glaccount NOT LIKE '333%'
        AND ( a~taxcode LIKE 'O%'
          OR a~taxcode = '**' )
      ORDER BY a~companycode, a~accountingdocument, a~fiscalyear
      INTO TABLE @DATA(lt_bseg) .

    DATA: lv_count TYPE int4 VALUE IS INITIAL.
    DATA: ls_bseg      LIKE LINE OF lt_bseg,
          ls_bseg_temp LIKE LINE OF lt_bseg.
    DATA: lv_index         TYPE sy-tabix VALUE IS INITIAL,
          lv_PaymentMethod TYPE zde_e_paym.

    "Customer Details
    DATA: ex_customer  TYPE zst_e_customer,
          ex_return    TYPE bapiret2,
          im_bseg      TYPE i_operationalacctgdocitem,
          lv_mwskz_old TYPE zde_mwskz,
          flag_mwskz   TYPE char1.

    CLEAR: lv_count.

    SORT lt_bseg BY companycode accountingdocument fiscalyear accountingdocumentitem ASCENDING.

    LOOP AT lt_bseg INTO ls_bseg WHERE ( FinancialAccountType EQ `K` OR FinancialAccountType EQ 'D' )
    AND TaxCode IS NOT INITIAL AND seq IS INITIAL.
      MOVE-CORRESPONDING ls_bseg TO ls_bseg_temp.
      AT NEW fiscalyear.
        CLEAR: lv_index, lv_mwskz_old, flag_mwskz.
      ENDAT.

      lv_index = lv_index + 1.
      "Buzei
      ls_einv_line-buzei = lv_index.
      "Company code
      ls_einv_line-companycode = ls_bseg_temp-companycode.
      "Document Acounting
      ls_einv_line-accountingdocument = ls_bseg_temp-accountingdocument.
      "Fiscal Year
      ls_einv_line-fiscalyear = ls_bseg_temp-fiscalyear.
      "Material
      ls_einv_line-material = ls_bseg_temp-product.
      "Tên hàng hoá
      ls_einv_line-itemname = ls_bseg_temp-documentitemtext.
      "Quantiy
      ls_einv_line-quantity = ls_bseg_temp-quantity.
      "Đơn vị
      ls_einv_line-baseunit = ls_bseg_temp-baseunit.
      "Đơn vị text
      SELECT SINGLE unitofmeasurelongname FROM i_unitofmeasuretext
      WHERE unitofmeasure = @ls_bseg_temp-baseunit INTO @ls_einv_line-unittext.
      "Taxcode
      IF lv_mwskz_old IS NOT INITIAL AND lv_mwskz_old NE ls_bseg_temp-taxcode.
        ls_einv_log-taxcode = 'Nhiều loại'.
        flag_mwskz = 'X'.
      ELSE.
        ls_einv_log-taxcode = ls_bseg_temp-taxcode.
      ENDIF.

      "Currency
      ls_einv_line-currency = ls_bseg_temp-transactioncurrency.

      ls_einv_line-taxcode = ls_bseg_temp-taxcode.
      lv_mwskz_old = ls_bseg_temp-taxcode.

      CASE ls_bseg_temp-taxcode.
        WHEN 'O1'.
          ls_einv_line-taxpercentage = 0.
        WHEN 'O2'.
          ls_einv_line-taxpercentage = 5.
        WHEN 'O3'.
          ls_einv_line-taxpercentage = 8.
        WHEN 'O4'.
          ls_einv_line-taxpercentage = 10.
        WHEN OTHERS.
      ENDCASE.

      IF ls_bseg_temp-PaymentMethod IS NOT INITIAL.
        lv_PaymentMethod = ls_bseg_temp-PaymentMethod.
      ENDIF.

      "Amount
      ls_einv_line-amount  = ls_bseg_temp-amountintransactioncurrency.
      "VAT
      ls_einv_line-vat     = ls_bseg_temp-amountintransactioncurrency * ls_einv_line-taxpercentage / 100.
      "Total
      ls_einv_line-total   = ls_einv_line-amount + ls_einv_line-vat.
      "Amount Local
      ls_einv_line-amountv = ls_bseg_temp-amountincompanycodecurrency.
      "VAT Local
      ls_einv_line-vatv    = ls_bseg_temp-amountincompanycodecurrency * ls_einv_line-taxpercentage / 100.
      "Total Local
      ls_einv_line-total   = ls_einv_line-amountv + ls_einv_line-vatv.

      APPEND ls_einv_line TO lt_einv_line.

      "Process Total Document
      "Company code
      ls_einv_log-companycode = ls_bseg_temp-companycode.
      "Document Acounting
      ls_einv_log-accountingdocument = ls_bseg_temp-accountingdocument.
      "Fiscal Year
      ls_einv_log-fiscalyear = ls_bseg_temp-fiscalyear.
      "Budat
      ls_einv_log-postingdate = ls_bseg_temp-postingdate.
      "Document Date
      ls_einv_log-documentdate = ls_bseg_temp-documentdate.
      "Doc type
      ls_einv_log-doctype = ls_bseg_temp-accountingdocumenttype.
      "Exchange rate
      ls_einv_log-exchangerate = ls_bseg_temp-absoluteexchangerate.
      "Currency
      ls_einv_log-currency = ls_bseg_temp-transactioncurrency.
      "Customer
      CLEAR: im_bseg.
      im_bseg-companycode = ls_bseg_temp-companycode.
      im_bseg-accountingdocument = ls_bseg_temp-accountingdocument.
      im_bseg-fiscalyear = ls_bseg_temp-fiscalyear.

      zcl_rap_einv_generate=>get_instance( )->zget_buyer(
        EXPORTING
          i_kunnr     = ls_bseg_temp-customer
          is_bseg     = im_bseg
        IMPORTING
          es_customer = ex_customer
          es_return   = ex_return
      ).
      ls_einv_log-customer = ls_bseg_temp-customer.
      ls_einv_log-bname = ex_customer-bname.
      ls_einv_log-baddr = ex_customer-baddr.
      ls_einv_log-btax  = ex_customer-btax.
      ls_einv_log-bmail = ex_customer-bmail.
      ls_einv_log-btel  = ex_customer-btel.

      "Flag reverse document
      ls_einv_log-stblg      = ls_bseg_temp-reversedocument.
      ls_einv_log-stjah      = ls_bseg_temp-reversedocumentfiscalyear.
      ls_einv_log-xreversing = ls_bseg_temp-isreversal.
      ls_einv_log-xreversed  = ls_bseg_temp-isreversed.

      "Amount
      ls_einv_log-amount  = ls_einv_line-amount.
      "VAT
      ls_einv_log-vat     = ls_einv_line-vat.
      "Total
      ls_einv_log-total   = ls_einv_line-amount + ls_einv_line-vat.
      "Amount Local
      ls_einv_log-amountv = ls_einv_line-amountv.
      "VAT Local
      ls_einv_log-vatv    = ls_einv_line-vatv.
      "Total Local
      ls_einv_log-total   = ls_einv_line-amountv + ls_einv_line-vatv.

      COLLECT ls_einv_log INTO lt_einv_log.
      CLEAR: ls_einv_log, ls_einv_line.

      AT END OF fiscalyear.
        READ TABLE lt_einv_log ASSIGNING FIELD-SYMBOL(<ls_einv_log>) WITH KEY companycode = ls_bseg_temp-companycode
                                                                              accountingdocument = ls_bseg_temp-accountingdocument
                                                                              fiscalyear = ls_bseg_temp-fiscalyear BINARY SEARCH.
        IF sy-subrc NE 0.

        ENDIF.

        "Đánh dấu nhiều loại thuế xuất
        IF flag_mwskz IS NOT INITIAL.
          <ls_einv_log>-taxcode = 'Nhiều loại'.
        ELSE.
          <ls_einv_log>-taxcode = lv_mwskz_old.
        ENDIF.

        "PaymentMethod
        <ls_einv_log>-Paym = lv_PaymentMethod.
        CLEAR: lv_paymentmethod.

        SELECT SUM( amountintransactioncurrency ) AS sum_vat, "
               SUM( amountincompanycodecurrency ) AS sum_vatv "Local
        FROM i_operationalacctgdocitem
        WHERE companycode = @ls_bseg_temp-companycode
          AND accountingdocument = @ls_bseg_temp-accountingdocument
          AND fiscalyear = @ls_bseg_temp-fiscalyear
          AND glaccount LIKE '333%'
          AND ( taxcode LIKE 'O%' OR taxcode = '**' )
          INTO @DATA(ls_sum_vat).
        IF sy-subrc EQ 0.
          IF <ls_einv_log>-vat NE ls_sum_vat-sum_vat OR <ls_einv_log>-vatv NE ls_sum_vat-sum_vatv.

            READ TABLE lt_einv_line ASSIGNING FIELD-SYMBOL(<ls_einv_line>) WITH KEY companycode = ls_bseg_temp-companycode
                                                                                    accountingdocument = ls_bseg_temp-accountingdocument
                                                                                    fiscalyear = ls_bseg_temp-fiscalyear buzei = lv_index BINARY SEARCH.
            IF sy-subrc EQ 0.
              <ls_einv_line>-vat = <ls_einv_line>-vat + ls_sum_vat-sum_vat - <ls_einv_log>-vat.
              <ls_einv_line>-vatv = <ls_einv_line>-vatv + ls_sum_vat-sum_vatv - <ls_einv_log>-vatv.

              <ls_einv_line>-total = <ls_einv_line>-vat + <ls_einv_line>-amount.
              <ls_einv_line>-total = <ls_einv_line>-vatv + <ls_einv_line>-amountv.
            ENDIF.

            <ls_einv_log>-vat = ls_sum_vat-sum_vat.
            <ls_einv_log>-vatv = ls_sum_vat-sum_vatv.

            <ls_einv_log>-total = <ls_einv_log>-vat + <ls_einv_log>-amount.
            <ls_einv_log>-totalv = <ls_einv_log>-vatv + <ls_einv_log>-amountv.
          ENDIF.
        ENDIF.
      ENDAT.
    ENDLOOP.

    IF iv_skip > 0.
      DELETE lt_einv_log TO iv_skip.
    ENDIF.

    SELECT * FROM @lt_einv_log AS alias_einv_log
    INTO CORRESPONDING FIELDS OF TABLE @header UP TO @iv_top ROWS.

    WAIT UP TO 2 SECONDS.

    IF header IS NOT INITIAL.
      LOOP AT lt_einv_line INTO ls_einv_line.
        READ TABLE header TRANSPORTING NO FIELDS WITH KEY companycode = ls_einv_line-Companycode
                                                          Accountingdocument = ls_einv_line-Accountingdocument
                                                          Fiscalyear = ls_einv_line-Fiscalyear BINARY SEARCH.
        IF sy-subrc EQ 0.
          APPEND CORRESPONDING #( ls_einv_line ) TO items.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD zget_buyer.
    DATA: lv_flag TYPE char1 VALUE IS INITIAL. "Flag mã khách lẻ

    READ TABLE gt_buyer INTO DATA(ls_buyer) WITH KEY bcode = i_kunnr BINARY SEARCH.
    IF sy-subrc EQ 0.

      MOVE-CORRESPONDING ls_buyer TO es_customer.
    ELSE.

      SELECT SINGLE
      businesspartnername1 AS name1,
      businesspartnername2 AS name2,
      businesspartnername3 AS name3,
      businesspartnername4 AS name4, streetaddressname AS stras,
      cityname AS ort01,
      taxid1 AS stcd1,
      accountingclerkinternetaddress AS intad
      FROM i_onetimeaccountcustomer
      WHERE accountingdocument = @is_bseg-accountingdocument AND
            companycode = @is_bseg-companycode AND
            fiscalyear = @is_bseg-fiscalyear
      INTO @DATA(ls_bsec).

      IF sy-subrc EQ 0. "Nếu Mã khách lẻ
        lv_flag = 'X'.
        es_customer-bname = |{ ls_bsec-name1 } { ls_bsec-name2 }{ ls_bsec-name3 } { ls_bsec-name4 } | .
        es_customer-baddr = |{ ls_bsec-stras }, { ls_bsec-ort01 }| .
        es_customer-btax  = ls_bsec-stcd1.
        es_customer-bmail = ls_bsec-intad.
      ELSE. "Trường hợp ko phải Mã khách lẻ
        CLEAR: ls_bsec.
        SELECT SINGLE customer, businesspartneruuid AS partner_guid
        FROM i_customertobusinesspartner  "cvi_cust_link
        WHERE customer = @i_kunnr
        INTO @DATA(ls_cust_link).
        IF sy-subrc EQ 0.
          SELECT
           businesspartner AS partner,
           businesspartnercategory AS type,
           organizationbpname1 AS name_org1,
           organizationbpname2 AS name_org2,
           organizationbpname3 AS name_org3,
           organizationbpname4 AS name_org4,
           firstname AS name_first,
           lastname AS name_last
          FROM i_businesspartner "but000
          WHERE businesspartneruuid = @ls_cust_link-partner_guid
          INTO TABLE @DATA(lt_but000).
          IF sy-subrc NE 0.
            es_return-type = 'E'.
            es_return-message = TEXT-101 && ` ` && i_kunnr.
            RETURN.
          ENDIF.
        ELSE.
          SELECT
           businesspartner AS partner,
           businesspartnercategory AS type,
           organizationbpname1 AS name_org1,
           organizationbpname2 AS name_org2,
           organizationbpname3 AS name_org3,
           organizationbpname4 AS name_org4,
           firstname AS name_first,
           lastname AS name_last
          FROM i_businesspartner "but000
          WHERE businesspartner = @i_kunnr
          INTO TABLE @lt_but000.
          IF sy-subrc NE 0.
            es_return-type = 'E'.
            es_return-message = TEXT-101 && ` ` && i_kunnr.
            RETURN.
          ENDIF.
        ENDIF.

        IF lt_but000 IS NOT INITIAL.
          READ TABLE lt_but000 INTO DATA(ls_but000) INDEX 1.
***"{ Customer Name
          IF ls_but000-type <> 1.
            es_customer-bname = |{ ls_but000-name_org2 } { ls_but000-name_org3 } { ls_but000-name_org4 }|.
            IF es_customer-bname IS INITIAL.
              es_customer-bname = |{ ls_but000-name_org1 }|.
            ENDIF.
          ELSEIF ls_but000-type = 1.
            es_customer-bname = |{ ls_but000-name_first } { ls_but000-name_last }|.
          ELSE.
          ENDIF.

          SELECT
          businesspartner AS partner,
          addressid AS addrnumber
          FROM i_buspartaddress "but020
          WHERE businesspartner = @ls_but000-partner
          INTO TABLE @DATA(lt_but020).
          IF sy-subrc NE 0.
            FREE: lt_but020.
          ENDIF.

          SORT lt_but020 BY addrnumber DESCENDING.
          READ TABLE lt_but020 INTO DATA(ls_but020) INDEX 1.
***"{ Customer Address
          SELECT SINGLE
          streetname AS street,
          streetprefixname1 AS str_suppl1,
          streetprefixname2 AS str_suppl2,
          streetsuffixname1 AS str_suppl3,
          streetsuffixname2 AS location,
          cityname AS city1,
          districtname AS city2,
          country AS country
          FROM i_personaddress "adrc
          WHERE addressid = @ls_but020-addrnumber
          INTO @DATA(ls_adrc).
          IF sy-subrc = 0.
            IF ls_adrc-str_suppl1 IS INITIAL.
              es_customer-baddr =   |{ ls_adrc-street }, { ls_adrc-str_suppl2 }, { ls_adrc-str_suppl3 }, { ls_adrc-location }, { ls_adrc-city2 }, { ls_adrc-city1 }|.
            ELSE.
              es_customer-baddr =   |{ ls_adrc-street } { ls_adrc-str_suppl1 }, { ls_adrc-str_suppl2 }, { ls_adrc-str_suppl3 }, { ls_adrc-location }, { ls_adrc-city2 }, { ls_adrc-city1 }|.
            ENDIF.
          ENDIF.
***"{ Customer tax
          SELECT SINGLE bpidentificationnumber AS idnumber
          FROM i_bupaidentification "but0id
          WHERE businesspartner = @ls_but000-partner
          AND bpidentificationtype = 'VATRU'
          INTO @es_customer-btax.

***"{ Customer Mail
          SELECT addressid AS addrnumber, emailaddress AS smtp_addr
          FROM i_addressemailaddress_2 "adr6
          WHERE addressid  = @ls_but020-addrnumber
          INTO TABLE @DATA(lt_adr6).
          IF sy-subrc NE 0.
            FREE: lt_adr6.
          ENDIF.
          LOOP AT lt_adr6 INTO DATA(ls_adr6).
            es_customer-bmail =  es_customer-bmail  && ';' && ls_adr6-smtp_addr.
          ENDLOOP.

          IF es_customer-bmail IS NOT INITIAL AND es_customer-bmail(1) = ';'.
            es_customer-bmail = es_customer-bmail+1.
          ENDIF.
***"{ Customer Phone
          SELECT addressid AS addrnumber,
                 phoneareacodesubscribernumber AS tel_number
          FROM i_addressphonenumber_2 "adr2
          WHERE addressid = @ls_but020-addrnumber
          INTO TABLE @DATA(lt_adr2).
          LOOP AT lt_adr2 INTO DATA(ls_adr2).
            IF ls_adr2-tel_number IS NOT INITIAL.
              IF es_customer-btel IS INITIAL.
                es_customer-btel = ls_adr2-tel_number.
              ELSE.
                es_customer-btel = es_customer-btel && ';' && ls_adr2-tel_number.
              ENDIF.
            ENDIF.
          ENDLOOP.
        ELSE.
          CLEAR: ls_but000.
        ENDIF. "End check but000
      ENDIF. "End Check Mã khách lẻ

      REPLACE ALL OCCURRENCES OF ', , , , , ,' IN es_customer-baddr WITH ','.
      REPLACE ALL OCCURRENCES OF ', , , , ,' IN es_customer-baddr WITH ','.
      REPLACE ALL OCCURRENCES OF ', , , ,' IN es_customer-baddr WITH ','.
      REPLACE ALL OCCURRENCES OF ', , ,' IN es_customer-baddr WITH ','.
      REPLACE ALL OCCURRENCES OF ', ,' IN es_customer-baddr WITH ','.

      SHIFT es_customer-baddr RIGHT DELETING TRAILING space.
      SHIFT es_customer-baddr RIGHT DELETING TRAILING ','.
      SHIFT es_customer-baddr LEFT DELETING LEADING space.
      SHIFT es_customer-baddr LEFT DELETING LEADING ','.
      SHIFT es_customer-baddr LEFT DELETING LEADING space.

      DATA: lv_country TYPE land1.
      "Get Country Name
      IF ls_bsec IS INITIAL.
        lv_country = ls_adrc-country.
      ENDIF.

      IF es_customer-baddr IS NOT INITIAL.
        IF lv_country = 'VN'.
          es_customer-baddr = |{ es_customer-baddr }, Việt Nam|.
        ELSE.
          SELECT SINGLE countryname
          FROM i_countrytext
          WHERE country = @lv_country
            AND language = @sy-langu
          INTO @DATA(lv_country_name).
          IF sy-subrc = 0.
            es_customer-baddr = |{ es_customer-baddr }, { lv_country_name }|.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    IF lv_flag IS INITIAL.
      MOVE-CORRESPONDING es_customer TO ls_buyer.
      READ TABLE gt_buyer TRANSPORTING NO FIELDS WITH KEY bcode = ls_buyer-bcode BINARY SEARCH.
      IF sy-subrc NE 0.
        INSERT ls_buyer INTO gt_buyer INDEX sy-tabix.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).

      DATA(lv_top)            = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)           = io_request->get_paging( )->get_offset( ).
      DATA(requested_fields)  = io_request->get_requested_elements( ).
      DATA(sort_order)        = io_request->get_sort_elements( ).
      DATA(ro_filter)         = io_request->get_filter( ).
      DATA(lv_entity_id)      = io_request->get_entity_id( ).

      DATA: lr_bukrs TYPE tt_ranges,
            lr_belnr TYPE tt_ranges,
            lr_gjahr TYPE tt_ranges.

      FREE: lr_bukrs, lr_belnr, lr_gjahr.

      DATA(lr_ranges) = ro_filter->get_as_ranges( ).
      LOOP AT lr_ranges INTO DATA(ls_ranges).
        CASE ls_ranges-name.
          WHEN 'COMPANYCODE'.
*            MOVE-CORRESPONDING ls_ranges-range TO lr_bukrs.
          WHEN 'ACCOUNTINGDOCUMENT'.
            MOVE-CORRESPONDING ls_ranges-range TO lr_belnr.
          WHEN 'FISCALYEAR'.
            MOVE-CORRESPONDING ls_ranges-range TO lr_gjahr.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.

      IF lv_top < 0.
        lv_top = 50.
      ENDIF.

      APPEND VALUE #( sign = 'I' option = 'EQ' low = '6710' ) TO lr_bukrs.

      CASE lv_entity_id.
        WHEN 'ZCS_RAP_EINV_HEADER'.
          zcl_rap_einv_generate=>get_instance( )->get_document_new(
            EXPORTING
                ir_bukrs = lr_bukrs
                ir_belnr = lr_belnr
                ir_gjahr = lr_gjahr
                iv_top   = lv_top
                iv_skip  = lv_skip
            IMPORTING
                header = DATA(lt_header)
          ).

          IF io_request->is_total_numb_of_rec_requested( ).
            io_response->set_total_number_of_records( lines( lt_header ) ).
          ENDIF.

          IF io_request->is_data_requested( ).
            io_response->set_data( lt_header ).
          ENDIF.
        WHEN 'ZCS_RAP_EINV_ITEMS'.
          zcl_rap_einv_generate=>get_instance( )->get_document_new(
          EXPORTING
              ir_bukrs = lr_bukrs
              ir_belnr = lr_belnr
              ir_gjahr = lr_gjahr
              iv_top   = lv_top
              iv_skip  = lv_skip
          IMPORTING
              items = DATA(lt_items)
        ).

          IF io_request->is_total_numb_of_rec_requested( ).
            io_response->set_total_number_of_records( lines( lt_items ) ).
          ENDIF.

          IF io_request->is_data_requested( ).
            io_response->set_data( lt_items ).
          ENDIF.
        WHEN OTHERS.

      ENDCASE.
    ELSE.
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD get_document_new.
    SELECT   a~companycode ,
             a~accountingdocument,
             a~fiscalyear,
             a~billingdocument,
             a~accountingdocumentitem,
             a~postingdate,
             a~documentdate,
             a~financialaccounttype,
             a~accountingdocumenttype,
             a~postingkey,
             a~debitcreditcode,
             a~glaccount,
             a~customer,
             a~taxcode,
             a~product,
*             a~material,
*             a~documentitemtext,
*             a~baseunit,
*             a~quantity,
*             a~amountintransactioncurrency, "
*             a~amountincompanycodecurrency, "Local
*             a~transactioncurrency,
*             a~PaymentMethod,
             c~seq,
             c~serial,
             c~form,
             b~absoluteexchangerate,
             b~reversedocument,
             b~reversedocumentfiscalyear,
             b~isreversal,
             b~isreversed
      FROM i_operationalacctgdocitem AS a
      INNER JOIN i_journalentry AS b
          ON  a~companycode = b~companycode
          AND a~accountingdocument = b~accountingdocument
          AND a~fiscalyear = b~fiscalyear
      LEFT OUTER JOIN zrap_einv_header AS c
          ON  a~companycode = c~companycode
          AND a~accountingdocument = c~accountingdocument
          AND a~fiscalyear = c~fiscalyear
      WHERE a~CompanyCode IN @ir_bukrs
        AND a~AccountingDocument IN @ir_belnr
        AND a~FiscalYear IN @ir_gjahr
        AND a~glaccount NOT LIKE '333%'
        AND a~FinancialAccountType = 'D'
"Trường hợp chứng từ huỷ chưa phát hành hoá đơn ko lấy lên
        AND b~IsReversal NE 'X' "--> "Loại chứng từ huỷ
        AND ( ( b~IsReversed NE 'X' ) "--> "Loại bỏ chứng từ gốc đã huỷ
"Trường hợp huỷ chứng từ sau khi đã phát hành hoá đơn vẫn lấy lên
        OR ( b~IsReversed EQ 'X' AND c~seq NE '' ) )
        AND ( a~taxcode LIKE 'O%'
          OR a~taxcode = '**' )
      ORDER BY a~companycode, a~accountingdocument, a~fiscalyear
      INTO TABLE @DATA(lt_bkpf) .

    IF lt_bkpf IS NOT INITIAL.
      SELECT * FROM zrap_einv_header
      FOR ALL ENTRIES IN @lt_bkpf
      WHERE companycode = @lt_bkpf-CompanyCode
        AND accountingdocument = @lt_bkpf-AccountingDocument
        AND fiscalyear = @lt_bkpf-FiscalYear
      INTO TABLE @DATA(lt_einv_header).

      SELECT a~companycode ,
             a~accountingdocument,
             a~fiscalyear,
             a~billingdocument,
             a~accountingdocumentitem,
             a~postingdate,
             a~documentdate,
             a~financialaccounttype,
             a~accountingdocumenttype,
             a~postingkey,
             a~debitcreditcode,
             a~glaccount,
             a~customer,
             a~taxcode,
             a~product,
             a~material,
             a~documentitemtext,
             a~baseunit,
             a~quantity,
             a~amountintransactioncurrency, "
             a~amountincompanycodecurrency, "Local
             a~transactioncurrency,
             a~PaymentMethod
*             c~seq,
*             c~serial,
*             c~form,
*             b~absoluteexchangerate,
*             b~reversedocument,
*             b~reversedocumentfiscalyear,
*             b~isreversal,
*             b~isreversed
      FROM i_operationalacctgdocitem AS a
      FOR ALL ENTRIES IN @lt_bkpf
      WHERE a~companycode = @lt_bkpf-CompanyCode
        AND a~accountingdocument = @lt_bkpf-AccountingDocument
        AND a~fiscalyear = @lt_bkpf-FiscalYear
        AND a~GLAccount NOT LIKE '333%'
        AND a~FinancialAccountType = 'S'
        AND a~TaxCode IS NOT INITIAL
      INTO TABLE @DATA(lt_bseg).

      TYPES: BEGIN OF lty_sum_vat,
               companycode        TYPE bukrs,
               accountingdocument TYPE belnr_d,
               fiscalyear         TYPE gjahr,
               taxcode            TYPE zde_mwskz,
               sum_vat            TYPE zde_e_vat,
               sum_vatv           TYPE zde_e_vatv,
             END OF lty_sum_vat.

      DATA: lt_sum_vat      TYPE TABLE OF lty_sum_vat,
            lt_sum_vat_temp TYPE TABLE OF lty_sum_vat.

      SELECT companycode,
             accountingdocument,
             fiscalyear,
             taxcode,
             amountintransactioncurrency  AS sum_vat, "
             amountincompanycodecurrency  AS sum_vatv "Local
        FROM i_operationalacctgdocitem
        FOR ALL ENTRIES IN @lt_bkpf
        WHERE companycode = @lt_bkpf-companycode
          AND accountingdocument = @lt_bkpf-accountingdocument
          AND fiscalyear = @lt_bkpf-fiscalyear
          AND glaccount LIKE '333%'
          AND ( taxcode LIKE 'O%' OR taxcode = '**' )
          INTO CORRESPONDING FIELDS OF TABLE @lt_sum_vat
          .

      SORT lt_einv_header BY companycode accountingdocument fiscalyear ASCENDING.
      SORT lt_bseg BY CompanyCode AccountingDocument fiscalyear AccountingDocumentItem ASCENDING.
    ENDIF.

    DATA: lv_index         TYPE int4 VALUE IS INITIAL,
          lv_flag          TYPE int4 VALUE IS INITIAL,
          lv_PaymentMethod TYPE zde_e_paym VALUE IS INITIAL,
          lv_count         TYPE int4 VALUE IS INITIAL.

    "Customer Details
    DATA: ex_customer  TYPE zst_e_customer,
          ex_return    TYPE bapiret2,
          im_bseg      TYPE i_operationalacctgdocitem,
          lv_mwskz_old TYPE zde_mwskz,
          flag_mwskz   TYPE char1.

    DATA: lt_einv_log  TYPE TABLE OF zrap_einv_header,
          ls_einv_log  TYPE zrap_einv_header,

          lt_einv_line TYPE TABLE OF zrap_einv_items,
          ls_einv_line TYPE zrap_einv_items.

    CLEAR: lv_count.

    LOOP AT lt_bkpf INTO DATA(ls_bkpf).
      READ TABLE lt_bseg TRANSPORTING NO FIELDS WITH KEY CompanyCode = ls_bkpf-CompanyCode
                                                         AccountingDocument = ls_bkpf-AccountingDocument
                                                         FiscalYear = ls_bkpf-FiscalYear BINARY SEARCH.
      IF sy-subrc EQ 0.
        lv_index = sy-tabix.
        LOOP AT lt_bseg INTO DATA(ls_bseg) FROM lv_index.
          IF ls_bseg-CompanyCode EQ ls_bkpf-CompanyCode AND
            ls_bseg-AccountingDocument EQ ls_bkpf-AccountingDocument AND
            ls_bseg-FiscalYear EQ ls_bkpf-FiscalYear .

            lv_count = lv_count + 1.
            "Buzei
            ls_einv_line-buzei = lv_count.
            "Company code
            ls_einv_line-companycode = ls_bseg-companycode.
            "Document Acounting
            ls_einv_line-accountingdocument = ls_bseg-accountingdocument.
            "Fiscal Year
            ls_einv_line-fiscalyear = ls_bseg-fiscalyear.
            "Material
            ls_einv_line-material = ls_bseg-product.
            "Tên hàng hoá
            ls_einv_line-itemname = ls_bseg-documentitemtext.
            "Quantiy
            ls_einv_line-quantity = ls_bseg-quantity.
            "Đơn vị
            ls_einv_line-baseunit = ls_bseg-baseunit.
            "Đơn vị text
            SELECT SINGLE unitofmeasurelongname FROM i_unitofmeasuretext
            WHERE unitofmeasure = @ls_bseg-baseunit INTO @ls_einv_line-unittext.
            "Taxcode
            IF lv_mwskz_old IS NOT INITIAL AND lv_mwskz_old NE ls_bseg-taxcode.
              ls_einv_log-taxcode = 'Nhiều loại'.
              flag_mwskz = 'X'.
            ELSE.
              ls_einv_log-taxcode = ls_bseg-taxcode.
            ENDIF.

            "Currency
            ls_einv_line-currency = ls_bseg-transactioncurrency.

            ls_einv_line-taxcode = ls_bseg-taxcode.
            lv_mwskz_old = ls_bseg-taxcode.

            CASE ls_bseg-taxcode.
              WHEN 'O1'.
                ls_einv_line-taxpercentage = 0.
              WHEN 'O2'.
                ls_einv_line-taxpercentage = 5.
              WHEN 'O3'.
                ls_einv_line-taxpercentage = 8.
              WHEN 'O4'.
                ls_einv_line-taxpercentage = 10.
              WHEN OTHERS.
            ENDCASE.

            IF ls_bseg-PaymentMethod IS NOT INITIAL.
              lv_PaymentMethod = ls_bseg-PaymentMethod.
            ENDIF.

            "Amount
            ls_einv_line-amount  = ls_bseg-amountintransactioncurrency.
            "VAT
            ls_einv_line-vat     = ls_bseg-amountintransactioncurrency * ls_einv_line-taxpercentage / 100.
            "Total
            ls_einv_line-total   = ls_einv_line-amount + ls_einv_line-vat.
            "Amount Local
            ls_einv_line-amountv = ls_bseg-amountincompanycodecurrency.
            "VAT Local
            ls_einv_line-vatv    = ls_bseg-amountincompanycodecurrency * ls_einv_line-taxpercentage / 100.
            "Total Local
            ls_einv_line-total   = ls_einv_line-amountv + ls_einv_line-vatv.

            APPEND ls_einv_line TO lt_einv_line.

            "Process Total Document
            "Company code
            ls_einv_log-companycode = ls_bseg-companycode.
            "Document Acounting
            ls_einv_log-accountingdocument = ls_bseg-accountingdocument.
            "Fiscal Year
            ls_einv_log-fiscalyear = ls_bseg-fiscalyear.
            "Budat
            ls_einv_log-postingdate = ls_bseg-postingdate.
            "Document Date
            ls_einv_log-documentdate = ls_bseg-documentdate.
            "Doc type
            ls_einv_log-doctype = ls_bseg-accountingdocumenttype.
            "Exchange rate
            ls_einv_log-exchangerate = ls_bkpf-absoluteexchangerate.
            "Currency
            ls_einv_log-currency = ls_bseg-transactioncurrency.
            "Customer
            CLEAR: im_bseg.
            im_bseg-companycode = ls_bseg-companycode.
            im_bseg-accountingdocument = ls_bseg-accountingdocument.
            im_bseg-fiscalyear = ls_bseg-fiscalyear.

            zcl_rap_einv_generate=>get_instance( )->zget_buyer(
              EXPORTING
                i_kunnr     = ls_bseg-customer
                is_bseg     = im_bseg
              IMPORTING
                es_customer = ex_customer
                es_return   = ex_return
            ).
            ls_einv_log-customer = ls_bseg-customer.
            ls_einv_log-bname = ex_customer-bname.
            ls_einv_log-baddr = ex_customer-baddr.
            ls_einv_log-btax  = ex_customer-btax.
            ls_einv_log-bmail = ex_customer-bmail.
            ls_einv_log-btel  = ex_customer-btel.

            "Amount
            ls_einv_log-amount  = ls_einv_log-amount + ls_einv_line-amount.
            "VAT
            ls_einv_log-vat     = ls_einv_log-vat + ls_einv_line-vat.
            "Total
            ls_einv_log-total   = ls_einv_log-total + ls_einv_line-amount + ls_einv_line-vat.
            "Amount Local
            ls_einv_log-amountv = ls_einv_log-amountv + ls_einv_line-amountv.
            "VAT Local
            ls_einv_log-vatv    = ls_einv_log-vatv + ls_einv_line-vatv.
            "Total Local
            ls_einv_log-total   = ls_einv_log-total + ls_einv_line-amountv + ls_einv_line-vatv.

            CLEAR: ls_einv_line.

          ELSE.
            EXIT.
          ENDIF.
        ENDLOOP.
        "Header Log
        "Flag reverse document
        ls_einv_log-stblg      = ls_bkpf-reversedocument.
        ls_einv_log-stjah      = ls_bkpf-reversedocumentfiscalyear.
        ls_einv_log-xreversing = ls_bkpf-isreversal.
        ls_einv_log-xreversed  = ls_bkpf-isreversed.

        READ TABLE lt_einv_header INTO DATA(ls_einv_header) WITH KEY CompanyCode = ls_bkpf-CompanyCode
                                                         AccountingDocument = ls_bkpf-AccountingDocument
                                                         FiscalYear = ls_bkpf-FiscalYear BINARY SEARCH.
        IF sy-subrc EQ 0.
          ls_einv_log-Statussap         = ls_einv_header-statussap.
          ls_einv_log-Statusinv         = ls_einv_header-statusinv.
          ls_einv_log-Statuscqt         = ls_einv_header-statuscqt.
          ls_einv_log-seq               = ls_einv_header-seq.
          ls_einv_log-Serial            = ls_einv_header-serial.
          ls_einv_log-Form              = ls_einv_header-form.
          ls_einv_log-Etype             = ls_einv_header-etype.
          ls_einv_log-Usertype          = ls_einv_header-usertype.
          ls_einv_log-Datintegration    = ls_einv_header-datintegration.
          ls_einv_log-Datissuance       = ls_einv_header-datissuance.
          ls_einv_log-Timeissuance      = ls_einv_header-timeissuance.
          ls_einv_log-Datcancel         = ls_einv_header-datcancel.
          ls_einv_log-Msgty             = ls_einv_header-msgty.
          ls_einv_log-Msgtx             = ls_einv_header-msgtx.
          ls_einv_log-Statussapold      = ls_einv_header-statussapold.
          ls_einv_log-Msgold            = ls_einv_header-msgold.
          ls_einv_log-Mscqt             = ls_einv_header-mscqt.
          ls_einv_log-Link              = ls_einv_header-link.
          ls_einv_log-paym              = ls_einv_header-paym.
*          IF ls_einv_header-statussap EQ '03'.
*
*          ENDIF.
        ELSE.
          ls_einv_log-Statussap = '01'.
          ls_einv_log-Timeissuance = '080000'.
          "PaymentMethod
          ls_einv_log-Paym = lv_PaymentMethod.
        ENDIF.
        APPEND ls_einv_log TO lt_einv_log.
        CLEAR: ls_einv_log.
        CLEAR: lv_paymentmethod, lv_count.
      ENDIF.
      CLEAR: lv_index.
    ENDLOOP.


    lt_sum_vat_temp = lt_sum_vat.

    FREE: lt_sum_vat.
    LOOP AT lt_sum_vat_temp INTO DATA(ls_sum_vat).
      COLLECT ls_sum_vat INTO lt_sum_vat.
    ENDLOOP.

    SORT lt_sum_vat BY companycode accountingdocument fiscalyear taxcode ASCENDING.

    TYPES: BEGIN OF lty_line_temp,
             companycode        TYPE bukrs,
             accountingdocument TYPE belnr_d,
             fiscalyear         TYPE gjahr,
             taxcode            TYPE zde_mwskz,
             buzei              TYPE buzei,
             material           TYPE zde_matnr,
             itemname           TYPE zde_tenhh,
             noted              TYPE  zde_noted,
             taxpercentage      TYPE zde_mwskzn,
             quantity           TYPE zde_menge,
             baseunit           TYPE meins,
             unittext           TYPE zde_msehl,
             price              TYPE zde_e_price,
             currency           TYPE waers,
             amount             TYPE zde_e_amount,
             vat                TYPE zde_e_vat,
             total              TYPE zde_e_total,
             pricev             TYPE zde_e_pricev,
             amountv            TYPE zde_e_amountv,
             vatv               TYPE zde_e_vatv,
             totalv             TYPE zde_e_totalv,
           END OF lty_line_temp.

    DATA: lt_line_temp TYPE TABLE OF lty_line_temp,
          ls_line_temp TYPE lty_line_temp.

    DATA: lv_cl_vat  TYPE zde_e_vat,
          lv_cl_vatv TYPE zde_e_vatv.

    MOVE-CORRESPONDING lt_einv_line TO lt_line_temp.

    SORT lt_line_temp BY companycode accountingdocument fiscalyear taxcode buzei ASCENDING.

    LOOP AT lt_line_temp INTO DATA(ls_templine).
      lv_index = sy-tabix.
      MOVE-CORRESPONDING ls_templine TO ls_line_temp.
      lv_cl_vat = lv_cl_vat + ls_line_temp-vat.
      lv_cl_vatv = lv_cl_vatv + ls_line_temp-vatv.

      AT END OF taxcode.
        READ TABLE lt_sum_vat INTO ls_sum_vat WITH KEY CompanyCode = ls_line_temp-CompanyCode
                                                       AccountingDocument = ls_line_temp-AccountingDocument
                                                       FiscalYear = ls_line_temp-FiscalYear
                                                       taxcode = ls_line_temp-taxcode BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF ls_sum_vat-sum_vat NE 0.
            ls_line_temp-vat = ls_line_temp-vat + ls_sum_vat-sum_vat - lv_cl_vat.
            ls_line_temp-total = ls_line_temp-amount + ls_line_temp-vat.
          ENDIF.
          IF ls_sum_vat-sum_vatv NE 0.
            ls_line_temp-vatv = ls_line_temp-vatv + ls_sum_vat-sum_vatv - lv_cl_vatv.
            ls_line_temp-totalv = ls_line_temp-amountv + ls_line_temp-vatv.
          ENDIF.

          READ TABLE lt_einv_header ASSIGNING FIELD-SYMBOL(<lfs_einv_header>)
          WITH KEY CompanyCode = ls_line_temp-CompanyCode
          AccountingDocument = ls_line_temp-AccountingDocument
          FiscalYear = ls_line_temp-FiscalYear BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF ls_sum_vat-sum_vat NE 0.
              <lfs_einv_header>-vat = <lfs_einv_header>-vat + ls_sum_vat-sum_vat - lv_cl_vat.
              <lfs_einv_header>-total = <lfs_einv_header>-amount + <lfs_einv_header>-vat.
            ENDIF.
            IF ls_sum_vat-sum_vatv NE 0.
              <lfs_einv_header>-vatv = <lfs_einv_header>-vatv + ls_sum_vat-sum_vatv - lv_cl_vatv.
              <lfs_einv_header>-totalv = <lfs_einv_header>-amountv + <lfs_einv_header>-vatv.
            ENDIF.
          ENDIF.
        ENDIF.

        MODIFY lt_line_temp FROM ls_line_temp INDEX lv_index.
      ENDAT.
    ENDLOOP.

    FREE: lt_einv_line.
    MOVE-CORRESPONDING lt_line_temp TO lt_einv_line.

    SORT lt_einv_line by Companycode Accountingdocument Fiscalyear Buzei ASCENDING.

        IF iv_skip > 0.
      DELETE lt_einv_log TO iv_skip.
    ENDIF.

    SELECT * FROM @lt_einv_log AS alias_einv_log
    INTO CORRESPONDING FIELDS OF TABLE @header UP TO @iv_top ROWS.

    WAIT UP TO 2 SECONDS.

    IF header IS NOT INITIAL.
      LOOP AT lt_einv_line INTO ls_einv_line.
        READ TABLE header TRANSPORTING NO FIELDS WITH KEY companycode = ls_einv_line-Companycode
                                                          Accountingdocument = ls_einv_line-Accountingdocument
                                                          Fiscalyear = ls_einv_line-Fiscalyear BINARY SEARCH.
        IF sy-subrc EQ 0.
          APPEND CORRESPONDING #( ls_einv_line ) TO items.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
