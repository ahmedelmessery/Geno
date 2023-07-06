
function check() {
    var error = "", field = "";

    field = document.getElementById("id_username");
    if (!field.checkValidity()) {
        error += "Wrong Username";
    }

    field = document.getElementById("id_password");
    if (!field.checkValidity()) {
        error += "Wrong Password";
    }

    if (error == "") { return true; }
    else {
        alert(error);
        return false;
    }
}
