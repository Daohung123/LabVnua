const { Buffer } = require('node:buffer');

function encode(data) {
    // Encode to Base64
    const buffer = Buffer.from(data, 'utf8');
    return buffer.toString('base64');
}

function decode(encodedString) {
    const decodedBuffer = Buffer.from(encodedString, 'base64');

    return decodedBuffer.toString('utf8');
}

module.exports = { encode, decode }
