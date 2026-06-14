*** Variables ***
${banner}    css=.mat-mdc-dialog-surface.mdc-dialog__surface
${dismiss_banner_button}    //*[@id="mat-mdc-dialog-0"]/div/div/app-welcome-banner/div[2]/button[2]/mat-icon
${list_of_products}    xpath=//mat-grid-tile[contains(@class, 'mat-grid-tile')]
${basket_icon}    xpath=//mat-icon[normalize-space()='shopping_cart']
${support_chat}    xpath=//mat-icon[normalize-space()='chat']
${menu_button}    css=.mdc-icon-button.mat-mdc-icon-button.mat-mdc-button-base.mat-mdc-tooltip-trigger.nav-square-button.mat-unthemed
${side_navbar}    xpath=//sidenav
${outside_navbar_content}    css=.mat-drawer-backdrop
${chat_support_message_input}    id=message-input
