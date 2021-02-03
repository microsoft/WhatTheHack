// Select DOM elements to work with
const welcomeDiv = document.getElementById("welcomeMessage");
const signInButton = document.getElementById("signIn");
const signOutButton = document.getElementById('signOut');
const cardDiv = document.getElementById("card-div");

export default function showWelcomeMessage(account) {

    // Reconfiguring DOM elements
    cardDiv.classList.remove('d-none');
    welcomeDiv.innerHTML = `Welcome ${account.name}`;
    signInButton.classList.add('d-none');
    signOutButton.classList.remove('d-none');
}


