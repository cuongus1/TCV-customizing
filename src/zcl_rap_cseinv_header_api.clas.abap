CLASS zcl_rap_cseinv_header_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "Common Variables
    TYPES: BEGIN OF ty_range_option,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_option,

           BEGIN OF ty_keys_document,
             companycode        TYPE bukrs,
             accountingdocument TYPE belnr_d,
             fiscalyear         TYPE gjahr,
           END OF ty_keys_document,

           tt_ranges          TYPE TABLE OF ty_range_option,
           tt_rap_einv_header TYPE TABLE OF zi_rap_einv_header,
           tt_rap_einv_items  TYPE TABLE OF zi_rap_einv_items.

    "Behavior Variables
    TYPES:

      "Action delete
      tt_header_delete   TYPE TABLE FOR DELETE zcs_rap_einv_header\\cseinvoicesheader,
      tt_items_delete    TYPE TABLE FOR DELETE zcs_rap_einv_header\\cseinvoiceitems,

      "Action Read
      tt_header_readh    TYPE TABLE FOR READ IMPORT zcs_rap_einv_header\\cseinvoicesheader,
      tt_result_readh    TYPE TABLE FOR READ RESULT zcs_rap_einv_header\\cseinvoicesheader,

      tt_items_readi     TYPE TABLE FOR READ IMPORT zcs_rap_einv_header\\cseinvoiceitems,
      tt_result_readi    TYPE TABLE FOR READ RESULT zcs_rap_einv_header\\cseinvoiceitems,
      "Action Integration
      tt_header_inteeinv TYPE TABLE FOR ACTION IMPORT zcs_rap_einv_header\\cseinvoicesheader~inteeinv,
      tt_result_inteeinv TYPE TABLE FOR ACTION RESULT zcs_rap_einv_header\\cseinvoicesheader~inteeinv,
      "Action Cancel
      tt_canceleinv      TYPE TABLE FOR ACTION IMPORT zcs_rap_einv_header\\cseinvoicesheader~canceleinv,
      tt_cancel_result   TYPE TABLE FOR ACTION RESULT zcs_rap_einv_header\\cseinvoicesheader~canceleinv,
      "Action Search
      tt_search_einv     TYPE TABLE FOR ACTION IMPORT zcs_rap_einv_header\\cseinvoicesheader~SearchEINV,
      tt_search_result   TYPE TABLE FOR ACTION RESULT zcs_rap_einv_header\\cseinvoicesheader~SearchEINV,
      "Action Adjust
      tt_adjust_einv     TYPE TABLE FOR ACTION IMPORT zcs_rap_einv_header\\cseinvoicesheader~adjusteinv,
      tt_result_adjust   TYPE TABLE FOR ACTION RESULT zcs_rap_einv_header\\cseinvoicesheader~adjusteinv,
      "Action Replace
      tt_replace_einv    TYPE TABLE FOR ACTION IMPORT zcs_rap_einv_header\\cseinvoicesheader~replaceeinv,
      tt_result_replace  TYPE TABLE FOR ACTION RESULT zcs_rap_einv_header\\cseinvoicesheader~replaceeinv,

      "Common
      tt_mapped_early    TYPE RESPONSE FOR MAPPED EARLY zcs_rap_einv_header,
      tt_failed_early    TYPE RESPONSE FOR FAILED EARLY zcs_rap_einv_header,
      tt_reported_early  TYPE RESPONSE FOR REPORTED EARLY zcs_rap_einv_header,
      tt_reported_late   TYPE RESPONSE FOR REPORTED LATE zcs_rap_einv_header
      .
    CLASS-METHODS:
      "Class Contructor
      get_Instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_rap_cseinv_header_api,

      get_document      IMPORTING keys     TYPE ANY TABLE
                        EXPORTING e_header TYPE tt_rap_einv_header
                                  e_items  TYPE tt_rap_einv_items,

      get_user_password IMPORTING i_userpass   TYPE zrap_einv_user
                                  i_formserial TYPE zrap_einv_serial
                        EXPORTING e_userpass   TYPE zrap_einv_user
                                  e_formserial TYPE zrap_einv_serial
                                  e_return     TYPE bapiret2,

      move_log          IMPORTING i_input  TYPE zi_rap_einv_header
                        EXPORTING o_output TYPE zi_rap_einv_header,

      Check_adjust_doc IMPORTING i_einv_header TYPE zi_rap_einv_header
                       EXPORTING e_userpass    TYPE zrap_einv_user
                                 e_formserial  TYPE zrap_einv_serial
                                 e_return      TYPE bapiret2,
      "Class for Behavior
      delete_header IMPORTING keys     TYPE tt_header_delete"table for delete zcs_rap_einv_header\\cseinvoicesheader
                    CHANGING  mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                              failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                              reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header,

      delete_items IMPORTING keys     TYPE tt_items_delete "table for delete zcs_rap_einv_header\\cseinvoiceitems
                   CHANGING  mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                             failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                             reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      read_header IMPORTING keys     TYPE tt_header_readh "table for read import zcs_rap_einv_header\\cseinvoicesheader
                  CHANGING  result   TYPE tt_result_readh "table for read result zcs_rap_einv_header\\cseinvoicesheader
                            failed   TYPE tt_failed_early "response for failed early zi_rap_einv_header
                            reported TYPE tt_reported_early, "response for reported early zi_rap_einv_header

      read_items IMPORTING keys     TYPE tt_items_readi "table for read import zcs_rap_einv_header\\cseinvoiceitems
                 CHANGING  result   TYPE tt_result_readi "table for read result zcs_rap_einv_header\\cseinvoiceitems
                           failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                           reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      "Action Integration EInvoices
      inteEINV
        IMPORTING keys     TYPE tt_header_inteeinv "table for action import zcs_rap_einv_header\\cseinvoicesheader~inteeinv
        CHANGING  result   TYPE tt_result_inteeinv "table for action result zcs_rap_einv_header\\cseinvoicesheader~inteeinv
                  mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                  failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                  reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      "Action Cancel EInvoices
      canceleinv IMPORTING keys     TYPE tt_canceleinv "table for action import zcs_rap_einv_header\\cseinvoicesheader~canceleinv
                 CHANGING  result   TYPE tt_cancel_result "table for action result zcs_rap_einv_header\\cseinvoicesheader~canceleinv
                           mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                           failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                           reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      "Action Search EInvoices
      SearchEinv IMPORTING keys     TYPE tt_search_einv "table for action import zcs_rap_einv_header\\cseinvoicesheader~updatesteinv
                 CHANGING  result   TYPE tt_search_result "table for action result zcs_rap_einv_header\\cseinvoicesheader~updatesteinv
                           mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                           failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                           reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      "Action Adjust EInvoices
      adjusteinv IMPORTING keys     TYPE tt_adjust_einv "table for action import zcs_rap_einv_header\\einvoicesheader~adjusteinv
                 CHANGING  result   TYPE tt_result_adjust "table for action result zcs_rap_einv_header\\einvoicesheader~adjusteinv
                           mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                           failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                           reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      "Action Replace EInvoices
      replaceeinv  IMPORTING keys     TYPE tt_replace_einv "table for action import zcs_rap_einv_header\\cseinvoicesheader~replaceeinv
                   CHANGING  result   TYPE tt_result_replace "table for action result zcs_rap_einv_header\\cseinvoicesheader~replaceeinv
                             mapped   TYPE tt_mapped_early "response for mapped early zcs_rap_einv_header
                             failed   TYPE tt_failed_early "response for failed early zcs_rap_einv_header
                             reported TYPE tt_reported_early, "response for reported early zcs_rap_einv_header

      "Common Methods
      save_einvoices
        CHANGING reported TYPE tt_reported_late, "response for reported late zcs_rap_einv_header

      cleanup,
      cleanup_finalize .
  PROTECTED SECTION.
    CLASS-DATA: mo_instance TYPE REF TO zcl_rap_cseinv_header_api.
    CLASS-DATA: gt_einv_header TYPE TABLE OF zrap_einv_header,
                gt_einv_items  TYPE TABLE OF zrap_einv_items,
                gt_einv_docsrc TYPE TABLE OF zrap_einv_header.

    CLASS-DATA: gt_header_del TYPE TABLE OF zrap_einv_header,
                gt_items_del  TYPE TABLE OF zrap_einv_items.

    "Views Import
    CLASS-DATA: gt_key_document TYPE TABLE OF ty_keys_document.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_rap_cseinv_header_api IMPLEMENTATION.
  METHOD get_instance. "Class Contructor
    mo_instance = ro_instance = COND #( WHEN mo_instance IS BOUND
                                           THEN mo_instance
                                           ELSE NEW #( ) ).
  ENDMETHOD.

  METHOD get_document.
    DATA: lr_bukrs TYPE tt_ranges,
          lr_belnr TYPE tt_ranges,
          lr_gjahr TYPE tt_ranges.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_keys>).
      ASSIGN COMPONENT '%tky-Companycode' OF STRUCTURE <lfs_keys> TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc EQ 0.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = <lv_value> ) TO lr_bukrs.
      ENDIF.

      ASSIGN COMPONENT '%tky-Accountingdocument' OF STRUCTURE <lfs_keys> TO <lv_value>.
      IF sy-subrc EQ 0.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = <lv_value> ) TO lr_belnr.
      ENDIF.

      ASSIGN COMPONENT '%tky-Fiscalyear' OF STRUCTURE <lfs_keys> TO <lv_value>.
      IF sy-subrc EQ 0.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = <lv_value> ) TO lr_gjahr.
      ENDIF.
    ENDLOOP.

    SELECT * FROM zi_rap_einv_header WHERE Companycode IN @lr_bukrs
                                   AND Accountingdocument IN @lr_belnr
                                   AND Fiscalyear IN @lr_gjahr
                                   "AND seq IS INITIAL
    INTO CORRESPONDING FIELDS OF TABLE @e_header.

    SELECT * FROM zi_rap_einv_items WHERE Companycode IN @lr_bukrs
                                   AND Accountingdocument IN @lr_belnr
                                   AND Fiscalyear IN @lr_gjahr
    INTO CORRESPONDING FIELDS OF TABLE @e_items.
  ENDMETHOD.

  METHOD get_user_password.
    SELECT SINGLE * FROM zrap_einv_user WHERE Companycode = @i_userpass-companycode
                                  AND usertype = @i_userpass-usertype
    INTO CORRESPONDING FIELDS OF @e_userpass.
    IF sy-subrc NE 0.
      e_return-type = 'E'.
      e_return-message = TEXT-001.
    ENDIF.

    SELECT SINGLE * FROM zrap_einv_serial WHERE Companycode = @i_formserial-companycode
                                    AND usertype = @i_formserial-usertype
                                    AND etype = @i_formserial-etype
                                    AND Fiscalyear = @i_formserial-fiscalyear
    INTO CORRESPONDING FIELDS OF @e_formserial.
    IF sy-subrc NE 0.
      e_return-type = 'E'.
      e_return-message = TEXT-002 && ` ` && i_formserial-fiscalyear.
    ENDIF.
  ENDMETHOD.

  METHOD move_log.
    o_output-seq = i_input-Seq .
    o_output-serial = i_input-Serial .
    o_output-form = i_input-Form .
    o_output-EType = i_input-EType .
    o_output-mscqt = i_input-Mscqt .
    o_output-link = i_input-link .
    o_output-datintegration = i_input-Datintegration .
    o_output-datissuance = i_input-Datissuance .
    o_output-timeissuance = i_input-Timeissuance .
    o_output-datcancel = i_input-Datcancel .
    o_output-statussap = i_input-StatusSap .
    o_output-statusinv = i_input-StatusInv .
    o_output-statuscqt = i_input-StatusCqt .
    o_output-msgty = i_input-MsgTy .
    o_output-msgtx = i_input-MsgTx .
  ENDMETHOD.

  METHOD check_adjust_doc.

    DATA: lv_count TYPE int4.

    IF i_einv_header-Belnrsrc IS NOT INITIAL AND i_einv_header-Gjahrsrc IS NOT INITIAL AND i_einv_header-Typedc IS NOT INITIAL.

      lv_count = 0.

      SELECT COUNT( 1 )
      FROM zi_rap_einv_header
      WHERE Companycode = @i_einv_header-Companycode
      AND Accountingdocument = @i_einv_header-Accountingdocument
      AND Fiscalyear = @i_einv_header-Gjahrsrc
      AND statussap IN ('98','99','06')
      INTO @lv_count.
      IF lv_count = 0.
        e_return-type = 'E'.
        e_return-message = TEXT-003.
        REPLACE '&1' INTO e_return-message WITH i_einv_header-Belnrsrc.
        REPLACE '&2' INTO e_return-message WITH i_einv_header-Gjahrsrc.
      ELSE.
        lv_count = 0.

        "Trường hợp thay thế chứng từ.
        IF i_einv_header-Typedc = '3'.
          SELECT COUNT( 1 )
          FROM I_JournalEntry
          WHERE companycode = @i_einv_header-Companycode
            AND AccountingDocument = @i_einv_header-Belnrsrc
            AND Fiscalyear = @i_einv_header-Gjahrsrc
            AND reversedocument NE ''
            INTO @lv_count.
          IF lv_count = 0.
            e_return-type = 'E'.
            e_return-message = TEXT-007.
            REPLACE '&1' INTO e_return-message WITH i_einv_header-Belnrsrc.
            REPLACE '&2' INTO e_return-message WITH i_einv_header-Gjahrsrc.
          ENDIF.
        ENDIF.

        SELECT COUNT( 1 )
        FROM zi_rap_einv_header
        WHERE Companycode = @i_einv_header-Companycode
        AND Accountingdocument = @i_einv_header-Belnrsrc
        AND Fiscalyear = @i_einv_header-Gjahrsrc
        AND Currency = @i_einv_header-Currency
        INTO @lv_count.
        IF lv_count = 0.
          e_return-type = 'E'.
          e_return-message = TEXT-004.
        ELSE.
        ENDIF.

        SELECT COUNT( 1 )
        FROM zi_rap_einv_header
        WHERE Companycode = @i_einv_header-Companycode
        AND Accountingdocument = @i_einv_header-Accountingdocument
        AND Fiscalyear = @i_einv_header-Fiscalyear
        AND statussap IN ('07')
        AND gjahrsrc NE ''
        INTO @lv_count.
        IF lv_count NE 0.
          e_return-type = 'E'.
          e_return-message = TEXT-005.
        ENDIF.
      ENDIF.

      IF e_return NE 'E'.
        SELECT SINGLE companycode, accountingdocument, fiscalyear, usertype, etype
        FROM zi_rap_einv_header
        WHERE Companycode = @i_einv_header-Companycode
          AND Accountingdocument = @i_einv_header-Belnrsrc
          AND Fiscalyear = @i_einv_header-Gjahrsrc
        INTO @DATA(ls_userpass).
        IF sy-subrc NE 0.
          e_userpass-companycode = ls_userpass-Companycode.
          e_userpass-usertype = ls_userpass-Usertype.

          e_formserial-companycode = ls_userpass-Companycode.
          e_formserial-fiscalyear = ls_userpass-Fiscalyear.
          e_formserial-usertype = ls_userpass-Usertype.
          e_formserial-etype = ls_userpass-etype.
        ENDIF.
      ENDIF.

    ELSEIF i_einv_header-Belnrsrc IS INITIAL AND i_einv_header-Gjahrsrc IS INITIAL AND i_einv_header-Typedc IS INITIAL.

    ELSE.
      e_return-type = 'E'.
      e_return-message = TEXT-006.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    FREE:   gt_einv_header,
            gt_einv_items,
            gt_header_del,
            gt_items_del,
            gt_key_document,
            gt_einv_docsrc.
  ENDMETHOD.

  METHOD cleanup_finalize.
    zcl_rap_cseinv_header_api=>get_instance( )->cleanup( ).
  ENDMETHOD.

  METHOD save_einvoices.
