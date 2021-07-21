import React, { Component } from "react"
import Web3 from "web3"
import { Tabs, Tab } from "react-bootstrap"

import dBank from "../abis/dBank.json"
import Token from "../abis/Token.json"
import dbank from "../dbank.png"

import "./App.css"

//h0m3w0rk - add new tab to check accrued interest

class App extends Component {
	async componentDidMount() {
		await this.loadBlockchainData(this.props.dispatch)
	}

	constructor(props) {
		super(props)

		this.state = {
			web3: "undefined",
			account: "",
			token: null,
			dbank: null,
			balance: 0,
			dBankAddress: null,
			tokenAddress: null,
			networkId: null,
		}
	}

	// Check if ethereum is enabled. If not, enable ethereum on the website.
	isETHEnabled = () => {
		if (window.web3) {
			window.web3 = new Web3(window.web3.currentProvider)
			window.ethereum.enable()
			return true
		}

		return false
	}

	async loadBlockchainData(dispatch) {
		if (!this.isETHEnabled()) {
			return window?.alert("Please enable MetaMask")
		}

		//assign to values to variables: web3, netId, accounts
		const web3 = new Web3(window.ethereum)
		const networkId = await web3.eth.net.getId()
		const accounts = await web3.eth.getAccounts()

		//check if account is detected, then load balance & setStates, else push alert
		if (accounts?.length <= 0) return window?.alert("No accounts found")

		const accountBalance = await web3.eth.getBalance(accounts[0])
		this.setState({
			account: accounts[0],
			balance: accountBalance,
			web3,
			networkId,
		})

		try {
			// Add token and dbank contracts to the app.
			const tokenAddress = Token?.networks[networkId]?.address
			const dBankAddress = dBank?.networks[networkId]?.address

			const token = new web3.eth.Contract(Token?.abi, tokenAddress)
			const dbank = new web3.eth.Contract(dBank?.abi, dBankAddress)

			this.setState({
				account: accounts[0],
				balance: accountBalance,
				web3,
				networkId,
				tokenAddress,
				dBankAddress,
			})

			console.log({
				web3,
				networkId,
				accounts,
				accountBalance,
				token,
				dbank,
				tokenAddress,
				dBankAddress,
			})
		} catch (error) {
			console.log(error)
			window.alert("Contracts not deployed to the current network.")
		}

		//in try block load contracts
		//if MetaMask not exists push alert
	}

	async deposit(amount) {
		//check if this.state.dbank is ok
		//in try block call dBank deposit();
	}

	async withdraw(e) {
		//prevent button from default click
		//check if this.state.dbank is ok
		//in try block call dBank withdraw();
	}

	render() {
		return (
			<div className="text-monospace">
				<nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
					<a
						className="navbar-brand col-sm-3 col-md-2 mr-0"
						href="http://www.dappuniversity.com/bootcamp"
						target="_blank"
						rel="noopener noreferrer"
					>
						<img
							src={dbank}
							className="App-logo"
							alt="logo"
							height="32"
						/>
						<b>dBank</b>
					</a>
				</nav>

				<div className="container-fluid mt-5 text-center">
					<br></br>
					<h1>Welcome to dBank</h1>
					<h2>{this.state.account}</h2>
					<br></br>
					<div className="row">
						<main role="main" className="col-lg-12 d-flex text-center">
							<div className="content mr-auto ml-auto">
								<Tabs
									defaultActiveKey="deposit"
									id="uncontrolled-tab-example"
								>
									<Tab eventKey="deposit" title="Deposit">
										<div>
											<br></br>
											How much do you want to deposit?
										</div>
									</Tab>

									<Tab eventKey="withdraw" title="Withdraw">
										<div>
											<br></br>
											How much do you want to withdraw?
										</div>
									</Tab>
									{/*add Tab withdraw*/}
								</Tabs>
							</div>
						</main>
					</div>
				</div>
			</div>
		)
	}
}

export default App
