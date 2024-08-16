CLASS zcl_manage_fpt_einvoices DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "Create Contructor
    CLASS-METHODS: get_Instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_manage_fpt_einvoices.

    CLASS-METHODS create_einvoices IMPORTING
                                     i_action   TYPE zde_e_action
                                     i_einvoice TYPE zi_rap_einv_header
                                     i_userpass TYPE zrap_einv_user
                                     i_testrun  TYPE zde_testrun OPTIONAL
                                   EXPORTING
                                     e_status   TYPE zi_rap_einv_header
                                     e_docsrc   TYPE zi_rap_einv_header
                                     e_json     TYPE string
                                     e_return   TYPE bapiret2
                                   .
    CLASS-METHODS cancel_einvoices IMPORTING
                                     i_action   TYPE zde_e_action
                                     i_einvoice TYPE zi_rap_einv_header
                                     i_userpass TYPE zrap_einv_user
                                     i_param    TYPE zrk_cancel_einv
                                     i_testrun  TYPE zde_testrun OPTIONAL
                                   EXPORTING
                                     e_status   TYPE zi_rap_einv_header
                                     e_json     TYPE string
                                     e_return   TYPE bapiret2
                                   .
    CLASS-METHODS search_einvoices IMPORTING
                                        i_action   TYPE zde_e_action
                                        i_einvoice TYPE zi_rap_einv_header
                                        i_userpass TYPE zrap_einv_user  OPTIONAL
                                        i_testrun  TYPE zde_testrun OPTIONAL
                                      EXPORTING
                                        e_status   TYPE zi_rap_einv_header
                                        e_docsrc   TYPE zi_rap_einv_header
                                        e_json     TYPE string
                                        e_return   TYPE bapiret2
                                      .
    CLASS-METHODS adjust_einvoices IMPORTING
                                     i_action   TYPE zde_e_action
                                     i_einvoice TYPE zi_rap_einv_header
                                     i_userpass TYPE zrap_einv_user
                                     i_testrun  TYPE zde_testrun OPTIONAL
                                   EXPORTING
                                     e_status   TYPE zi_rap_einv_header
                                     e_docsrc   TYPE zi_rap_einv_header
                                     e_json     TYPE string
                                     e_return   TYPE bapiret2.
    .
    CLASS-METHODS process_status IMPORTING
                                   i_action   TYPE zde_e_action
                                   i_einvoice TYPE zi_rap_einv_header
                                   i_return   TYPE bapiret2
                                   i_status   TYPE string
                                 EXPORTING
                                   e_header   TYPE zi_rap_einv_header
                                   e_docsrc   TYPE zi_rap_einv_header.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA: mo_instance      TYPE REF TO zcl_manage_fpt_einvoices,

                gt_einvoices_log TYPE TABLE OF zi_rap_einv_header.
ENDCLASS.



CLASS zcl_manage_fpt_einvoices IMPLEMENTATION.
  METHOD get_instance.
    mo_instance = ro_instance = COND #( WHEN mo_instance IS BOUND
                                           THEN mo_instance
                                           ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD create_einvoices.
    DATA: lv_date TYPE sy-datum,
          lv_url  TYPE zde_text255.

    SELECT * FROM zrap_einv_items
    WHERE companycode      = @i_einvoice-companycode
    AND accountingdocument = @i_einvoice-accountingdocument
    AND fiscalyear         = @i_einvoice-fiscalyear
    INTO TABLE @DATA(lt_rap_einv_line).

    DATA: ls_einvoice TYPE zst_fpt_create.

* Username - Password *
*    SELECT SINGLE * FROM zi_rap_einv_pass WHERE companycode = @i_einvoice-companycode
*    INTO @DATA(ls_einv_pass).

    ls_einvoice-user-username = i_userpass-username.
    ls_einvoice-user-password = i_userpass-password.
