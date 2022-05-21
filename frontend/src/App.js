import { useEffect, useState } from 'react';
import './App.css';
import HedgeHog from "./contracts/HedgeHog.json";
import { ethers } from 'ethers';

const hhAddress = "0x5133bbdfcca3eb4f739d599ee4ec45cbcd0e16c5";
const abi = {
  abi: [
    "function depositThenRecieveCredsAndCredit(uint256 amount) external"
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


        const hhTx = await hhContract.depositThenRecieveCredsAndCredit(ethers.utils.parseUnits("0.5", 18), {
          gasLimit: 100000,
        });
        //dynamically pull the contents from the local blockchain
        //and call the functions and display the results
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
