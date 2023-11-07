document.addEventListener('DOMContentLoaded', function () {

    $('#main').hide()

    const container = document.getElementById('container')
    const inputs = document.getElementById('moneyinput')
    const washButton = document.getElementById('washbutton')
    const washed = document.getElementById('washed')
    const takeButton = document.getElementById('takebutton')
    const exitButton = document.getElementById('exit')
    const moneyAmount = document.getElementById('amount')

    document.getElementById('exit').innerHTML = 'X'
    document.getElementById('washbutton').innerHTML = 'Wash'
    document.getElementById('helper').innerHTML = 'Enter Amount to wash'
    document.getElementById('takebutton').innerHTML = 'Take Money'

    let canTake = null;
    let markedmoney = false;

    function OpenUI(marked) {
        if (!marked) {
            document.getElementById('washbutton').innerHTML = 'Wash'
            document.getElementById('washbutton').style.top = '60%'
            moneyAmount.style.top = '30%'
            $('#main').show();
            $('#wash').show();
            $('#take').hide();
            $('#moneyinput').show();
            $('#helper').show();
        } else {
            document.getElementById('washbutton').innerHTML = 'Wash All' 
            document.getElementById('washbutton').style.top = '50%'
            moneyAmount.style.top = '40%'
            $('#main').show();
            $('#wash').show();
            $('#take').hide();
            $('#moneyinput').hide();
            $('#helper').hide();
        }

    };

    function ShowTake() {
        $('#take').show();
        $('#wash').hide();
    };

    function WashMoney() {
        container.style.animation = 'slide-down 1s forwards';
        var wash = new Howl({
            src: ["./sounds/wash.ogg"],
            loop: false,
            volume: 1.0
        });
        var ring = new Howl({
            src: ["./sounds/bell.ogg"],
            loop: false,
            volume: 1.0
        });
        wash.play();
        setTimeout(() => {
            $('#main').hide();
            container.style.animation = 'slide-up 1s forwards';
            $('#main').show();
            $('#exit').hide();
            ShowTake();
            ring.play();
        }, 3000);
    };

    function ToggleFocus(bool) {
        $.post('http://Browns-MoneyWash/FocusToggle', JSON.stringify({
            toggle: bool
        }))
    }
    
    washButton.addEventListener('click', function () {
        if (!markedmoney) {
            $.post('http://Browns-MoneyWash/WashMoney', JSON.stringify({
                amount: inputs.value
            }))
        } else {
            $.post('http://Browns-MoneyWash/WashMoney', JSON.stringify({
                amount: parseInt(moneyAmount.innerHTML.slice(17))
            }))
        }
    });

    exitButton.addEventListener('click', function () {
        container.style.animation = 'slide-down 1s forwards'
        setTimeout(() => {
            $('#main').hide()
            ToggleFocus(false)
            container.style.animation = 'slide-up 1s forwards'
            washed.innerHTML = ''
            canTake = null
            moneyAmount.innerHTML = ''
        }, 500);
    });

    takeButton.addEventListener('click', function () {
        ToggleFocus(false)
        $.post('http://Browns-MoneyWash/TakeMoney', JSON.stringify({
            money: canTake
        }))
        container.style.animation = 'slide-down 1s forwards'
        setTimeout(() => {
            $('#exit').show()
            $('#main').hide()
            container.style.animation = 'slide-up 1s forwards'
            washed.innerHTML = ''
            moneyAmount.innerHTML = ''
            canTake = null
        }, 500);
    });

    window.addEventListener('message', function(event) {
        var message = event.data
        if (message.start === 'MoneyWash') {
            WashMoney()
            washed.innerHTML = message.washed
            canTake = message.take
        }
    });

    window.addEventListener('message', function(event) {
        var message = event.data
        if (message.start === 'UI') {
            ToggleFocus(true)
            OpenUI(message.marked)
            inputs.value = ''
            moneyAmount.innerHTML = message.text
            markedmoney = message.marked
        }
    });

});