*----------------------------------------------------------*
* Key - Form - Serial Invoices
    IF i_einvoice-Zsearch IS NOT INITIAL.
      ls_einvoice-inv-sid     = i_einvoice-Zsearch.
    ELSE.
      ls_einvoice-inv-sid     = i_einvoice-IdkeyEinv.
    ENDIF.

    SELECT SINGLE * FROM zrap_einv_serial
    WHERE Companycode = @i_userpass-Companycode
      AND usertype = @i_userpass-usertype
      INTO @DATA(ls_einv_form).

    CASE ls_einv_form-datetype.
      WHEN ''. "Document Date
        lv_date = i_einvoice-Documentdate.
      WHEN '1'. "Posting Date
        lv_date = i_einvoice-Postingdate.
      WHEN '2'. "Entry Date
        lv_date = i_einvoice-Entrydate.
      WHEN '3'. "System date
        lv_date = sy-datum.
      WHEN OTHERS.
    ENDCASE.

    ls_einvoice-inv-idt     = |{ lv_date+0(4) }-{ lv_date+4(2) }-{ lv_date+6(2) } { i_einvoice-Timeissuance+0(2) }:{ i_einvoice-Timeissuance+2(2) }:{ i_einvoice-Timeissuance+4(2) }|.
    ls_einvoice-inv-type    = ls_einv_form-etype.
    ls_einvoice-inv-form    = ls_einv_form-Form.
    ls_einvoice-inv-serial  = ls_einv_form-Serial.
*----------------------------------------------------------*
* Buyer Details *
    ls_einvoice-inv-bcode   = i_einvoice-Customer.
    ls_einvoice-inv-bname   = ls_einvoice-inv-buyer = i_einvoice-Bname.
    ls_einvoice-inv-btax    = i_einvoice-Btax.
    ls_einvoice-inv-baddr   = i_einvoice-Baddr.
    ls_einvoice-inv-btel    = i_einvoice-Btel.
    ls_einvoice-inv-bmail   = i_einvoice-Bmail.
    ls_einvoice-inv-bacc    = i_einvoice-Bacct.
    ls_einvoice-inv-bbank   = i_einvoice-Bbank.
*----------------------------------------------------------*
SELECT SINGLE paymtext FROM zrap_einv_paym WHERE zlsch = @i_einvoice-Paym
INTO @ls_einvoice-inv-paym.

*    ls_einvoice-inv-paym    = i_einvoice-paym.
    ls_einvoice-inv-curr    = i_einvoice-currency.
    ls_einvoice-inv-exrt    = i_einvoice-Exchangerate.
* Amount *
    ls_einvoice-inv-sum     = i_einvoice-Amount.
    ls_einvoice-inv-vat     = i_einvoice-Vat.
    ls_einvoice-inv-total   = i_einvoice-Total.

    ls_einvoice-inv-sumv    = i_einvoice-Amountv.
    ls_einvoice-inv-vatv    = i_einvoice-Vatv.
    ls_einvoice-inv-totalv  = i_einvoice-Totalv.
*----------------------------------------------------------*
* Loại hóa đơn sử dụng mặc định theo thông tư 78
    ls_einvoice-inv-type_ref = 1.
* Supplier Taxcode
    ls_einvoice-inv-stax = i_userpass-Sellertax.
* INV Items *
    DATA: ls_items LIKE LINE OF ls_einvoice-inv-items.
    LOOP AT lt_rap_einv_line INTO DATA(ls_einv_line).

      ls_items-line     = ls_einv_line-Buzei.
      ls_items-type     = ''.
      ls_items-vrt      = ls_einv_line-Taxpercentage.
      ls_items-code     = ls_einv_line-Material.
      ls_items-name     = ls_einv_line-Itemname.
      ls_items-unit     = ls_einv_line-Unittext.
      ls_items-price    = ls_einv_line-Price.
      ls_items-quantity = ls_einv_line-Quantity.
      ls_items-amount   = ls_einv_line-Amount.
      ls_items-vat      = ls_einv_line-Vat.
      ls_items-total    = ls_einv_line-Total.
      ls_items-pricev   = ls_einv_line-Pricev.
      ls_items-amountv  = ls_einv_line-Amountv.
      ls_items-vatv     = ls_einv_line-Vatv.
      ls_items-totalv   = ls_einv_line-Totalv.

      APPEND ls_items TO ls_einvoice-inv-items.
      CLEAR: ls_items.
    ENDLOOP.
*----------------------------------------------------------*
* Create JSON *
    DATA(lv_json_string) = xco_cp_json=>data->from_abap( ls_einvoice )->apply( VALUE #(
      ( xco_cp_json=>transformation->underscore_to_pascal_case )
    ) )->to_string( ).
    e_json = lv_json_string.

* Test run *
    IF i_testrun IS NOT INITIAL.
      RETURN.
    ENDIF.

* Call API OUTBOUND *
    DATA: lv_json_results TYPE string.

    lv_url = i_action.
    CALL METHOD zcl_api_fpt_einvoices_ob=>post_einvoices
      EXPORTING
        i_username = i_userpass-Username
        i_password = i_userpass-Password
        i_context  = lv_json_string
        i_prefix   = lv_url
      IMPORTING
        e_context  = lv_json_results
        e_return   = e_return.
*-------------------------THE--END-------------------------*
    zcl_manage_fpt_einvoices=>get_instance( )->process_status(
        EXPORTING
        i_action = i_action
        i_einvoice = i_einvoice
        i_return = e_return
        i_status = lv_json_results
        IMPORTING
        e_header = e_status
        ).

  ENDMETHOD.

  METHOD cancel_einvoices.
    DATA: ls_einvoice  TYPE zst_fpt_cancel,
          ls_can_items LIKE LINE OF ls_einvoice-wrongnotice-items.

    DATA: lv_url  TYPE zde_text255.

* Username - Password
    ls_einvoice-user-username = i_userpass-Username.
    ls_einvoice-user-password = i_userpass-Password.
*----------------------------------------------------------*
* Wrongnotice *
    ls_einvoice-wrongnotice-stax = i_userpass-Sellertax.
    "Loại thông báo
    ls_einvoice-wrongnotice-noti_taxtype = i_param-noti_taxtype.
    IF ls_einvoice-wrongnotice-noti_taxtype = 2. "Hủy theo thông báo của CQT
      "Số thông báo
      ls_einvoice-wrongnotice-noti_taxnum = i_param-noti_taxnum.
    ENDIF.
    "Ngày thông báo CQT
    ls_einvoice-wrongnotice-noti_taxdt = i_param-noti_taxdt.
    "Địa danh
    ls_einvoice-wrongnotice-place = i_param-place.
*----------------------------------------------------------*
* Items *
*    SELECT SINGLE * FROM zi_rap_einv_form
*    WHERE Companycode = @i_userpass-Companycode
*      AND usertype = @i_userpass-usertype
*      INTO @DATA(ls_einv_form).

    ls_can_items-form    = i_einvoice-Form.
    ls_can_items-serial  = i_einvoice-Serial.
    ls_can_items-seq     = i_einvoice-Seq.
    ls_can_items-idt     = i_einvoice-InvDat.
* Loại áp dụng hóa đơn điện tử mặc định = 1
    ls_can_items-type_ref = 1.
* Tính chất thông báo
    ls_can_items-noti_type = i_param-noti_type.
* Lý do hủy
*    ls_cancel_items-rea =
    APPEND ls_can_items TO ls_einvoice-wrongnotice-items.
    CLEAR: ls_can_items.

* CREATE JSON *
    DATA(lv_json_string) = xco_cp_json=>data->from_abap( ls_einvoice )->apply( VALUE #(
      ( xco_cp_json=>transformation->underscore_to_pascal_case )
    ) )->to_string( ).
    e_json = lv_json_string.

* Test run *
    IF i_testrun IS NOT INITIAL.
      RETURN.
    ENDIF.
* CALL API OUTBOUND *
    DATA: lv_json_results TYPE string.

    CALL METHOD zcl_api_fpt_einvoices_ob=>post_einvoices
      EXPORTING
        i_username = i_userpass-Username
        i_password = i_userpass-Password
        i_context  = lv_json_string
        i_prefix   = lv_url
      IMPORTING
        e_context  = lv_json_results
        e_return   = e_return.
*-------------------------THE--END-------------------------*
    zcl_manage_fpt_einvoices=>get_instance( )->process_status(
        EXPORTING
        i_action = i_action
        i_einvoice = i_einvoice
        i_return = e_return
        i_status = lv_json_results
        IMPORTING
        e_header = e_status
        ).

  ENDMETHOD.

  METHOD search_einvoices.
    DATA: ls_einvoice TYPE zst_fpt_info.
    DATA: lv_url  TYPE zde_text255.

*" Username - Password
    ls_einvoice-username = i_userpass-username.
    ls_einvoice-password = i_userpass-password.
*" Form E-Invoice
    ls_einvoice-form = i_einvoice-form.
*" Serial E-Invoice
    ls_einvoice-serial = i_einvoice-serial.
*" MST người bán
    ls_einvoice-stax = i_userpass-Sellertax.
*" Loại dữ liệu trả về JSON
    ls_einvoice-type = '1'.
