*** Settings ***
Documentation   Only the robot is allowed to get the orders file. You may not save the file manually on your computer.
Library     RPA.HTTP

*** Variable ***
${LINK_DOWNLOAD_ORDERS}   https://robotsparebinindustries.com/orders.csv

*** Keywords ***
download order list
    Download  ${LINK_DOWNLOAD_ORDERS}   target_file=input/orderlist.csv    overwrite=True

