const { Alchemy, Network } = require("alchemy-sdk")
const dotenv = require("dotenv")
dotenv.config()

const config = {
    apiKey: process.env.ALCHEMY_API_KEY,
    network: Network.ETH_MAINNET,
};
const alchemy = new Alchemy(config);

const main = async () => {
    // Wallet address
    // const address = "0xd6a984153aCB6c9E2d788f08C2465a1358BB89A7";
    const address = "0x901DD05689A77FFCbCc53Bb7d60113EC3B2EA6f6"

    // Get all NFTs (100 latest nfts)
    const nfts = await alchemy.nft.getNftsForOwner(address);

    // Parse output
    const numNfts = nfts["totalCount"];
    const nftList = nfts["ownedNfts"];

    console.log(`Total NFTs owned by ${address}: ${numNfts} \n`);

    let i = 1;

    for (let nft of nftList) {
        if (!nft.title) continue;
        const nftPricing = await alchemy.nft.getFloorPrice(nft.contract.address);
        if (nftPricing.openSea && nftPricing.openSea.floorPrice) {
            console.log(`${i}. ${nft.title} - ${nftPricing.openSea.floorPrice} ${nftPricing.openSea.priceCurrency}`);
        } else {
            console.log(`${i}. ${nft.title}`)
        }
        // contract address
        console.log(`Contract Address: ${nft.contract.address}`)
        // token id
        console.log(`Token Id: ${nft.tokenId}`)
        // image is in nft.rawMetadata.image or nft.media[0].gateway
        console.log(ipfsToLink(nft.rawMetadata.image))
        i++;
    }
};

const ipfsToLink = (imageUrl) => {
    if (!imageUrl) return imageUrl
    if (!imageUrl.startsWith("ipfs://")) {
        return imageUrl
    }
    return "https://ipfs.io/ipfs/" + imageUrl.substring(7);
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();