*    LOOP AT gt_einv_docsrc INTO DATA(ls_einv_docsrc).
*      UPDATE zrap_einv_header SET iconsap = @ls_einv_docsrc-Iconsap ,
*                                  statussap = @ls_einv_docsrc-StatusSap ,
*                                  msgtx = @ls_einv_docsrc-MsgTx ,
*                                  statussapold = @ls_einv_docsrc-StatusSapold ,
*                                  msgold = @ls_einv_docsrc-MsgOld
*      WHERE companycode = @ls_einv_docsrc-Companycode
*        AND accountingdocument = @ls_einv_docsrc-Accountingdocument
*        AND fiscalyear = @ls_einv_docsrc-Fiscalyear.
*    ENDLOOP.
    MODIFY zrap_einv_header FROM TABLE @gt_einv_docsrc.
*    LOOP AT gt_einv_header INTO DATA(ls_einv_header).
*      UPDATE zrap_einv_header SET iconsap = @ls_einv_header-iconsap ,
*                                  seq = @ls_einv_header-Seq ,
*                                  serial = @ls_einv_header-Serial ,
*                                  form = @ls_einv_header-Form ,
*                                  EType = @ls_einv_header-EType ,
*                                  mscqt = @ls_einv_header-Mscqt,
*                                  link = @ls_einv_header-link,
*                                  datintegration = @ls_einv_header-Datintegration ,
*                                  datissuance = @ls_einv_header-Datissuance ,
*                                  timeissuance = @ls_einv_header-Timeissuance ,
*                                  datcancel = @ls_einv_header-Datcancel ,
*                                  statussap = @ls_einv_header-StatusSap ,
*                                  statusinv = @ls_einv_header-StatusInv ,
*                                  statuscqt = @ls_einv_header-StatusCqt ,
*                                  msgty = @ls_einv_header-MsgTy ,
*                                  msgtx = @ls_einv_header-MsgTx
*      WHERE companycode = @ls_einv_header-Companycode
*        AND accountingdocument = @ls_einv_header-Accountingdocument
*        AND fiscalyear = @ls_einv_header-Fiscalyear.
*    ENDLOOP.
    MODIFY zrap_einv_header FROM TABLE @gt_einv_header.

    IF gt_header_del IS NOT INITIAL.
      DELETE zrap_einv_header FROM TABLE @gt_header_del.
      DELETE zrap_einv_items FROM TABLE @gt_header_del.
    ENDIF.

    IF gt_items_del IS NOT INITIAL.
      DELETE zrap_einv_items FROM TABLE @gt_items_del.
    ENDIF.
  ENDMETHOD.

  METHOD delete_header.
    DATA: lt_einv_header TYPE TABLE OF zrap_einv_header.
    lt_einv_header = CORRESPONDING #( keys MAPPING FROM ENTITY ).
    LOOP AT lt_einv_header INTO DATA(ls_einv_header) WHERE seq IS INITIAL.
      APPEND VALUE #( companycode = ls_einv_header-companycode
      accountingdocument = ls_einv_header-accountingdocument
      fiscalyear = ls_einv_header-fiscalyear ) TO gt_header_del.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete_items.
    DATA: lt_einv_items TYPE TABLE OF zrap_einv_items.
    lt_einv_items = CORRESPONDING #( keys MAPPING FROM ENTITY ).
    LOOP AT lt_einv_items INTO DATA(ls_einv_items).
      SELECT COUNT(*) FROM zrap_einv_header
      WHERE companycode = @ls_einv_items-companycode
      AND accountingdocument = @ls_einv_items-accountingdocument
      AND fiscalyear = @ls_einv_items-fiscalyear
      AND seq EQ ''
      INTO @DATA(lv_count). "Check chứng từ đã phát hành hóa đơn chưa
      IF lv_count NE 0.
        APPEND VALUE #( companycode = ls_einv_items-companycode
          accountingdocument = ls_einv_items-accountingdocument
          fiscalyear = ls_einv_items-fiscalyear
          buzei = ls_einv_items-buzei ) TO gt_items_del.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD read_header.
