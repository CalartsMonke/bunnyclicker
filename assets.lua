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
        dagger1 = love.graphics.newImage('/img/dagger1.png/'),
        assualtGun = love.graphics.newImage('/img/AssGun.png/'),
        goldGun = love.graphics.newImage('/img/goldGun.png/'),
        brokenBottle = love.graphics.newImage('/img/brokenBottle.png/'),
        brownBrick = love.graphics.newImage('/img/brownbrick.png/'),

        slash1 = love.graphics.newImage('/img/slash1.png/'),
        bossKey = love.graphics.newImage('/img/bossKey.png/'),
        keyIcon = love.graphics.newImage('/img/keyIcon.png/'),
        keyIconDotted = love.graphics.newImage('/img/keyIconDotted.png/'),
        blueRoomSquare = love.graphics.newImage('/img/blueRoomSquare.png/'),
        grayRoomSquare = love.graphics.newImage('/img/grayRoomSquare.png/'),
        shopRoomSquare = love.graphics.newImage('/img/shopRoomSquare.png/'),
        bossRoomSquare = love.graphics.newImage('/img/bossRoomSquare.png/'),

        hud =
        {
            itemFrame = love.graphics.newImage('/img/hud/itemBox.png'),
            activePaper = love.graphics.newImage('/img/hud/activePaper.png/'),
            consumablePaper = love.graphics.newImage('/img/hud/consumablePaper.png/'),
            progressBar = love.graphics.newImage('/img/hud/progressBar.png'),

            barTarget = love.graphics.newImage('img/hud/barTarget.png'),

            shopkeeper =
            {
                idle1 = love.graphics.newImage('img/hud/shopkeeper_idle1.png'),
                talk = love.graphics.newImage('img/hud/shopkeeper_talk.png'),
            },
        },

        projectiles =
        {
            brownBrick = love.graphics.newImage('/img/projectiles/proj_brownBrick.png/'),
        },

        items = 
        {
            ironpan = love.graphics.newImage("img/items/ironpan.png")
        },

        backgrounds = 
        {
            dungeon =
            {
                backalley1 = love.graphics.newImage('/img/backgrounds/dungeonbackdrops/backdrop_dungeon_backalley1.png'),
            },

            rooms = 
            {
                backalley =
                {
                    backalley1 = love.graphics.newImage('/img/backgrounds/backalleybackdrops/backdrop_room_backalley1.png/'),
                },
            },
        },

        enemies =
        {
            dasherBun =
            {
                dasherbun_dash = love.graphics.newImage('/img/enemies/dasherbun/dasherbun_dash.png/'),
                dasherbun_idle = love.graphics.newImage('/img/enemies/dasherbun/dasherbun_idle.png/'),
            },
            
            hopperBun = 
            {
                hopperbun_idle = love.graphics.newImage('/img/enemies/bunhopper/bunhopper_idle.png/'),
                hopperbun_hopping = love.graphics.newImage('/img/enemies/bunhopper/bunhopper_hopping.png/'),
                hopperbun_resting = love.graphics.newImage('/img/enemies/bunhopper/bunhopper_resting.png/'),
            },

            talkerBun =
            {
                talkerbun_idle = love.graphics.newImage('img/enemies/talkerbun/talkerbun_idle.png')
            },
        },

    },

    sounds =
    {
        bottlesmash1 = love.audio.newSource('/aud/bottlesmash1.mp3/', 'static'),
        bottlesmash2 = love.audio.newSource('/aud/bottlesmash2.mp3/', 'static'),
        gunshot1 = love.audio.newSource('/aud/gunshot1.mp3/', 'static'),
        gunshot2 = love.audio.newSource('/aud/gunshot2.mp3/', 'static'),
        slash1 = love.audio.newSource('/aud/slash1.mp3/', 'static'),
        slash2 = love.audio.newSource('/aud/slash2.mp3/', 'static'),
        squeak1 = love.audio.newSource('/aud/mousesqueak1.mp3/', 'static'),
        squeak2 = love.audio.newSource('/aud/mousesqueak2.mp3/', 'static'),
        panaim = love.audio.newSource('aud/hitmark.mp3', 'static'),
        panhit = love.audio.newSource('aud/fryingpan.mp3/', 'static'),
        pancrit = love.audio.newSource('aud/pancrit.wav/', 'static'),
        text1 = love.audio.newSource('aud/text1.wav/', 'static')


    },

    music = 
    {
        boss1 = love.audio.newSource('/aud/eggmanfight.mp3/', 'stream'),
        boss2 = love.audio.newSource('/aud/jojomusic.mp3/', 'stream'),
    },

    fonts =
    {
        ns13 = love.graphics.newFont('/fonts/NotoSans-VariableFont_wdth,wght.ttf/', 13, 'mono'),
        dd16 = love.graphics.newFont('/fonts/Dank-Depths.ttf/', 16, 'mono'),
    }




}

return assets