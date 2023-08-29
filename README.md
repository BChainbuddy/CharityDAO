<h1>CHARITY FUNDING DAO</h1>

This project helps the charities get the funding with little to no intermediate cost. The DAO can choose which charities can join the fund and can decide how much money they can take from it. The fund gets the money from minting the token contract(function sendFunds). The token is though worthless and is there just for voting power.

<h2>How to deploy</h2>
- yarn hardhat deploy

<h2>How to test if DAO is working correctly</h2>
<ol>
  <li>yarn hardhat node // to start the hardhat blockchain</li>
  <li>yarn hardhat run scripts/newpropose.js // makes a proposal to add a charity to DAO fund</li>
  <li>yarn hardhat run scripts/vote.js // executes a vote</li>
  <li>yarn hardhat run scripts/queue-and-execute.js // queues and executes the proposal</li>
</ol>
