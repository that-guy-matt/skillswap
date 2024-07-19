document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('login-form').addEventListener('submit', async function(event) {
        event.preventDefault();

        const email = document.getElementById('email-input').value;
        const password = document.getElementById('password-input').value;

        try {
            // send POST request to /login endpoint with email and password
            const response = await fetch('/login', {
                method: 'POST', 
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({email, password})
            });

            // parse JSON response
            const result = await response.json();

            // check if response status ok
            if (response.ok) {
                // store token in local storage
                localStorage.setItem('token', result.token);
                console.log("Token: ", result.token);
                document.getElementById('login-message').innerText = `Logged in as: ${result.message}`;
                console.log("Login successful!");
            } else {
                document.getElementById('login-message').innerText = 'Login failed';
                console.log("Login failed");
            }
        } catch (e) {
            console.log("An error has occurred.")
            console.error('Error: ', e);
            document.getElementById('login-message').innerText = 'An error hass occurred.';
        }
    });
});