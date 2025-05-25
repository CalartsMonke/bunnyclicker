local assets =
{
    images =
    {
        titlelogo = love.graphics.newImage('/img/titlelogo.png/'),
        bunnycursor = love.graphics.newImage('/img/cursor.png/'),
        star = love.graphics.newImage('/img/star.png/'),
        sword_resume = love.graphics.newImage('/img/idlesword.png/'),
        hudCoin = love.graphics.newImage('/img/hudCoin.png/'),
        coinSpin = love.graphics.newImage('/img/coinSpin.png/'),
        coinBag = love.graphics.newImage('/img/moneybag.png/'),
        heartDrop = love.graphics.newImage('/img/heartDrop.png/'),
        enemy1 = love.graphics.newImage('/img/laenemy.png/'),
        enemy2 = love.graphics.newImage('/img/laenemy2.png/'),
        assualtGun = love.graphics.newImage('/img/AssGun.png/'),

        slash1 = love.graphics.newImage('/img/slash1.png/'),
        bossKey = love.graphics.newImage('/img/bossKey.png/'),
        keyIcon = love.graphics.newImage('/img/keyIcon.png/'),
        keyIconDotted = love.graphics.newImage('/img/keyIconDotted.png/'),
        blueRoomSquare = love.graphics.newImage('/img/blueRoomSquare.png/'),
        grayRoomSquare = love.graphics.newImage('/img/grayRoomSquare.png/'),
        shopRoomSquare = love.graphics.newImage('/img/shopRoomSquare.png/'),
        bossRoomSquare = love.graphics.newImage('/img/bossRoomSquare.png/'),

    },

    sounds =
    {

    },

    music = 
    {
        boss1 = love.audio.newSource('/aud/eggmanfight.mp3/', 'stream'),
        boss2 = love.audio.newSource('/aud/jojomusic.mp3/', 'stream'),
    },




}

return assets