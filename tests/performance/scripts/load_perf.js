import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';
const searchKeyword = __ENV.SEARCH_KEYWORD || 'juice';
const EMAIL = __ENV.EMAIL;
const PASSWORD = __ENV.PASSWORD;

export const options = {
    vus: 15,
    duration: '30s',
    thresholds : {
        http_req_failed : ['rate<0.05'],
        http_req_duration : ['p(95)<1000'],
    }
};

export default function(){
    // PERF-PROD-001
    let searchResp = http.get(`${BASE_URL}/rest/products/search?q=${searchKeyword}`);
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
    let loginRes = http.post(`${BASE_URL}/rest/user/login`, loginCredentials , {headers});
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
            ProductId : 8,
            BasketId : basketId,
            quantity : 1,
    });
    let fetchBaketItemRes = http.get(`${BASE_URL}/rest/basket/${JSON.parse(basketPayload).BasketId}`, {headers: authHeaders});
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
                                let updateQuantityRes = http.put(`${BASE_URL}/api/BasketItems/${entryId}`, putPayload, {headers : authHeaders});
                                check(updateQuantityRes , {
                                    'Item quantity update request status should be 200 or 201': (r) => r.status === 200 || r.status === 201
                                })
                            }else if(quantity === 5){
                                console.log("You cannot order more than 5 quantities per item !");
                            }
        }else{
                        let basketRes = http.post(`${BASE_URL}/api/BasketItems`, basketPayload, {headers: authHeaders,});
                        check(basketRes , {
                        'response status should either be 200 or 201': (r) => r.status === 200 || r.status === 201
                        });
        }
    }

    //PERF-FEED-001
    let captchaRes = http.get(`${BASE_URL}/rest/captcha`, {headers: authHeaders});
    if(captchaRes.status === 200){
    
        let feedbackPayload = JSON.stringify({
            captchaId : captchaRes.json('captchaId'),
            captcha : captchaRes.json('answer'),
            comment : "Good Good, very good stuff !",
            rating : 4,
        });
    
        let feedbackRes = http.post(`${BASE_URL}/api/Feedbacks`, feedbackPayload, {headers: authHeaders});
    
        check(feedbackRes, {
            'response status should be 200 or 201': (r) => r.status === 201,
        });
    }

}