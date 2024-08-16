CLASS lhc_CSEInvoicesHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR CSEInvoicesHeader RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CSEInvoicesHeader RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE CSEInvoicesHeader.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE CSEInvoicesHeader.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE CSEInvoicesHeader.

    METHODS read FOR READ
      IMPORTING keys FOR READ CSEInvoicesHeader RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK CSEInvoicesHeader.

    METHODS rba_Einvoiceitems FOR READ
      IMPORTING keys_rba FOR READ CSEInvoicesHeader\_Einvoiceitems FULL result_requested RESULT result LINK association_links.

    METHODS cba_Einvoiceitems FOR MODIFY
      IMPORTING entities_cba FOR CREATE CSEInvoicesHeader\_Einvoiceitems.

    METHODS AdjustEINV FOR MODIFY
      IMPORTING keys FOR ACTION CSEInvoicesHeader~AdjustEINV RESULT result.

    METHODS CancelEINV FOR MODIFY
      IMPORTING keys FOR ACTION CSEInvoicesHeader~CancelEINV RESULT result.

    METHODS InteEINV FOR MODIFY
      IMPORTING keys FOR ACTION CSEInvoicesHeader~InteEINV RESULT result.

    METHODS ReplaceEINV FOR MODIFY
      IMPORTING keys FOR ACTION CSEInvoicesHeader~ReplaceEINV RESULT result.

    METHODS SearchEINV FOR MODIFY
      IMPORTING keys FOR ACTION CSEInvoicesHeader~SearchEINV RESULT result.

ENDCLASS.

CLASS lhc_CSEInvoicesHeader IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
    zcl_rap_cseinv_header_api=>get_instance( )->read_header(
        EXPORTING
        keys = keys
        CHANGING
        result = result
        failed = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Einvoiceitems.
  ENDMETHOD.

  METHOD cba_Einvoiceitems.
  ENDMETHOD.

  METHOD AdjustEINV.
    zcl_rap_cseinv_header_api=>get_instance( )->adjusteinv(
        EXPORTING
        keys = keys
        CHANGING
        result = result
        mapped = mapped
        failed = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD CancelEINV.
    zcl_rap_cseinv_header_api=>get_instance( )->canceleinv(
          EXPORTING
          keys = keys
          CHANGING
          result = result
          mapped = mapped
          failed = failed
          reported = reported
      ).
  ENDMETHOD.

  METHOD InteEINV.
    zcl_rap_cseinv_header_api=>get_instance( )->inteeinv(
          EXPORTING
          keys = keys
          CHANGING
          result = result
          mapped = mapped
          failed = failed
          reported = reported
      ).
  ENDMETHOD.

  METHOD ReplaceEINV.
    zcl_rap_cseinv_header_api=>get_instance( )->replaceeinv(
          EXPORTING
          keys = keys
          CHANGING
          result = result
          mapped = mapped
          failed = failed
          reported = reported
      ).
  ENDMETHOD.

  METHOD SearchEINV.
    zcl_rap_cseinv_header_api=>get_instance( )->searcheinv(
          EXPORTING
          keys = keys
          CHANGING
          result = result
          mapped = mapped
          failed = failed
          reported = reported
      ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_CSEInvoiceItems DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE CSEInvoiceItems.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE CSEInvoiceItems.

    METHODS read FOR READ
      IMPORTING keys FOR READ CSEInvoiceItems RESULT result.

    METHODS rba_Einvoices FOR READ
      IMPORTING keys_rba FOR READ CSEInvoiceItems\_Einvoices FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_CSEInvoiceItems IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
    zcl_rap_cseinv_header_api=>get_instance( )->read_items(
        EXPORTING
        keys = keys
        CHANGING
        result = result
        failed = failed
        reported = reported
    ).
  ENDMETHOD.

  METHOD rba_Einvoices.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCS_RAP_EINV_HEADER DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCS_RAP_EINV_HEADER IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    zcl_rap_cseinv_header_api=>get_instance( )->save_einvoices(
      CHANGING
      reported = reported
    ).
  ENDMETHOD.

  METHOD cleanup.
    zcl_rap_cseinv_header_api=>get_instance( )->cleanup( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
    zcl_rap_cseinv_header_api=>get_instance( )->cleanup_finalize( ).
  ENDMETHOD.

ENDCLASS.
