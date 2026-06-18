*** Variables ***
${product_card}    css=mat-card.ribbon-card    xpath=//mat-card[contains(@class, 'ribbon-card')]
${product_name}    xpath=//div[contains(@class, 'item-name')]
${product_img}    xpath=//img[contains(@class, 'img-thumbnail')]
${product_price}    xpath=//div[contains(@class, 'item-price')]//span
${product_card_details}    xpath=//mat-dialog-content[contains(@class, 'mat-mdc-dialog-content')]
${search_icon}    xpath=//mat-icon[contains(@class, 'mat-search_icon-search')]
${search_input}    id=mat-input-1
${searched_product_card}    xpath=//div[contains(@class,'mat-mdc-tooltip-trigger product')]
${no_result_card}    xpath=//mat-card-title[contains(@class, 'mat-mdc-card-title')]//span
${close_search_icon}    xpath=//mat-icon[contains(@class, 'mat-search_icon-close')]
${search_results_header}    id=searchValue
${item_per_page}    css=.mat-mdc-select-min-line 
${previous_page_button}    css=.mat-mdc-paginator-navigation-previous
${next_page_button}    css=.mat-mdc-paginator-navigation-next
${dismiss_cookies_button}    css=.cc-btn.cc-dismiss
${paginator_range}    css=.mat-mdc-paginator-range-label
${items_per_page_selector}    css=.mat-mdc-paginator-touch-target
${items_per_page_options}    css=.mat-mdc-option.mdc-list-item