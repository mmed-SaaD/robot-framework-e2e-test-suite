*** Variables ***
${add_new_address_button}    css=button[aria-label='Add a new address']
${country_input_element}    css=input[placeholder='Please provide a country.']
${name_input_element}    css=input[placeholder='Please provide a name.']
${mobile_number_input_element}    css=input[placeholder='Please provide a mobile number.']
${zip_input_element}    css=input[placeholder='Please provide a ZIP code.']
${address_input_element}    css=textarea[placeholder='Please provide an address.']
${city_input_element}    css=input[placeholder='Please provide a city.']
${state_input_element}    css=input[placeholder='Please provide a state.']
${submit_button}    id=submitButton
${addresses_list_row_element}    css=.mat-mdc-row.mdc-data-table__row
${continue_to_delivery_button}    css=button[aria-label='Proceed to payment selection']
${continue_to_payment_button}    css=button[aria-label='Proceed to delivery method selection']
${methods_table}    css=.mat-mdc-table.mdc-data-table__table.cdk-table
${delivery_method_row}    css=.mat-mdc-row
${delivery_method_cell}    .//mat-cell[contains(@class,'mat-column-Selection')]
${delivery_method_cost_cell}    .//mat-cell[contains(@class,'mat-column-Price')]
${payment_methods_page_header}    xpath=//h1[normalize-space()='My Payment Options']
${add_credit_card_container}    xpath=//mat-panel-description[normalize-space()='Add a credit or debit card']
${credit_card_info_container}    //mat-form-field[contains(@class, 'mat-mdc-form-field')]//input[not(@disabled)]
${credit_card_info_select}    xpath=//select[@matnativecontrol]
${proceed_to_review_button}    css=button[aria-label='Proceed to review']
${order_summary_container}    css=.mdc-card.container
${checkout_button}    id=checkoutButton
${print_order}     css=button[aria-label='Print order confirmation']
${order_history_header}    xpath=//mat-card-title[normalize-space()='Order History']

