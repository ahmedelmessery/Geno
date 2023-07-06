const gif = document.querySelector(".gif img");
const popup = document.getElementById("myPopup");
const btn = document.querySelector("btn");

btn.addEventListener("click", function (e) {
  e.preventDefault();

  // Show the loading gif
  gif.style.display = "block";

  const form = document.querySelector("form");

  // Submit the form
  form.submit();

  // Hide the loading gif after a short delay
  setTimeout(function () {
    gif.style.display = "none";
    // Show the popup
    popup.style.display = "block";
    popup.classList.add("slide-in");
  }, 2000);
});
