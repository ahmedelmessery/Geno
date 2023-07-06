let email = document.querySelector('.email .email')
let password = document.querySelector('.password .password')
let login_btn = document.querySelector('.login_botton .btn')

login_btn.addEventListener('click', function(){
    if(email.value === '' || password.value === ''){
        alert('Please Fill Data')
    } else if (email.value === localStorage.getItem('email') && password.value === localStorage.getItem('password')) {
        setTimeout (() => {
            window.location = '../Home.html'
        }, 1000)
        var name = document.querySelector('.container .welcome p');
        name.innerHTML = 'Welcome ' + localStorage.getItem('username');

    } else if (email.value != localStorage.getItem('email') || password.value != localStorage.getItem('password')){
        alert ('Data is Wrong !! Please check your email or password')
    }

})


let status = true;
const audio = document.querySelector('.audio i')
audio.addEventListener('click', function () {
    if (status == true) {
        const audio_src = document.getElementById('audio')
        audio_src.pause();
        status = false;
        audio.className = 'fa-solid fa-volume-xmark'
    }

    else {
        const audio_src = document.getElementById('audio')
        audio_src.play();
        status = true;
        audio.className = 'fa-solid fa-volume-high'
    }
}
);



const PassBtn = document.getElementById('eye');
PassBtn.addEventListener('click', () => {
    const input = document.querySelector('.password input');
    input.getAttribute('type') === 'password' ? input.setAttribute('type', 'text') : input.setAttribute('type', 'password');

   if (input.getAttribute('type') === 'text'){
     PassBtn.className = 'fa fa-eye-slash';
  } else{
     PassBtn.className = 'fa-regular fa-eye';
  }

});