let analysisBtn = document.getElementById("analysisBtn");
let popup = document.getElementById("popup");

analysisBtn.addEventListener("click", openPopup);

function openPopup() {
  console.log("alooo");
  popup.classList.add("open-popup");

  setTimeout(() => {
    popup.classList.remove("open-popup");
  }, 10000); // 5000 milliseconds = 5 seconds
}

function closePopup() {
  popup.classList.remove("open-popup");
}

let user = document.querySelector(".welcome p");

if (localStorage.getItem("username")) {
  user.innerHTML = "Hello, " + localStorage.getItem("username");
}

let logout = document.getElementById("logout");

logout.addEventListener("click", function () {
  localStorage.clear();
  setTimeout(() => {
    window.location = "../Login.html";
  }, 1000);
});

function checkLogin() {
  if (localStorage.getItem("email")) {
  } else {
    alert("You have to be logged in !!");
    window.location = "../Login.html";
  }
}

function checkLogout() {
  if (localStorage.getItem("username")) {
    logout.style.display = "inline";
  } else {
    logout.style.display = "none";
  }
}
checkLogout();
