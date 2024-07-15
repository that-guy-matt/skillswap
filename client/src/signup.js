document.addEventListener("DOMContentLoaded", function() {
    document.getElementById('signup-form').addEventListener('submit', async function(event){
        
        // prevents the default form submission behavior
        event.preventDefault();

        // retrieve values of email and password input fields
        const email = document.getElementById('email-input').value;
        const password = document.getElementById('password-input').value;
    
        try {

            // send POST request to the /signup endpoint with email and password
            const response = await fetch('/signup', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({email, password}),
            });
            
            // parse JSON response
            const result = await response.json();

            // check response
            if(response.ok) {
                alert('Signup Successful');
            } else {
                alert('Signup failed: ${result.error');
            }
        } catch (e) {
            
            // error logging if present
            console.error('Error: ', e);
            alert('An error occurred during signup.');
        }
    });
});

