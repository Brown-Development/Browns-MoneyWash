fx_version 'bodacious'
author 'Brown Development'
description 'Browns Money Wash'
game 'gta5'
lua54 'yes'
shared_scripts {
    'config/config.lua',
    '@ox_lib/init.lua',
    'code/shared.lua'
}
client_scripts {
    'code/client.lua'
}
server_scripts {
    'code/server.lua'
}
files {
    'html/*.js',
    'html/*.html',
    'html/*.css',
    'html/images/*.png',
    'html/sounds/*.ogg'
}
ui_page 'html/index.html'
dependencies {
    'ox_lib'  
}