*** Settings ***
Documentation     Starter robot for the Beginners' course.
Library           RPA.Browser.Selenium
Library           RPA.Tables
Library           RPA.PDF
#Suite Teardown    Close All Browsers

*** Variable ***
${PAGE_FORM_ORDER}   https://robotsparebinindustries.com/#/robot-order
${RECEIPT_SELECTOR}    id:receipt

*** Keywords ***
1 OrderAll
    Open Available Browser  ${PAGE_FORM_ORDER} 
    1.a click on agree policy
    ${table}=    Read table from CSV    input/orderlist.csv     header=true
    FOR  ${row}  IN  @{table}
        1.b fill in detail  ${row}
        2 screenshot Robot      ${row}[Order number]
        3 submit order
        4 screenshot Receipt    ${row}[Order number]
        5 save receipt to pdf    ${row}[Order number]
        #6 order another
    END

*** Keywords ***
1.a click on agree policy
    Wait Until Page Contains Element    css:button.btn-dark
    Click Button    css:button.btn-dark


*** Keywords ****
1.b fill in detail
    [Arguments]     ${order}
    Wait Until Page Contains Element    css:form
    Select From List By Value   head    ${order}[Head]
    Click Element   id:id-body-${order}[Body]
    Input Text    css:input.form-control\[type=number\]   ${order}[Legs]   
    Input Text    address       ${order}[Address]

*** Keywords ***
2 screenshot Robot
    [Arguments]     ${orderNumber}
    Click Button    id:preview
    Wait Until Element Is Visible   css:\#robot-preview-image img
    Screenshot      id:robot-preview-image    ${CURDIR}${/}output${/}robot_screenshot_${orderNumber}.png

*** Keywords ***
3 submit order
    Wait Until Page Contains Element    id:order
    Wait Until Element Is Visible    id:order
    Click Button    id:order

*** Keywords ***
4 screenshot Receipt
    [Arguments]    ${orderNumber}
    Wait Until Page Contains Element    ${RECEIPT_SELECTOR}
    Wait Until Element Is Visible    ${RECEIPT_SELECTOR}
    Screenshot    id:receipt    ${CURDIR}${/}output${/}receipt_screenshot_${orderNumber}.png


*** Keywords ***
5 save receipt to pdf
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
6 order another
    Wait Until Element Contains    id:order-another
    Click Button    order-another

*** Tasks ***
    1 OrderAll
