// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract InvoiceChain {

    enum Status {
        PENDING,
        PAID,
        DECLINED
    }

    struct Item {
        uint256 id;
        string service;
        string activity;
        uint amount;
    }

    address provider;
    address client;
    string memo;
    string dateCreated;
    string dateDue;
    Status status;
    uint balance;

    mapping(uint256 => Item) private items;
    uint public itemCount;

    // Basic function for creating an invoice
    constructor(address _provider, address _client, string memory _memo, string memory _dateCreated, string memory _dateDue) {
        provider = _provider;
        client = _client;
        memo = _memo;
        dateCreated = _dateCreated;
        dateDue = _dateDue;
        status = Status.PENDING;
        balance = 0;
    }

    function addItem(string memory _service, string memory _activity, uint _amount) public {
        Item storage item = items[itemCount];

        item.id = itemCount;
        item.service = _service;
        item.activity = _activity;
        item.amount = _amount; // Amount in represented in Wei = 0.000000000000000001 eth

        balance += _amount;
        itemCount++;
    }

    function getItem(uint256 _id) public view returns(uint256, string memory, string memory, uint) {
        Item storage item = items[_id];
        return (
            item.id,
            item.service,
            item.activity,
            item.amount
        );
    }

    function pay() public payable {
        require(address(msg.sender) == client);
        require(status == Status.PENDING, "Error: invoice is has not met required pending status");
        // Maybe use an assert to say if declined or paid
        // require(msg.value == invoice.balance, "Error: sent value has not meant required balance");
        status = Status.PAID;
    }

    function decline() public {
        require(address(msg.sender) == client);
        require(status == Status.PENDING, "Error: invoice is has not met required pending status");
        // Maybe use an assert to say if declined or paid
        // require(msg.value == invoice.balance, "Error: sent value has not meant required balance");
        status = Status.DECLINED;
    }


    function getSummary() public view returns(address, address, string memory, string memory, string memory, Status, uint) {
        // FUTURE: add items (could be count or all items)
        return (
            provider,
            client,
            memo,
            dateCreated,
            dateDue,
            status,
            balance
        );
    }
}
