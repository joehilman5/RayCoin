const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
    return ethers.utils.parseUnits(n.toString(), 'ether')
}

describe('Ray Test', () => {
    it('Passes', async () => {
        const RayCoin = await ethers.getContractFactory('Ray');
        const rayCoin = await RayCoin.deploy();
    });
})