console.log('Starting login request...');
const https = require('https');

const data = JSON.stringify({
    username: 'admin',
    password: 'admin'
});

const options = {
    hostname: 'adinathnagar-primary-school-app-v0.vercel.app',
    port: 443,
    path: '/api/login',
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'Content-Length': data.length
    }
};

const req = https.request(options, (res) => {
    console.log(`statusCode: ${res.statusCode}`);

    res.on('data', (d) => {
        process.stdout.write(d);
        console.log('\nResponse:', d.toString());
    });
});

req.on('error', (error) => {
    console.error(error);
});

req.write(data);
req.end();