*    DATA: lr_bukrs TYPE tt_ranges,
*          lr_belnr TYPE tt_ranges,
*          lr_gjahr TYPE tt_ranges.
*    LOOP AT keys INTO DATA(ls_keys).
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-Companycode ) TO lr_bukrs.
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-Accountingdocument ) TO lr_belnr.
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-Fiscalyear ) TO lr_gjahr.
*    ENDLOOP.
*
*    SELECT * FROM zrap_einv_header WHERE companycode IN @lr_bukrs
*      AND accountingdocument IN @lr_belnr
*      AND fiscalyear IN @lr_gjahr INTO TABLE @DATA(lt_einv_header).
*    IF sy-subrc EQ 0.
*      result = CORRESPONDING #( lt_einv_header MAPPING TO ENTITY ).
*    ELSE.
*
*    ENDIF.
    DATA: ls_result LIKE LINE OF result,
          lr_bukrs  TYPE tt_ranges,
          lr_belnr  TYPE tt_ranges,
          lr_gjahr  TYPE tt_ranges,

          lv_skip   TYPE int8,
          lv_top    TYPE int8.

    LOOP AT keys INTO DATA(ls_keys).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-companycode ) TO lr_bukrs.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-accountingdocument ) TO lr_belnr.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-FiscalYear ) TO lr_gjahr.
    ENDLOOP.

    lv_top = lines( lr_belnr ).
    zcl_rap_einv_generate=>get_instance( )->get_document(
        EXPORTING
        ir_bukrs = lr_bukrs
        ir_belnr = lr_belnr
        ir_gjahr = lr_gjahr
        iv_top   = lv_top
        iv_skip  = lv_skip
        IMPORTING
        header = DATA(lt_header)
        items = DATA(lt_items)
    ).
    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>).
      ls_result-%tky-companycode = <ls_header>-Companycode.
      ls_result-%tky-accountingdocument = <ls_header>-Accountingdocument.
      ls_result-%tky-FiscalYear = <ls_header>-Fiscalyear.
      MOVE-CORRESPONDING <ls_header> TO ls_result-%data.
      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.
    ENDLOOP.

    IF lt_header IS NOT INITIAL.
      MOVE-CORRESPONDING lt_header TO reported-cseinvoicesheader.
    ENDIF.

    IF lt_items IS NOT INITIAL.
      MOVE-CORRESPONDING lt_items TO reported-cseinvoiceitems.
    ENDIF.
  ENDMETHOD.

  METHOD read_items.
