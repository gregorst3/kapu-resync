


#!/bin/bash
#
# Rebuild using top 5 peers
#
configfile='config.mainnet.json'
SRV="http://127.0.0.1:9700"
function SyncPeers()
{
        echo "Backing up config file (if necessary)"
        if [ ! -f "$configfile-original" ]; then
                cp $configfile "$configfile-original"
        fi

        echo Getting top 5 peers
        PEERS=$(curl -s "http://127.0.0.1:9700//api/peers" | jq '[.peers[]]' | jq 'sort_by(-.height)' | jq '.[] |= del(.status,.os,.version,.errors,.broadhash,.clock,.delay,.nonce,.height) ' | jq '[limit(5;.[])]')
        echo Modifying config file
        jq ".peers.list = $PEERS" "$configfile-original" > config.mainnet.json

}

function Rebuild()
{
        echo Rebuilding
        cd ~/kapu-node
        rm kapu_db.snapshot_main.tar
		wget http://www.kapu.one/current/kapu_db.snapshot_main.tar 
		forever stop app.js
		killall node
		sudo pkill -u postgres
		sudo /etc/init.d/postgresql restart
		sudo -u postgres dropdb --if-exists kapu_mainnet 
		sudo -u postgres createdb kapu_mainnet
		pg_restore -O -j 8 -d kapu_mainnet kapu_db.snapshot_main.tar 2>/dev/null
		forever start app.js --genesis genesisBlock.mainnet.json --config config.mainnet.json
		rm kapu_db.snapshot_main.tar
        echo Sleeping 30 sec...
        sleep 30
        

        echo Waiting for rebuild to complete...
        SYNC=$(curl -s "$SRV/api/loader/status/sync"| jq '.syncing')
        while [[ -z $SYNC || $SYNC != 'false' ]]
        do
                SYNC=$(curl -s "$SRV/api/loader/status/sync"| jq '.syncing')
                sleep 2
        done
}

function RestoreConfig()
{
        echo Restoring original config file
        cp "$configfile-original" config.mainnet.json
        forever restart app.js
}

SyncPeers
Rebuild
RestoreConfig
