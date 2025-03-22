fx_version "cerulean"
games { "gta5" }

lua54 'yes'

description "Rewritten version of XYZ Spawn By MoneSuper"
author "DaemonAlex"
version '1.0.0'

ui_page 'web/build/index.html'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    "client/**/*"
}

server_scripts {
    "server/**/*",
    '@oxmysql/lib/MySQL.lua'
}

files {
    'web/build/index.html',
    'web/build/**/*',
    'locales/en.json'
}

-- Uncomment this if using escrow protection
-- escrow_ignore {
--     'shared/shared.lua',
--     'locales/en.json'
-- }