*    DATA: lr_bukrs TYPE tt_ranges,
*          lr_belnr TYPE tt_ranges,
*          lr_gjahr TYPE tt_ranges.
*    LOOP AT keys INTO DATA(ls_keys).
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-Companycode ) TO lr_bukrs.
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-Accountingdocument ) TO lr_belnr.
*      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-Fiscalyear ) TO lr_gjahr.
*    ENDLOOP.
*
*    SELECT * FROM zrap_einv_items
*    WHERE companycode IN @lr_bukrs
*      AND accountingdocument IN @lr_belnr
*      AND fiscalyear IN @lr_gjahr INTO TABLE @DATA(lt_einv_items).
*    IF sy-subrc EQ 0.
*      result = CORRESPONDING #( lt_einv_items MAPPING TO ENTITY ).
*    ELSE.
*
*    ENDIF.
    DATA: ls_result LIKE LINE OF result,
          lr_bukrs  TYPE tt_ranges,
          lr_belnr  TYPE tt_ranges,
          lr_gjahr  TYPE tt_ranges,

          lv_skip   TYPE int8,
          lv_top    TYPE int8.

    LOOP AT keys INTO DATA(ls_keys).
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-companycode ) TO lr_bukrs.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-accountingdocument ) TO lr_belnr.
      APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_keys-%tky-FiscalYear ) TO lr_gjahr.
    ENDLOOP.

    lv_top = lines( lr_belnr ).
    zcl_rap_einv_generate=>get_instance( )->get_document(
        EXPORTING
        ir_bukrs = lr_bukrs
        ir_belnr = lr_belnr
        ir_gjahr = lr_gjahr
        iv_top   = lv_top
        iv_skip  = lv_skip
        IMPORTING
        header = DATA(lt_header)
        items = DATA(lt_items)
    ).
    LOOP AT lt_items INTO DATA(ls_items).
      ls_result-%tky-companycode = ls_items-Companycode.
      ls_result-%tky-accountingdocument = ls_items-Accountingdocument.
      ls_result-%tky-FiscalYear = ls_items-Fiscalyear.
      MOVE-CORRESPONDING ls_items TO ls_result-%data.
      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.
    ENDLOOP.

    DATA: ls_rap_einv_header LIKE LINE OF reported-cseinvoicesheader.

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<ls_header>).
      MOVE-CORRESPONDING <ls_header> TO ls_rap_einv_header.
