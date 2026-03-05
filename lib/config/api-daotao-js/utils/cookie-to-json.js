function cookieToJson(cookieString) {
	if (!cookieString) return {};
	const jsonCookies = [];

	const cookies = cookieString.split(", ");
    cookies.forEach(cookie => {
        const cookieObj = {};

        const cookieParts = cookie.split("; ");
        cookieParts.forEach((part) => {
		    const trimmedCookie = part.trim();
		    if (!trimmedCookie) return; // Skip empty strings

		    // Separate key and value (handling cases where the value contains an equal sign).
		    const equalIndex = trimmedCookie.indexOf("=");
		    let key, value;

            if (equalIndex === -1) {
                return
            }
		    key = trimmedCookie.slice(0, equalIndex);
		    value = trimmedCookie.slice(equalIndex + 1);
		    try {
			    cookieObj[key.trim()] = decodeURIComponent(value);
		    } catch (e) {
			    cookieObj[key.trim()] = value;
		    }
	    });
        jsonCookies.push(cookieObj);
    })

	return jsonCookies;
}

module.exports = cookieToJson;