*" Key để xác định hoá đơn
    ls_einvoice-sid = i_einvoice-IdkeyEinv.
*" MST người mua
    ls_einvoice-btax = i_einvoice-BTax.
*" Tra cứu hóa đơn tạo từ API
    ls_einvoice-api = '1'.

* Create JSON *
    DATA(lv_json_string) = xco_cp_json=>data->from_abap( ls_einvoice )->apply( VALUE #(
      ( xco_cp_json=>transformation->underscore_to_pascal_case )
    ) )->to_string( ).
    e_json = lv_json_string.

* Test run *
    IF i_testrun IS NOT INITIAL.
      RETURN.
    ENDIF.

* CALL API OUTBOUND *

    DATA: lv_json_results TYPE string.

    CALL METHOD zcl_api_fpt_einvoices_ob=>get_einvoices
      EXPORTING
        i_context = ls_einvoice
        i_url     = lv_url
      IMPORTING
        e_context = lv_json_results
        e_return  = e_return.
*-------------------------THE--END-------------------------*
    zcl_manage_fpt_einvoices=>get_instance( )->process_status(
        EXPORTING
        i_action = i_action
        i_einvoice = i_einvoice
        i_return = e_return
        i_status = lv_json_results
        IMPORTING
        e_header = e_status
        e_docsrc = e_docsrc
        ).

  ENDMETHOD.

  METHOD adjust_einvoices.
    DATA: ls_einvoice TYPE zst_fpt_adjust.
    DATA: lv_date TYPE sy-datum,
          lv_url  TYPE zde_text255.

    SELECT * FROM zrap_einv_items
    WHERE companycode      = @i_einvoice-companycode
    AND accountingdocument = @i_einvoice-accountingdocument
    AND fiscalyear         = @i_einvoice-fiscalyear
    INTO TABLE @DATA(lt_rap_einv_line).

* Username - Password *
*    SELECT SINGLE * FROM zi_rap_einv_pass WHERE companycode = @i_einvoice-companycode
*    INTO @DATA(ls_einv_pass).

    ls_einvoice-user-username = i_userpass-username.
    ls_einvoice-user-password = i_userpass-password.
*----------------------------------------------------------*

* Key - Form - Serial Invoices
    IF i_einvoice-Zsearch IS NOT INITIAL.
      ls_einvoice-inv-sid     = i_einvoice-Zsearch.
    ELSE.
      ls_einvoice-inv-sid     = i_einvoice-IdkeyEinv.
    ENDIF.

    SELECT SINGLE * FROM zrap_einv_serial
    WHERE Companycode = @i_userpass-Companycode
      AND usertype = @i_userpass-usertype
      INTO @DATA(ls_einv_form).

    CASE ls_einv_form-datetype.
      WHEN ''. "Document Date
        lv_date = i_einvoice-Documentdate.
      WHEN '1'. "Posting Date
        lv_date = i_einvoice-Postingdate.
      WHEN '2'. "Entry Date
        lv_date = i_einvoice-Entrydate.
      WHEN '3'. "System date
        lv_date = sy-datum.
      WHEN OTHERS.
    ENDCASE.

    ls_einvoice-inv-idt     = |{ lv_date+0(4) }-{ lv_date+4(2) }-{ lv_date+6(2) } { i_einvoice-Timeissuance+0(2) }:{ i_einvoice-Timeissuance+2(2) }:{ i_einvoice-Timeissuance+4(2) }|.
    ls_einvoice-inv-type    = ls_einv_form-etype.
    ls_einvoice-inv-form    = ls_einv_form-Form.
    ls_einvoice-inv-serial  = ls_einv_form-Serial.
* Adjust Tag *
    ls_einvoice-inv-adj-rdt = |{ lv_date+0(4) }-{ lv_date+4(2) }-{ lv_date+6(2) } { i_einvoice-Timeissuance+0(2) }:{ i_einvoice-Timeissuance+2(2) }:{ i_einvoice-Timeissuance+4(2) }|.
    ls_einvoice-inv-adj-ref = i_einvoice-IdkeyEinv.
