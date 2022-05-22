import { useEffect, useState } from 'react';
import './App.css';
import HedgeHog from "./contracts/HedgeHog.json";
import { ethers } from 'ethers';

const hhAddress = "0x12bcb546bc60ff39f1adfc7ce4605d5bd6a6a876";
const abi = {
  abi: [
    "function depositThenRecieveCredsAndCredit() external payable"
  ],
};

function App() {

  const [currentAccount, setCurrentAccount] = useState(null);

  const checkWalletIsConnected = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have Metamask installed!");
      return;
    } else {
      console.log("Wallet exists! We're ready to go!")
    }

    const accounts = await ethereum.request({ method: 'eth_accounts' });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account: ", account);
      setCurrentAccount(account);
    } else {
      console.log("No authorized account found");
    }
  }

  const connectWalletHandler = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      alert("Please install Metamask!");
    }

    try {
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      console.log("Found an account! Address: ", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (err) {
      console.log(err)
    }
  }

  const createCredit = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.JsonRpcProvider();
        const signer = provider.getSigner();
        const hhContract = new ethers.Contract(hhAddress, abi.abi, signer);



        const hhTx = await hhContract.depositThenRecieveCredsAndCredit(ethers.utils.formatUnits("0.1", 18), { gasLimit: 100000 });

        console.log("Mining... please wait");
        await hhTx.wait();

      } else {
        console.log("Ethereum object does not exist");
      }
    } catch (err) {
      console.log(err);
    }

  }

  const connectWalletButton = () => {
    return (
      <button onClick={connectWalletHandler} className='cta-button connect-wallet-button'>
        Connect Wallet
      </button>
    )
  }

  const createCreditButton = () => {
    return (
      <button onClick={createCredit} className='cta-button create-credit-button'>
        Create Credit
      </button>
    )
  }

  useEffect(() => {
    checkWalletIsConnected();
  }, [])

  return (
    <div className='main-app'>
      <h1>HedgeHog</h1>
      <input type="text" id="candidate" />
      <div>
        {currentAccount ? createCreditButton() : connectWalletButton()}
      </div>
    </div>
  )
}
export default App;
