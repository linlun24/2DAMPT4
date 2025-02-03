CLASS zcl_customer_manager_lul DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      add_customer
        IMPORTING
          customer_id     TYPE z_customer_id_lul
          customer_name   TYPE z_customer_name_lul
          customer_activo TYPE z_customer_activo_lul
        RETURNING
          VALUE(result)   TYPE sysubrc,

      update_customer
        IMPORTING
          customer_id     TYPE z_customer_id_lul
          customer_name   TYPE z_customer_name_lul
          customer_activo TYPE z_customer_activo_lul
        RETURNING
          VALUE(result)   TYPE sysubrc,

      delete_customer
        IMPORTING
          customer_id   TYPE z_customer_id_lul
        RETURNING
          VALUE(result) TYPE sysubrc.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_customer_manager_lul IMPLEMENTATION.
  METHOD add_customer.
    DATA: ls_customer TYPE ztcustomer_lul.

    " Verificar si el cliente ya existe
    SELECT SINGLE @abap_true
      FROM ztcustomer_lul
      WHERE customer_id = @customer_id
      INTO @DATA(lv_exists).

    IF lv_exists = abap_true.
      " Si el cliente existe, actualizamos
      UPDATE ztcustomer_lul
        SET customer_name = @customer_name,
            customer_activo = @customer_activo
        WHERE customer_id = @customer_id.
    ELSE.
      " Si el cliente no existe, insertamos
      ls_customer-client = sy-mandt. " Cliente actual
      ls_customer-customer_id = customer_id.
      ls_customer-customer_name = customer_name.
      ls_customer-customer_activo = customer_activo.

      " Insertar el registro
      INSERT INTO ztcustomer_lul VALUES @ls_customer.
    ENDIF.

    result = sy-subrc. " Retornar código de resultado

  ENDMETHOD.

  METHOD update_customer.
    UPDATE ztcustomer_lul
      SET customer_name = @customer_name,
          customer_activo = @customer_activo
      WHERE customer_id = @customer_id.
    result = sy-subrc.

  ENDMETHOD.

  METHOD delete_customer.
    DELETE FROM ztcustomer_lul WHERE customer_id = @customer_id.
    result = sy-subrc.

  ENDMETHOD.

ENDCLASS.