*
    SELECT SINGLE * FROM zi_rap_einv_header
    WHERE Companycode = @i_einvoice-Companycode
      AND Accountingdocument = @i_einvoice-BelnrSrc
      AND Fiscalyear = @i_einvoice-GjahrSrc
      INTO @DATA(ls_src_doc).
    IF sy-subrc EQ 0.
      ls_einvoice-inv-adj-seq = |1-{ ls_src_doc-serial }-{ ls_src_doc-seq }|.
      IF i_einvoice-TypeDc = '3'.
        ls_einvoice-inv-adj-rea = |Thay thế cho hóa đơn { ls_src_doc-serial }{ ls_src_doc-seq }|
        && | ngày { ls_src_doc-Datissuance+6(2) }/{ ls_src_doc-Datissuance+4(2) }/{ ls_src_doc-Datissuance+0(4) }|.
      ELSE.
        ls_einvoice-inv-adj-rea = |Điều chỉnh cho hóa đơn { ls_src_doc-serial }{ ls_src_doc-seq }|
        && | ngày { ls_src_doc-Datissuance+6(2) }/{ ls_src_doc-Datissuance+4(2) }/{ ls_src_doc-Datissuance+0(4) }|.
      ENDIF.
    ENDIF.
*----------------------------------------------------------*
* Buyer Details *
    ls_einvoice-inv-bcode   = i_einvoice-Customer.
    ls_einvoice-inv-bname   = ls_einvoice-inv-buyer = i_einvoice-Bname.
    ls_einvoice-inv-btax    = i_einvoice-Btax.
    ls_einvoice-inv-baddr   = i_einvoice-Baddr.
    ls_einvoice-inv-btel    = i_einvoice-Btel.
    ls_einvoice-inv-bmail   = i_einvoice-Bmail.
    ls_einvoice-inv-bacc    = i_einvoice-Bacct.
    ls_einvoice-inv-bbank   = i_einvoice-Bbank.
*----------------------------------------------------------*
    ls_einvoice-inv-paym    = i_einvoice-paym.
    ls_einvoice-inv-curr    = i_einvoice-currency.
    ls_einvoice-inv-exrt    = i_einvoice-Exchangerate.
* Amount *
    ls_einvoice-inv-sum     = i_einvoice-Amount.
    ls_einvoice-inv-vat     = i_einvoice-Vat.
    ls_einvoice-inv-total   = i_einvoice-Total.

    ls_einvoice-inv-sumv    = i_einvoice-Amountv.
    ls_einvoice-inv-vatv    = i_einvoice-Vatv.
    ls_einvoice-inv-totalv  = i_einvoice-Totalv.
*----------------------------------------------------------*
* Loại hóa đơn sử dụng mặc định theo thông tư 78
    ls_einvoice-inv-type_ref = 1.
* Xác định loại điều chỉnh
    IF i_einvoice-TypeDc = 1. "Điều chỉnh tăng
      ls_einvoice-inv-ud = '1'.
    ELSEIF i_einvoice-TypeDc = 2. "Điều chỉnh giảm
      ls_einvoice-inv-ud = '0'.
    ELSE. "Thay thế

    ENDIF.
* Thẻ đánh dấu điều chỉnh kiểu mới:
    ls_einvoice-inv-adj_only_add = '1'.
* Supplier Taxcode
    ls_einvoice-inv-stax = i_userpass-Sellertax.
* INV Items *
    DATA: ls_items LIKE LINE OF ls_einvoice-inv-items.
    LOOP AT lt_rap_einv_line INTO DATA(ls_einv_line).

      ls_items-line     = ls_einv_line-Buzei.
      ls_items-type     = ''.
      ls_items-vrt      = ls_einv_line-Taxpercentage.
      ls_items-code     = ls_einv_line-Material.
      ls_items-name     = ls_einv_line-Itemname.
      ls_items-unit     = ls_einv_line-Unittext.
      ls_items-price    = ls_einv_line-Price.
      ls_items-quantity = ls_einv_line-Quantity.
      ls_items-amount   = ls_einv_line-Amount.
      ls_items-vat      = ls_einv_line-Vat.
      ls_items-total    = ls_einv_line-Total.
      ls_items-pricev   = ls_einv_line-Pricev.
      ls_items-amountv  = ls_einv_line-Amountv.
      ls_items-vatv     = ls_einv_line-Vatv.
      ls_items-totalv   = ls_einv_line-Totalv.

      APPEND ls_items TO ls_einvoice-inv-items.
      CLEAR: ls_items.
    ENDLOOP.

* Create JSON *
    DATA(lv_json_string) = xco_cp_json=>data->from_abap( ls_einvoice )->apply( VALUE #(
      ( xco_cp_json=>transformation->underscore_to_pascal_case )
    ) )->to_string( ).
    e_json = lv_json_string.

