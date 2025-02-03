CLASS zcl_main_lul DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_main_lul IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
  " Declaramos local object referenciando la otra clase
    DATA: lo_customer_manager TYPE REF TO zcl_customer_manager_lul,
          " Declaramos local structure, table según estructura
          ls_customer         TYPE zstruct_customer_lul,
          lt_customers        TYPE TABLE OF zstruct_customer_lul,
          lv_result           TYPE sysubrc.

    " Desde el objeto manager
    CREATE OBJECT lo_customer_manager.

    " Llamamos a add_c e insertamos 4 registros
    DO 4 TIMES.
      lv_result = lo_customer_manager->add_customer(
        customer_id     = CONDENSE( |CUST{ sy-index }| )
        customer_name   = |Customer { sy-index }|
        customer_activo = COND #( WHEN sy-index MOD 2 = 0 THEN 'X' ELSE ' ' )
      ).
      IF lv_result = 0.
        out->write( |Customer { sy-index } added successfully.| ).
      ELSE.
        out->write( |Error adding customer { sy-index }.| ).
      ENDIF.
    ENDDO.

    " Modificamos algunos registros
    lv_result = lo_customer_manager->update_customer(
      customer_id     = 'CUST1'
      customer_name   = 'Updated Customer 1'
      customer_activo = 'X'
    ).
    IF lv_result = 0.
      out->write( 'Customer CUST1 updated successfully.' ).
    ELSE.
      out->write( 'Error updating customer CUST1.' ).
    ENDIF.

    lv_result = lo_customer_manager->update_customer(
      customer_id     = 'CUST3'
      customer_name   = 'Updated Customer 3'
      customer_activo = 'X'
    ).
    IF lv_result = 0.
      out->write( 'Customer CUST3 updated successfully.' ).
    ELSE.
      out->write( 'Error updating customer CUST3.' ).
    ENDIF.


    " Eliminamos un registro
    lv_result = lo_customer_manager->delete_customer( customer_id = 'CUST4' ).
    IF lv_result = 0.
      out->write( 'Customer CUST4 deleted successfully.' ).
    ELSE.
      out->write( 'Error deleting customer CUST4.' ).
    ENDIF.

    " Realizamos consulta y mostramos resultado
    SELECT customer_id, customer_name, customer_activo FROM ztcustomer_lul INTO TABLE @lt_customers.
    out->write( 'Clientes actuales:' ).
    LOOP AT lt_customers INTO ls_customer.
      out->write( |ID: { ls_customer-customer_id }, Name: { ls_customer-customer_name }, Activo: { ls_customer-customer_activo }| ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
