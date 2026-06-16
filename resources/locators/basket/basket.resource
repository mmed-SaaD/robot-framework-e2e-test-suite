*** Variables ***
${add_to_basket_button}    css=.btn-basket
${basket_items_count}    css=.warn-notification
${item_added_message}    css=.mat-mdc-snack-bar-label.mdc-snackbar__label   
${item_cannot_be_added}   css=div[aria-label='We are out of stock! Sorry for the inconvenience.'], div[aria-label='You can order only up to 5 items of this product.']
${show_basket_button}    css=button[aria-label='Show the shopping cart']
${basket_container}    xpath=//mat-card[contains(@class,'mdc-card')]
${basket_row_element}    xpath=//mat-row[contains(@class,'mat-mdc-row')]
${basket_product_name_element}    .//mat-cell[contains(@class,'mat-column-product')]
${basket_product_price_element}    .//mat-cell[contains(@class,'mat-column-price')]
${basket_product_quantity_element}    .//mat-cell[contains(@class,'mat-column-quantity')]
${basket_product_quantity_buttons}    .//mat-cell[contains(@class,'mat-column-quantity')]//button
${basket_remove_product_button}    .//mat-cell[contains(@class,'mat-column-remove')]//button
${basket_checkout_button}    css=.checkout-button
${to_homepage_button}    css=button[aria-label='Back to homepage']
${checkout_total_price}    id=price

