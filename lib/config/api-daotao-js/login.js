const queryString = require('node:querystring');
const cookiesToJSON = require('./utils/cookie-to-json');
const { encode, decode } = require("./utils/base64");

async function login(username, password) {
    const loginData = encode(JSON.stringify({
        username, password,
        "uri": "https://daotao.vnua.edu.vn/#/home"
    })).replace("=", "%3D");

    const loginUrl = `https://daotao.vnua.edu.vn/api/pn-signin?code=${loginData}&gopage=&mgr=1`;

    try {
        const authResp = await fetch('https://daotao.vnua.edu.vn/api/auth/authconfig');
        const aspnet_cookie = authResp.headers.get('set-cookie');
        // console.log(aspnet_cookie);        
        const ASPNET_SessionId = cookiesToJSON(aspnet_cookie)[0]['ASP.NET_SessionId'];
        
        const response = await fetch(loginUrl, { headers: {cookie: aspnet_cookie}, redirect: 'manual' });
       
        const queryData = response.headers.get('location').split('?')[1];
        // console.log('Query Data: ', queryData);
        
        const cookie = response.headers.get('set-cookie');
        // console.log(cookie);
        
        const cookiesJSON = cookiesToJSON(cookie);
        // console.log(cookiesToJSON(cookie));
        // console.log(`${cookie}; ${aspnet_cookie}`);
       
        const cookies = `ASP.NET_SessionId=${ASPNET_SessionId}; xsrf-ctrl=${cookiesJSON[0]['xsrf-ctrl']}; xsrf-sec=${cookiesJSON[1]['xsrf-sec']}; xsrf-repl=0`
        // console.log(cookies);
        
        const userData = queryString.decode(queryData);
        // console.log(userData);       
        
        const currUser = JSON.parse(decode(userData.CurrUser));

        // console.log('Token: ', currUser.access_token);        
        // console.log('Cookies:', cookies);
        return { access_token: currUser.access_token, cookie: cookies};
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}

// login('6651995', "Hung10.10");
module.exports = login;
