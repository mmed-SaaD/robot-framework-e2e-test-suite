import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';
const searchKeyword = __ENV.SEARCH_KEYWORD || 'juice';
const EMAIL = __ENV.EMAIL;
const PASSWORD = __ENV.PASSWORD;

export const options = {
    stages : [
        {duration : '3s', target : 15},
        {duration : '5s', target : 200},
        {duration : '15s', target : 200},
        {duration : '3s', target : 15},
        {duration : '30s', target : 0},
    ],
    thresholds : {
        http_req_failed : ['rate<0.05'],
        'http_req_duration{type:search}' : ['p(95)<2000'],
        'http_req_duration{type:auth}' : ['p(95)<2500'],
        'http_req_duration{type:basket}' : ['p(95)<3000'],
        'http_req_duration{type:feedback}' : ['p(95)<3500'],
    }
};

export default function(){
    // PERF-PROD-001
    let searchResp = http.get(`${BASE_URL}/rest/products/search?q=${searchKeyword}`, {tags : {type:'search'}});
    check(searchResp , {
            'product search status is 200': (r) => r.status === 200,
            'product search response is not empty' : (r) => r.body.length != 0,
    });
    
    // PERF-AUTH-001
    let loginCredentials = JSON.stringify({
            email : EMAIL,
            password : PASSWORD,
        });
    let headers = {
            'Content-Type' : 'application/json',
        }
    let loginRes = http.post(`${BASE_URL}/rest/user/login`, loginCredentials , {headers, tags : {type:'auth'}});
        check(loginRes , {
            'response status should be 200': (r) => r.status === 200,
        });
    
    const token = loginRes.json('authentication.token');
    const basketId = loginRes.json('authentication.bid');
    
    if(!token || !basketId){
            console.log(`response body : ${loginRes.body}`);
            return;
    }
    
    let authHeaders = {
            'Content-Type' : 'application/json',
            'Authorization' : `Bearer ${token}`,
    }

    // PERF-BASKET-001
    let basketPayload = JSON.stringify({
            ProductId : 21,
            BasketId : basketId,
            quantity : 1,
    });
    let fetchBaketItemRes = http.get(`${BASE_URL}/rest/basket/${JSON.parse(basketPayload).BasketId}`, {headers: authHeaders, tags : {type:'basket'}});
    if(fetchBaketItemRes.status === 200){
        let itemEntryInBasket = fetchBaketItemRes.json().data.Products.find(p => p.id === JSON.parse(basketPayload).ProductId);
        if(itemEntryInBasket != null){
                            let quantity = itemEntryInBasket.BasketItem.quantity;
                            let entryId = itemEntryInBasket.BasketItem.id;
                            if(quantity < 5){
                                quantity = quantity + 1;
                                let putPayload = JSON.stringify({
                                    quantity : quantity,
                                });
                                let updateQuantityRes = http.put(`${BASE_URL}/api/BasketItems/${entryId}`, putPayload , {headers : authHeaders}, {tags : {type:'basket'}});
                                check(updateQuantityRes , {
                                    'Item quantity update request status should be 200 or 201': (r) => r.status === 200 || r.status === 201
                                })
                            }else if(quantity === 5){
                                console.log("You cannot order more than 5 quantities per item !");
                            }
        }else{
                        let basketRes = http.post(`${BASE_URL}/api/BasketItems`, basketPayload, {
                            headers: authHeaders,
                        });
                        if (![200, 201].includes(basketRes.status)) {
                            let retryFetchRes = http.get(`${BASE_URL}/rest/basket/${basketId}`,{headers: authHeaders, tags : {type:'basket'}});

                            let retryItem = retryFetchRes.json().data.Products.find(
                                p => p.id === JSON.parse(basketPayload).ProductId
                            );

                            if (retryItem && retryItem.BasketItem.quantity < 5) {
                                let putPayload = JSON.stringify({
                                    quantity: retryItem.BasketItem.quantity + 1,
                                });

                                basketRes = http.put(
                                    `${BASE_URL}/api/BasketItems/${retryItem.BasketItem.id}`,
                                    putPayload,
                                    { headers: authHeaders }
                                );
                            }
                    }

                    check(basketRes, {
                        'basket item created or updated successfully': (r) =>
                            [200, 201].includes(r.status),
                    });
        }
    }

    //PERF-FEED-001
    let captchaRes = http.get(`${BASE_URL}/rest/captcha`, { headers: authHeaders, tags : {type:'feedback'}});
    if(captchaRes.status === 200){
    
        let feedbackPayload = JSON.stringify({
            captchaId : captchaRes.json('captchaId'),
            captcha : captchaRes.json('answer'),
            comment : "Good Good, very good stuff !",
            rating : 4,
        });
    
        let feedbackRes = http.post(`${BASE_URL}/api/Feedbacks`, feedbackPayload, {headers: authHeaders}, {tags : {type:'feedback'}});
    
        check(feedbackRes, {
            'response status should be 200 or 201': (r) => r.status === 201,
        });
    }

}