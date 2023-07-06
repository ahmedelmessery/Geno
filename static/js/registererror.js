var EmailError = document.getElementById("email-error");
var UsernameError = document.getElementById("username-error");
var PasswordError = document.getElementById("password-error");
var PasswordConfirmationError = document.getElementById("Rpassword-error");

function ValidateEmail() {
  var email = document.getElementById("id_email").value;

  if (email.length == 0) {
    EmailError.innerHTML = "Email is required";
    return false;
  }

  if (
    !email.match(
      /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
    )
  ) {
    EmailError.innerHTML = "Email Invalid";
    return false;
  }

  EmailError.innerHTML = `<i class="fa-sharp fa-solid fa-circle-check"></i>`;
  return true;
}

function ValidateUsername() {
  var username = document.getElementById("id_username").value;

  if (username.length == 0) {
    UsernameError.innerHTML = "Username is required";
    return false;
  }

  UsernameError.innerHTML = `<i class="fa-sharp fa-solid fa-circle-check"></i>`;
  return true;
}

function ValidatePassword() {
  var pw = document.getElementById("id_password1").value;

  if (pw == "") {
    PasswordError.innerHTML = "Password is required";
    return false;
  }

  //minimum password length validation
  if (pw.length < 8) {
    PasswordError.innerHTML = "Easy password";
    return false;
  }

  //maximum length of password validation
  if (pw.length > 15) {
    PasswordError.innerHTML = "Password must not exceed 15 characters";
    return false;
  }
  PasswordError.innerHTML = `<i class="fa-sharp fa-solid fa-circle-check"></i>`;
  return true;
}

function ValidatePasswordConfirmation() {
  var pw2 = document.getElementById("id_password2").value;

  var pw = document.getElementById("id_password1").value;

  if (pw != pw2) {
    PasswordConfirmationError.innerHTML = "Passwords are not same";
    return false;
  } else if (pw === pw2) {
    PasswordConfirmationError.innerHTML = `<i class="fa-sharp fa-solid fa-circle-check"></i>`;
    return true;
  }
}

function check() {
  var span = document.getElementById("fix");
  if (
    !ValidateEmail() ||
    !ValidateUsername() ||
    !ValidatePassword() ||
    !ValidatePasswordConfirmation()
  ) {
    fix.style.display = "block";
    fix.innerHTML = "Please Enter All Fields";
    setTimeout(function () {
      fix.style.display = "none";
    }, 3000);
    return false;
  }
}
