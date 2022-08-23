// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "./InvoiceChain.sol";

contract InvoiceFactory {
    address[] public deployedInvoices;

    function createInvoice(address _client, string memory _memo, string memory _dateCreated, string memory _dateDue) external {
        require(address(_client) != address(msg.sender));
        address newChain = address(new InvoiceChain(msg.sender, _client, _memo, _dateCreated, _dateDue));
        deployedInvoices.push(newChain);
    }

    function getDeployedInvoices() public view returns (address[] memory) {
        return deployedInvoices;
    }
}