*        ls_rap_einv_header-%state_area = 'VALIDATE_FIELD'.
*        ls_rap_einv_header-%element-accountingdocument = if_abap_behv=>mk-on.
*        ls_rap_einv_header-%msg = new_message(  'Import Succesfull!' ).
      INSERT CORRESPONDING #( ls_rap_einv_header ) INTO TABLE reported-cseinvoicesheader.
    ENDLOOP.

    IF lt_items IS NOT INITIAL.
      MOVE-CORRESPONDING lt_items TO reported-cseinvoiceitems.
    ENDIF.

  ENDMETHOD.

  METHOD inteeinv.
    DATA: ls_param  TYPE zrk_inte_einvoice,

          lt_docsrc TYPE TABLE OF zi_rap_einv_header,
          ls_docsrc TYPE zi_rap_einv_header.

    DATA: lr_bukrs TYPE tt_ranges,
          lr_belnr TYPE tt_ranges,
          lr_gjahr TYPE tt_ranges.

    DATA: ls_mapped_header   LIKE LINE OF mapped-cseinvoicesheader,
          ls_mapped_item     LIKE LINE OF mapped-cseinvoiceitems,

          ls_reported_header LIKE LINE OF reported-cseinvoicesheader,
          ls_reported_items  LIKE LINE OF reported-cseinvoiceitems.

    DATA: ls_result LIKE LINE OF result.

    DATA:
      lv_action     TYPE zde_e_action,
      ls_einvoice   TYPE zi_rap_einv_header,
      ls_userpass   TYPE zrap_einv_user,
      ls_formserial TYPE zrap_einv_serial,
      lv_testrun    TYPE zde_testrun,
      ls_status     TYPE zi_rap_einv_header,
      ls_json       TYPE string,
      ls_return     TYPE bapiret2.

    LOOP AT keys INTO DATA(ls_keys).
      ls_param-companycode = ls_keys-%param-companycode.
      ls_param-usertype = ls_keys-%param-usertype.
      ls_param-etype = ls_keys-%param-etype.
*      ls_param-test_run = ls_keys-%param-test_run.
    ENDLOOP.

    MOVE-CORRESPONDING ls_param TO ls_userpass.
    MOVE-CORRESPONDING ls_param TO ls_formserial.

    lv_testrun = ''.

    zcl_rap_cseinv_header_api=>get_instance( )->get_document(
        EXPORTING
        keys = keys
        IMPORTING
        e_header = DATA(lt_rap_einv_header)
    ).

    IF lt_rap_einv_header IS INITIAL.

    ENDIF.

    LOOP AT lt_rap_einv_header ASSIGNING FIELD-SYMBOL(<lfs_rap_einv_header>).
      IF <lfs_rap_einv_header>-StatusSap = '' OR <lfs_rap_einv_header>-StatusSap = '01'
      OR <lfs_rap_einv_header>-StatusSap = '03'.
        IF <lfs_rap_einv_header>-Seq IS INITIAL.

*          SELECT SINGLE reversedocument,
*                 reversedocumentfiscalyear,
*                 isreversal,
*                 isreversed
*          FROM i_journalentry WHERE CompanyCode = @<lfs_rap_einv_header>-Companycode
*                                AND AccountingDocument = @<lfs_rap_einv_header>-Accountingdocument
*                                AND FiscalYear = @<lfs_rap_einv_header>-Fiscalyear
*          INTO @DATA(ls_reverse).
*          IF sy-subrc NE 0.
*            CLEAR: ls_reverse.
*          ENDIF.

          IF <lfs_rap_einv_header>-Xreversed IS INITIAL AND <lfs_rap_einv_header>-Xreversing IS INITIAL.
            MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_einvoice.

            ls_formserial-fiscalyear = <lfs_rap_einv_header>-Fiscalyear.
            zcl_rap_cseinv_header_api=>get_instance( )->get_user_password(
                EXPORTING
                i_userpass = ls_userpass
                i_formserial = ls_formserial
                IMPORTING
                e_userpass = ls_userpass
                e_formserial = ls_formserial
            ).

            ls_einvoice-Serial = ls_formserial-Serial.
            ls_einvoice-Form = ls_formserial-Form.

            IF ls_einvoice-BelnrSrc IS NOT INITIAL.
              lv_action = 'adjust-invoice'.
              zcl_manage_fpt_einvoices=>get_instance( )->adjust_einvoices(
                  EXPORTING
                  i_action    = lv_action
                  i_einvoice  = ls_einvoice
                  i_userpass  = ls_userpass
                  i_testrun   = lv_testrun
                  IMPORTING
                  e_status    = ls_status
                  e_docsrc    = ls_docsrc
                  e_json      = ls_json
                  e_return    = ls_return
              ).
            ELSE.
              lv_action = 'create-invoice'.
              zcl_manage_fpt_einvoices=>get_instance( )->create_einvoices(
                  EXPORTING
                  i_action    = lv_action
                  i_einvoice  = ls_einvoice
                  i_userpass  = ls_userpass
                  i_testrun   = lv_testrun
                  IMPORTING
                  e_status    = ls_status
                  e_docsrc    = ls_docsrc
                  e_json      = ls_json
                  e_return    = ls_return
              ).
            ENDIF.
            zcl_rap_cseinv_header_api=>get_instance( )->move_log(
                EXPORTING
                i_input = ls_status
                IMPORTING
                o_output = <lfs_rap_einv_header>
            ).
            IF ls_return-type = 'E'.
              <lfs_rap_einv_header>-Iconsap = '@0A@'.
              <lfs_rap_einv_header>-Statussap = '03'.
              <lfs_rap_einv_header>-MsgTy = ls_return-type.
              <lfs_rap_einv_header>-MsgTx = ls_return-message.
            ENDIF.
          ELSE.  "End check reverse
            <lfs_rap_einv_header>-MsgTy = 'E'.
            <lfs_rap_einv_header>-Statussap = '03'.
            <lfs_rap_einv_header>-MsgTx = 'Document Is Reversal/Reversed'.
          ENDIF.

        ELSE. "End check seq

        ENDIF.

      ELSE. "End check status

      ENDIF.

      ls_result-%tky-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%tky-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%tky-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-%key-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%key-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%key-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_mapped_header-%tky = ls_result-%tky.
      ls_mapped_header-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_mapped_header-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_mapped_header-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_result-%param.
      IF ls_docsrc IS NOT INITIAL.
        APPEND ls_docsrc TO lt_docsrc.
      ENDIF.

      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.
      INSERT CORRESPONDING #( ls_mapped_header ) INTO TABLE mapped-cseinvoicesheader.

      CLEAR: ls_docsrc, ls_status, ls_json, ls_return.
    ENDLOOP.

    MOVE-CORRESPONDING lt_rap_einv_header TO gt_einv_header.
    MOVE-CORRESPONDING lt_docsrc TO gt_einv_docsrc.
  ENDMETHOD.



  METHOD canceleinv.
    DATA:
      lv_action     TYPE zde_e_action,
      ls_einvoice   TYPE zi_rap_einv_header,
      ls_userpass   TYPE zrap_einv_user,
      ls_formserial TYPE zrap_einv_serial,
      lv_testrun    TYPE zde_testrun,
      ls_status     TYPE zi_rap_einv_header,
      ls_json       TYPE string,
      ls_return     TYPE bapiret2.

    DATA: ls_param  TYPE zrk_cancel_einv,
          ls_result LIKE LINE OF result.

    LOOP AT keys INTO DATA(ls_keys).
      ls_param-usertype = ls_keys-%param-usertype.
      ls_param-noti_taxtype = ls_keys-%param-noti_taxtype.
      ls_param-noti_taxnum = ls_keys-%param-noti_taxnum.
      ls_param-place = ls_keys-%param-place.
      ls_param-noti_type = ls_keys-%param-noti_type.
    ENDLOOP.

    zcl_rap_cseinv_header_api=>get_instance( )->get_document(
    EXPORTING
    keys = keys
    IMPORTING
    e_header = DATA(lt_rap_einv_header)
    ).
    lv_action = 'cancel-invoice'.

    LOOP AT lt_rap_einv_header ASSIGNING FIELD-SYMBOL(<lfs_rap_einv_header>).
      IF <lfs_rap_einv_header>-StatusSap = '98' OR <lfs_rap_einv_header>-StatusSap = '99'.

