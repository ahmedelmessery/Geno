let user = document.querySelector(".username .username");
let email = document.querySelector(".email .email");
let password = document.querySelector(".password .password");
let re_password = document.querySelector(".re-password");
let register_btn = document.querySelector("#register_btn");

register_btn.addEventListener("click", function () {
  if (
    user.value === "" ||
    email.value === "" ||
    password.value === "" ||
    re_password.value === ""
  ) {
    alert("Please Fill Data");
  } else {
    localStorage.setItem("username", user.value);
    localStorage.setItem("email", email.value);
    localStorage.setItem("password", password.value);
    localStorage.setItem("re-password", re_password.value);
    setTimeout(() => {
      window.location = "login.html";
    }, "1500");
  }
});

let status = true;
const audio = document.querySelector(".audio i");
audio.addEventListener("click", function () {
  if (status == true) {
    const audio_src = document.getElementById("audio");
    audio_src.pause();
    status = false;
    audio.className = "fa-solid fa-volume-xmark";
  } else {
    const audio_src = document.getElementById("audio");
    audio_src.play();
    status = true;
    audio.className = "fa-solid fa-volume-high";
  }
});
