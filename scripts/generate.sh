CUR_DIR=$1

cd $CUR_DIR
rm -rf channel-artifacts crypto-config
mkdir channel-artifacts

/root/bin/cryptogen generate --config=${CUR_DIR}/crypto-config.yaml

export FABRIC_CFG_PATH=$CUR_DIR
/root/bin/configtxgen -profile KafkaOrdererGenesis -channelID byfn-sys-channel -outputBlock ${CUR_DIR}/channel-artifacts/genesis.block

export CHANNEL_NAME=mychannel
/root/bin/configtxgen -profile MyChannel -outputCreateChannelTx ${CUR_DIR}/channel-artifacts/${CHANNEL_NAME}_channel.tx -channelID $CHANNEL_NAME
/root/bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ${CUR_DIR}/channel-artifacts/${CHANNEL_NAME}_Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
/root/bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ${CUR_DIR}/channel-artifacts/${CHANNEL_NAME}_Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
/root/bin/configtxgen -profile MyChannel -outputAnchorPeersUpdate ${CUR_DIR}/channel-artifacts/${CHANNEL_NAME}_Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP