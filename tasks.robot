*** Settings ***
Documentation     Starter robot for the Beginners' course.
Library           RPA.Browser.Selenium
Library           RPA.Tables
Library           RPA.PDF
#Suite Teardown    Close All Browsers

*** Variable ***
${PAGE_FORM_ORDER}   https://robotsparebinindustries.com/#/robot-order
${RECEIPT_SELECTOR}    id:receipt
${RETRY_N_TIMES}        10x
${RETRY_AFTER_TIME}     1 sec

*** Keywords ***
1 click on agree policy
    Wait Until Page Contains Element    css:button.btn-dark
    Wait Until Element Is Visible       css:button.btn-dark
    Click Button    css:button.btn-dark


*** Keywords ****
2 fill in detail
    [Arguments]     ${order}
    Wait Until Page Contains Element    css:form
    Select From List By Value   head    ${order}[Head]
    Click Element   id:id-body-${order}[Body]
    Input Text    css:input.form-control\[type=number\]   ${order}[Legs]   
    Input Text    address       ${order}[Address]

*** Keywords ***
3 screenshot Robot
    [Arguments]     ${orderNumber}
    Click Button    id:preview
    Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}    Wait Until Element Is Visible   css:\#robot-preview-image img
    Screenshot      id:robot-preview-image    ${CURDIR}${/}output${/}robot_screenshot_${orderNumber}.png

*** Keywords ***
4 submit order
    Wait Until Page Contains Element    id:order
    Wait Until Element Is Visible    id:order
    Click Button    id:order
    Wait Until Page Contains Element    ${RECEIPT_SELECTOR}
    Wait Until Element Is Visible    ${RECEIPT_SELECTOR}

*** Keywords ***
5 screenshot Receipt
    [Arguments]    ${orderNumber}
    Wait Until Page Contains Element    ${RECEIPT_SELECTOR}
    Wait Until Element Is Visible    ${RECEIPT_SELECTOR}
    Screenshot    id:receipt    ${CURDIR}${/}output${/}receipt_screenshot_${orderNumber}.png


*** Keywords ***
6 save receipt to pdf
    [Arguments]    ${orderNumber}
    Wait Until Element Is Visible    ${RECEIPT_SELECTOR}
    ${receipt}=    Get Element Attribute    ${RECEIPT_SELECTOR}    outerHTML
    Html To Pdf    ${receipt}    ${CURDIR}${/}output${/}receipt_${orderNumber}.pdf
    ${robotImages}=     Create List
        ...     ${CURDIR}${/}output${/}receipt_${orderNumber}.pdf
        ...     ${CURDIR}${/}output${/}robot_screenshot_${orderNumber}.png:width=200px,align=center    
    Add Files To Pdf   ${robotImages}   ${CURDIR}${/}output${/}receipt_${orderNumber}.pdf
    Close All Pdfs

*** Keywords***
7 order another
    Wait Until Page Contains Element    id:order-another
    Click Button    id:order-another

*** Tasks ***
from orderlist, foreach order, submit order and save receipt
    Open Available Browser  ${PAGE_FORM_ORDER} 
    ${table}=    Read table from CSV    input/orderlist.csv     header=true
    FOR  ${row}  IN  @{table}
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  1 click on agree policy
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  2 fill in detail  ${row}
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  3 screenshot Robot      ${row}[Order number]
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  4 submit order
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  5 screenshot Receipt    ${row}[Order number]
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  6 save receipt to pdf    ${row}[Order number]
        Wait Until Keyword Succeeds    ${RETRY_N_TIMES}    ${RETRY_AFTER_TIME}  7 order another
    END
    [Teardown]  Close Browser
