import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000';
const EMAIL = __ENV.EMAIL || 'customer1@gmail.com';
const PASSWORD = __ENV.PASSWORD;

export const options = {
    vus: 1,
    iterations: 1,
    duration: '30s',
    thresholds : {
        http_req_failed : ['rate<0.05'],
        http_req_duration : ['p(95)<1000']
    },
};

export default function(){
    //PERF-SMOKE-001
    let searchResp = http.get(`${BASE_URL}/rest/products/search?q=apple`);
    check(searchResp , {
        'product search status is 200': (r) => r.status === 200,
        'product search response is not empty' : (r) => r.body.length != 0,
    });

    //PERF-SMOKE-002
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

    //PERF-SMOKE-003
    let basketPayload = JSON.stringify({
        ProductId : 4,
        BasketId : basketId,
        quantity : 1,
    });
    let basketRes = http.post(`${BASE_URL}/api/BasketItems`, basketPayload, {headers: authHeaders,});
    check(basketRes , {
        'response status should either be 200 or 201': (r) => r.status === 200 || r.status === 201
    });

     //PERF-SMOKE-004
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