*        SELECT SINGLE reversedocument,
*           reversedocumentfiscalyear,
*           isreversal,
*           isreversed
*        FROM i_journalentry WHERE CompanyCode = @<lfs_rap_einv_header>-Companycode
*                              AND AccountingDocument = @<lfs_rap_einv_header>-Accountingdocument
*                              AND FiscalYear = @<lfs_rap_einv_header>-Fiscalyear
*        INTO @DATA(ls_reverse).
*        IF sy-subrc NE 0.
*          CLEAR: ls_reverse.
*        ENDIF.

        IF <lfs_rap_einv_header>-Xreversing IS INITIAL AND <lfs_rap_einv_header>-Xreversed IS INITIAL.
          "Message Error
        ELSE.

          ls_userpass-companycode = <lfs_rap_einv_header>-Companycode.
          ls_userpass-usertype = <lfs_rap_einv_header>-Usertype.

          ls_formserial-companycode = <lfs_rap_einv_header>-Companycode.
          ls_formserial-fiscalyear = <lfs_rap_einv_header>-Fiscalyear.
          ls_formserial-usertype = <lfs_rap_einv_header>-Usertype.
          ls_formserial-etype = <lfs_rap_einv_header>-Etype.

          zcl_rap_cseinv_header_api=>get_instance( )->get_user_password(
              EXPORTING
              i_userpass = ls_userpass
              i_formserial = ls_formserial
              IMPORTING
              e_userpass = ls_userpass
              e_formserial = ls_formserial
          ).

          zcl_manage_fpt_einvoices=>get_instance( )->cancel_einvoices(
            EXPORTING
            i_action = lv_action
            i_einvoice = ls_einvoice
            i_testrun = lv_testrun
            i_param = ls_param
            i_userpass = ls_userpass
            IMPORTING
            e_status   = ls_status
            e_return = ls_return
            e_json = ls_json
          ).

        ENDIF.
      ELSE. "End check status
        "Message Error
      ENDIF.

      IF ls_return-type NE 'E'.
        <lfs_rap_einv_header>-Iconsap = ls_status-Iconsap.
        <lfs_rap_einv_header>-Statussap = '03'.
        <lfs_rap_einv_header>-MsgTx = ls_status-MsgTx.
      ELSE.

      ENDIF.

      ls_result-%tky-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%tky-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%tky-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-%key-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%key-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%key-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.


      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_result-%param.
      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.

    ENDLOOP.

    MOVE-CORRESPONDING lt_rap_einv_header TO gt_einv_header.
  ENDMETHOD.

  METHOD searcheinv.
    DATA:
      lv_action   TYPE zde_e_action,
      ls_einvoice TYPE zi_rap_einv_header,
      ls_userpass TYPE zrap_einv_user,
      lv_testrun  TYPE zde_testrun,
      ls_status   TYPE zi_rap_einv_header,
      ls_json     TYPE string,
      ls_return   TYPE bapiret2.

    DATA: ls_docsrc TYPE zi_rap_einv_header,
          lt_docsrc TYPE TABLE OF zi_rap_einv_header.

    DATA: ls_result LIKE LINE OF result.

    zcl_rap_cseinv_header_api=>get_instance( )->get_document(
    EXPORTING
    keys = keys
    IMPORTING
    e_header = DATA(lt_rap_einv_header)
    ).
    LOOP AT lt_rap_einv_header ASSIGNING FIELD-SYMBOL(<lfs_rap_einv_header>).

      zcl_manage_fpt_einvoices=>get_instance( )->search_einvoices(
          EXPORTING
          i_action      = lv_action
          i_einvoice    = ls_einvoice
          i_testrun     = lv_testrun
          IMPORTING
          e_return      = ls_return
          e_status      = ls_status
          e_docsrc      = ls_docsrc
      ).

      SELECT SINGLE * FROM zi_rap_einv_header
      WHERE Companycode = @<lfs_rap_einv_header>-Companycode
        AND BelnrSrc = @<lfs_rap_einv_header>-Accountingdocument
        AND GjahrSrc = @<lfs_rap_einv_header>-Fiscalyear
      INTO @DATA(ls_adjust).
      IF sy-subrc EQ 0 AND ls_adjust-Seq IS NOT INITIAL.
        CASE ls_adjust-TypeDc.
          WHEN '3'. "Thay thế
            <lfs_rap_einv_header>-Iconsap = '@20@'.
            <lfs_rap_einv_header>-StatusSap = '07'.
            <lfs_rap_einv_header>-MsgTx = 'Hóa đơn đã bị thay thế'.
          WHEN '1' OR '2'. "Điều chỉnh tiền
            <lfs_rap_einv_header>-Iconsap = '@4K@'.
            <lfs_rap_einv_header>-StatusSap = '06'.
            <lfs_rap_einv_header>-MsgTx = 'Hóa đơn đã bị điều chỉnh'.
          WHEN OTHERS.
        ENDCASE.
      ELSE.
        zcl_rap_cseinv_header_api=>get_instance( )->move_log(
            EXPORTING
            i_input = ls_status
            IMPORTING
            o_output = <lfs_rap_einv_header>
        ).
      ENDIF.

      IF ls_docsrc IS NOT INITIAL.
        APPEND ls_docsrc TO lt_docsrc.
      ENDIF.

      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_result-%param.
      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.

    ENDLOOP.

    MOVE-CORRESPONDING lt_docsrc TO gt_einv_docsrc.
  ENDMETHOD.

  METHOD adjusteinv.
    TYPES: BEGIN OF lty_dc,
             bukrs TYPE bukrs,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
           END OF lty_dc.
    DATA: ls_dc TYPE lty_dc.

    DATA: ls_adj_einv TYPE zi_rap_einv_header.

    DATA:
      lv_action     TYPE zde_e_action,
      ls_einvoice   TYPE zi_rap_einv_header,
      ls_userpass   TYPE zrap_einv_user,
      ls_formserial TYPE zrap_einv_serial,
      lv_testrun    TYPE zde_testrun,
      ls_status     TYPE zi_rap_einv_header,
      ls_json       TYPE string,
      ls_return     TYPE bapiret2.

    DATA: ls_docsrc TYPE zi_rap_einv_header,
          lt_docsrc TYPE TABLE OF zi_rap_einv_header.

    DATA: ls_result        LIKE LINE OF result,
          ls_mapped_header LIKE LINE OF mapped-cseinvoicesheader.
    DATA: ls_param TYPE zrk_adjust_einv.

    zcl_rap_cseinv_header_api=>get_instance( )->get_document(
    EXPORTING
    keys = keys
    IMPORTING
    e_header = DATA(lt_rap_einv_header)
    ).
    LOOP AT keys INTO DATA(ls_keys).
      ls_dc-belnr = ls_param-Belnrsrc = ls_keys-%param-Belnrsrc.
      ls_dc-gjahr = ls_param-Gjahrsrc = ls_keys-%param-Gjahrsrc.
      ls_param-typedc = ls_keys-%param-typedc.
    ENDLOOP.


    LOOP AT lt_rap_einv_header ASSIGNING FIELD-SYMBOL(<lfs_rap_einv_header>).
      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_adj_einv.
      IF <lfs_rap_einv_header>-Statussap = '01'.
        IF ls_dc-belnr = ls_adj_einv-Belnrsrc AND ls_dc-gjahr = ls_adj_einv-Gjahrsrc.
          CONTINUE.
        ELSE.
          ls_adj_einv-Belnrsrc = ls_param-Belnrsrc.
          ls_adj_einv-Gjahrsrc = ls_param-Gjahrsrc.
          ls_adj_einv-Typedc = ls_param-typedc.

          zcl_rap_cseinv_header_api=>get_instance( )->check_adjust_doc(
             EXPORTING
             i_einv_header = ls_adj_einv
             IMPORTING
             e_userpass = ls_userpass
             e_formserial = ls_formserial
             e_return = ls_return
          ).

          IF ls_return-type NE 'E'.

          ELSE.
            <lfs_rap_einv_header>-Belnrsrc = ls_param-Belnrsrc.
            <lfs_rap_einv_header>-Gjahrsrc = ls_param-Gjahrsrc.
            <lfs_rap_einv_header>-Typedc = ls_param-typedc.
            IF <lfs_rap_einv_header>-Belnrsrc IS NOT INITIAL.

              zcl_rap_cseinv_header_api=>get_instance( )->get_user_password(
                  EXPORTING
                  i_userpass = ls_userpass
                  i_formserial = ls_formserial
                  IMPORTING
                  e_userpass = ls_userpass
                  e_formserial = ls_formserial
              ).

              lv_action = 'adjust-invoice'.
              zcl_manage_fpt_einvoices=>get_instance( )->adjust_einvoices(
                  EXPORTING
                  i_action    = lv_action
                  i_einvoice  = ls_einvoice
                  i_userpass  = ls_userpass
                  i_testrun   = lv_testrun
                  IMPORTING
                  e_status    = ls_status
                  e_docsrc    = ls_docsrc
                  e_json      = ls_json
                  e_return    = ls_return
              ).

              zcl_rap_cseinv_header_api=>get_instance( )->move_log(
                EXPORTING
                i_input = ls_status
                IMPORTING
                o_output = <lfs_rap_einv_header>
            ).
              IF ls_return-type = 'E'.
                <lfs_rap_einv_header>-Iconsap = '@0A@'.
                <lfs_rap_einv_header>-Statussap = '03'.
                <lfs_rap_einv_header>-MsgTy = ls_return-type.
                <lfs_rap_einv_header>-MsgTx = ls_return-message.
              ENDIF.

            ENDIF.
          ENDIF.

        ENDIF.
      ELSE.
        "MESSAGE Error
      ENDIF.

      ls_result-%tky-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%tky-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%tky-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-%key-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%key-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%key-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_mapped_header-%tky = ls_result-%tky.
      ls_mapped_header-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_mapped_header-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_mapped_header-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_result-%param.
      IF ls_docsrc IS NOT INITIAL.
        APPEND ls_docsrc TO lt_docsrc.
      ENDIF.

      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.
      INSERT CORRESPONDING #( ls_mapped_header ) INTO TABLE mapped-cseinvoicesheader.

      CLEAR: ls_docsrc, ls_status, ls_json, ls_return.

    ENDLOOP.

    MOVE-CORRESPONDING lt_rap_einv_header TO gt_einv_header.
    MOVE-CORRESPONDING lt_docsrc TO gt_einv_docsrc.
  ENDMETHOD.

  METHOD replaceeinv.
    TYPES: BEGIN OF lty_dc,
             bukrs TYPE bukrs,
             belnr TYPE belnr_d,
             gjahr TYPE gjahr,
           END OF lty_dc.
    DATA: ls_dc TYPE lty_dc.

    DATA: ls_adj_einv TYPE zi_rap_einv_header.

    DATA:
      lv_action     TYPE zde_e_action,
      ls_einvoice   TYPE zi_rap_einv_header,
      ls_userpass   TYPE zrap_einv_user,
      ls_formserial TYPE zrap_einv_serial,
      lv_testrun    TYPE zde_testrun,
      ls_status     TYPE zi_rap_einv_header,
      ls_json       TYPE string,
      ls_return     TYPE bapiret2.

    DATA: ls_docsrc TYPE zi_rap_einv_header,
          lt_docsrc TYPE TABLE OF zi_rap_einv_header.

    DATA: ls_result        LIKE LINE OF result,
          ls_mapped_header LIKE LINE OF mapped-cseinvoicesheader.
    DATA: ls_param TYPE zrk_adjust_einv.

    zcl_rap_cseinv_header_api=>get_instance( )->get_document(
    EXPORTING
    keys = keys
    IMPORTING
    e_header = DATA(lt_rap_einv_header)
    ).
    LOOP AT keys INTO DATA(ls_keys).
      ls_dc-belnr = ls_param-Belnrsrc = ls_keys-%param-Belnrsrc.
      ls_dc-gjahr = ls_param-Gjahrsrc = ls_keys-%param-Gjahrsrc.
      ls_param-typedc = ls_keys-%param-typedc.
    ENDLOOP.


    LOOP AT lt_rap_einv_header ASSIGNING FIELD-SYMBOL(<lfs_rap_einv_header>).
      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_adj_einv.
      IF <lfs_rap_einv_header>-Statussap = '01'.
        IF ls_dc-belnr = ls_adj_einv-Belnrsrc AND ls_dc-gjahr = ls_adj_einv-Gjahrsrc.
          CONTINUE.
        ELSE.
          ls_adj_einv-Belnrsrc = ls_param-Belnrsrc.
          ls_adj_einv-Gjahrsrc = ls_param-Gjahrsrc.
          ls_adj_einv-Typedc = ls_param-typedc.

          zcl_rap_cseinv_header_api=>get_instance( )->check_adjust_doc(
             EXPORTING
             i_einv_header = ls_adj_einv
             IMPORTING
             e_userpass = ls_userpass
             e_formserial = ls_formserial
             e_return = ls_return
          ).

          IF ls_return-type NE 'E'.

          ELSE.
            <lfs_rap_einv_header>-Belnrsrc = ls_param-Belnrsrc.
            <lfs_rap_einv_header>-Gjahrsrc = ls_param-Gjahrsrc.
            <lfs_rap_einv_header>-Typedc = ls_param-typedc.
            IF <lfs_rap_einv_header>-Belnrsrc IS NOT INITIAL.

              zcl_rap_cseinv_header_api=>get_instance( )->get_user_password(
                  EXPORTING
                  i_userpass = ls_userpass
                  i_formserial = ls_formserial
                  IMPORTING
                  e_userpass = ls_userpass
                  e_formserial = ls_formserial
              ).

              lv_action = 'adjust-invoice'.
              zcl_manage_fpt_einvoices=>get_instance( )->adjust_einvoices(
                  EXPORTING
                  i_action    = lv_action
                  i_einvoice  = ls_einvoice
                  i_userpass  = ls_userpass
                  i_testrun   = lv_testrun
                  IMPORTING
                  e_status    = ls_status
                  e_docsrc    = ls_docsrc
                  e_json      = ls_json
                  e_return    = ls_return
              ).

              zcl_rap_cseinv_header_api=>get_instance( )->move_log(
                EXPORTING
                i_input = ls_status
                IMPORTING
                o_output = <lfs_rap_einv_header>
            ).
              IF ls_return-type = 'E'.
                <lfs_rap_einv_header>-Iconsap = '@0A@'.
                <lfs_rap_einv_header>-Statussap = '03'.
                <lfs_rap_einv_header>-MsgTy = ls_return-type.
                <lfs_rap_einv_header>-MsgTx = ls_return-message.
              ENDIF.

            ENDIF.
          ENDIF.

        ENDIF.
      ELSE.
        "MESSAGE Error
      ENDIF.

      ls_result-%tky-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%tky-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%tky-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-%key-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-%key-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-%key-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_result-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_result-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_result-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      ls_mapped_header-%tky = ls_result-%tky.
      ls_mapped_header-Companycode = <lfs_rap_einv_header>-Companycode.
      ls_mapped_header-Accountingdocument = <lfs_rap_einv_header>-Accountingdocument.
      ls_mapped_header-Fiscalyear = <lfs_rap_einv_header>-Fiscalyear.

      MOVE-CORRESPONDING <lfs_rap_einv_header> TO ls_result-%param.
      IF ls_docsrc IS NOT INITIAL.
        APPEND ls_docsrc TO lt_docsrc.
      ENDIF.

      INSERT CORRESPONDING #( ls_result ) INTO TABLE result.
      INSERT CORRESPONDING #( ls_mapped_header ) INTO TABLE mapped-cseinvoicesheader.

      CLEAR: ls_docsrc, ls_status, ls_json, ls_return.

    ENDLOOP.

    MOVE-CORRESPONDING lt_rap_einv_header TO gt_einv_header.
    MOVE-CORRESPONDING lt_docsrc TO gt_einv_docsrc.
  ENDMETHOD.
ENDCLASS.
