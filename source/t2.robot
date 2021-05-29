*** Settings ***
Documentation   
Library     RPA.Browser.Selenium

*** Keywords ***
click on agree policy
    Wait Until Page Contains Element    css:button
    Click Button    css:button
