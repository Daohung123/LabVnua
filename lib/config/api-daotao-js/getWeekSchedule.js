const login = require('./login');

/// Lấy thời khóa biểu theo tuần
async function getWeekSchedule(username, password, hocKy) {
    const { access_token, cookie } = await login(username, password);

    const response = await fetch('https://daotao.vnua.edu.vn/api/sch/w-locdstkbhockytheodoituong', {
        method: 'POST',
        headers: {
            "Authorization": `Bearer ${access_token}`,
            "Content-Type": 'application/json',
            "Cookie": cookie,
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
        },
        body: JSON.stringify({"hoc_ky":hocKy,"loai_doi_tuong":1,"id_du_lieu":null})
    })

    if (!response.ok) {
        // console.log(response);
        const data = await response.json();
        // console.log("Error Status: ", response.status);
        // console.log("Error Data:", data);

        throw new Error(`HTTP error! status: ${response.status}`);
    } else {
        const data = await response.json();
        console.log(data);

        return data;
    }
}

getWeekSchedule('6651995', "Hung10.10", 20251);

module.exports = getWeekSchedule;