* Test run *
    IF i_testrun IS NOT INITIAL.
      RETURN.
    ENDIF.

* CALL API OUNTBOUND *
    DATA: lv_json_results TYPE string.

    CALL METHOD zcl_api_fpt_einvoices_ob=>post_einvoices
      EXPORTING
        i_username = i_userpass-Username
        i_password = i_userpass-Password
        i_context  = lv_json_string
        i_prefix   = lv_url
      IMPORTING
        e_context  = lv_json_results
        e_return   = e_return.
*-------------------------THE--END-------------------------*
    zcl_manage_fpt_einvoices=>get_instance( )->process_status(
        EXPORTING
        i_action = i_action
        i_einvoice = i_einvoice
        i_return = e_return
        i_status = lv_json_results
        IMPORTING
        e_header = e_status
        e_docsrc = e_docsrc
        ).

  ENDMETHOD.

  METHOD process_status.
    TYPES: BEGIN OF lty_cancel_response,
             errorcode   TYPE char255,
             description TYPE char255,
           END OF lty_cancel_response.

    DATA: ls_cr_response     TYPE zst_fpt_cr_response,
          ls_cancel_response TYPE lty_cancel_response.

    "Create Log
    MOVE-CORRESPONDING i_einvoice TO e_header.

    IF i_return-type NE 'E'.
      IF i_action = 'create-invoice'
      OR i_action = 'adjust-invoice'
      OR i_action = 'search-invoice'.
        xco_cp_json=>data->from_string( i_status )->apply( VALUE #(
        ( xco_cp_json=>transformation->pascal_case_to_underscore )
        ( xco_cp_json=>transformation->boolean_to_abap_bool )
        ) )->write_to( REF #( ls_cr_response ) ).
      ELSEIF i_action = 'cancel-invoice'.
        xco_cp_json=>data->from_string( i_status )->apply( VALUE #(
        ( xco_cp_json=>transformation->pascal_case_to_underscore )
        ( xco_cp_json=>transformation->boolean_to_abap_bool )
        ) )->write_to( REF #( ls_cancel_response ) ).
      ENDIF.

      DATA: lv_date TYPE zde_char10,
            lv_time TYPE zde_char8.
      IF ls_cr_response IS NOT INITIAL.
        e_header-Seq = ls_cr_response-seq. "Số hóa đơn
        e_header-Serial = ls_cr_response-serial. "Serial
        e_header-Form = ls_cr_response-form. "Form
        e_header-EType = ls_cr_response-type. "Type Hóa đơn
        SPLIT ls_cr_response-idt AT '' INTO lv_date lv_time.
        IF lv_date IS NOT INITIAL.
          REPLACE ALL OCCURRENCES OF '-' IN lv_date WITH ''.
        ENDIF.
        IF lv_time IS NOT INITIAL.
          REPLACE ALL OCCURRENCES OF ':' IN lv_time WITH ''.
        ENDIF.
        e_header-Datissuance = lv_date.
        e_header-Timeissuance = lv_time.
        e_header-Mscqt = ls_cr_response-taxo. "Mã CQT quản lý
        e_header-Link = ls_cr_response-link.
        e_header-StatusInv = ls_cr_response-status.
        e_header-StatusCqt = ls_cr_response-status_received.
      ENDIF.

      CASE i_action.
        WHEN 'create-invoice'. "Lập hóa đơn nháp
          e_header-Iconsap = '@09@'.
          e_header-StatusSap = '02'.
          e_header-Datintegration = sy-datum.
          IF ls_cr_response-seq IS INITIAL.

          ELSE.

          ENDIF.
        WHEN 'adjust-invoice'. "Điều chỉnh hóa đơn
          e_header-Iconsap = '@09@'.
          e_header-StatusSap = '02'.
          e_header-Datintegration = sy-datum.
          IF ls_cr_response-seq IS INITIAL.

          ELSE.

          ENDIF.
        WHEN 'search-invoice'. "Tra cứu hóa đơn
          CASE ls_cr_response-status. "Trạng thái hóa đơn
            WHEN '1'. "Chờ cấp số.
              e_header-Iconsap = '@09@'.
              e_header-StatusSap = '02'.
              e_header-MsgTy = 'S'.
              e_header-MsgTx = 'Đã lập hóa đơn nháp - chờ cấp số'.
            WHEN '2'. "Chờ duyệt.
              e_header-Iconsap = '@09@'.
              e_header-StatusSap = '02'.
              e_header-MsgTy = 'S'.
              e_header-MsgTx = 'Đã lập hóa đơn nháp - Chờ duyệt'.
            WHEN '3'. "Đã Duyệt.
              CASE ls_cr_response-status_received.
                WHEN '0'. "Chờ gửi CQT
                  e_header-Iconsap = '@11@'.
                  e_header-StatusSap = '98'.
                  e_header-MsgTy = 'S'.
                  e_header-MsgTx = 'Đã phát hành hóa đơn - Chờ gửi CQT'.
                WHEN '1'. "Đã gửi CQT
                  e_header-Iconsap = '@11@'.
                  e_header-StatusSap = '98'.
                  e_header-MsgTy = 'S'.
                  e_header-MsgTx = 'Đã phát hành hóa đơn - Đã gửi CQT'.
                WHEN '2'. "Gửi không thành công
                  e_header-Iconsap = '@08@'.
                  e_header-StatusSap = '10'.
                  e_header-MsgTy = 'S'.
                  e_header-MsgTx = 'Đã phát hành hóa đơn - Gửi CQT không thành công'.
                WHEN '8'. "Kiểm tra hợp lệ(Hóa đơn không mã hợp lệ)
                  e_header-StatusSap = '99'.
                  e_header-MsgTy = 'S'.
                  e_header-MsgTx = 'Đã phát hành hóa đơn thành công'.
                WHEN '9'. "Kiểm tra không hợp lệ
                  e_header-Iconsap = '@08@'.
                  e_header-StatusSap = '10'.
                  e_header-MsgTy = 'S'.
                  e_header-MsgTx = 'Đã phát hành hóa đơn - CQT kiểm tra không hợp lệ'.
                WHEN '10'. "Đã cấp mã(HĐ có mã hợp lệ đã được CQT cấp mã)
                  e_header-Iconsap = '@2K@'.
                  e_header-StatusSap = '99'.
                  e_header-MsgTy = 'S'.
                  e_header-MsgTx = 'Đã phát hành hóa đơn thành công'.
                WHEN OTHERS.
              ENDCASE.
            WHEN '4'. "Đã hủy.
              e_header-StatusSap = '04'.
              e_header-MsgTy = 'S'.
              e_header-MsgTx = 'Hóa đơn đã hủy'.
            WHEN OTHERS.
          ENDCASE.
        WHEN 'cancel-invoice'. "Hủy hóa đơn
          IF ls_cancel_response-errorcode IS INITIAL.
            e_header-StatusSap = '04'.
            e_header-MsgTy = 'S'.
            e_header-MsgTx = 'Huỷ hóa đơn'.
            e_header-Datcancel = sy-datum.
          ELSE.
            e_header-Iconsap = '@0A@'.
            e_header-MsgTy = 'E'.
            e_header-MsgTx = ls_cancel_response-description.
          ENDIF.
        WHEN OTHERS.

      ENDCASE.

      "Hóa đơn bị điều chỉnh
      SELECT SINGLE * FROM zi_rap_einv_header WHERE Companycode = @i_einvoice-Companycode
                                                      AND Accountingdocument = @i_einvoice-BelnrSrc
                                                      AND fiscalyear = @i_einvoice-GjahrSrc
            INTO @DATA(ls_einv_header_src).
      IF sy-subrc EQ 0.
        ls_einv_header_src-StatusSapold = ls_einv_header_src-StatusSap.
        ls_einv_header_src-MsgOld = ls_einv_header_src-MsgTx.
        CASE i_einvoice-TypeDc.
          WHEN '3'. "Thay thế
            ls_einv_header_src-Iconsap = '@20@'.
            ls_einv_header_src-StatusSap = '07'.
            ls_einv_header_src-MsgTx = 'Hóa đơn đã bị thay thế'.
          WHEN '1' OR '2'. "Điều chỉnh tiền
            ls_einv_header_src-Iconsap = '@4K@'.
            ls_einv_header_src-StatusSap = '06'.
            ls_einv_header_src-MsgTx = 'Hóa đơn đã bị điều chỉnh'.
          WHEN OTHERS.
        ENDCASE.
        MOVE-CORRESPONDING ls_einv_header_src TO e_docsrc.
      ENDIF.
    ELSE.
      e_header-MsgTy = i_return-type.
      e_header-MsgTx = i_return-message.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
