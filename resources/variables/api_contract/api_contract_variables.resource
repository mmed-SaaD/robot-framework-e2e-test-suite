*** Settings ***
Library    Collections

*** Variables ***
@{products_fields}      id    name    description    price    image    createdAt    updatedAt
@{basket_fields}    id    coupon    UserId    createdAt    updatedAt    Products
@{order_fields}    promotionalAmount    paymentId    addressId    orderId    delivered    email    
...    totalPrice    products