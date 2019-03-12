pragma solidity ^0.5.0;

contract ExampleProblem {

    address owner;

    constructor() public {
        owner = msg.sender;
    }

    event claim_processed(address claimant, bool[5] candidate, uint8 weight, uint8 value, uint prize_wei_value);
    event claim_failed(address claimant, bool[5] candidate, uint8 weight, uint8 value);

    function compute_weight(bool[5] memory candidate) private pure returns (uint8 weight) {
        if (candidate[0]) weight += 12;
        if (candidate[1]) weight += 2;
        if (candidate[2]) weight += 1;
        if (candidate[3]) weight += 1;
        if (candidate[4]) weight += 4;
    }
    
    function compute_value(bool[5] memory candidate) private pure returns (uint8 value) {
        if (candidate[0]) value += 4;
        if (candidate[1]) value += 2;
        if (candidate[2]) value += 2;
        if (candidate[3]) value += 1;
        if (candidate[4]) value += 10;
    }

    function claim(bool[5] calldata candidate) external {
        uint8 weight = compute_weight(candidate);
        uint8 value = compute_value(candidate);
        if (value >= 13 && weight <= 6) {
            emit claim_processed(msg.sender, candidate, weight, value, address(this).balance);
            msg.sender.transfer(address(this).balance);
        } else {
            emit claim_failed(msg.sender, candidate, weight, value);
        }
    }

    function owner_address() external view returns (address _owner) {
        _owner = owner;
    }

    function check_balance() external view returns (uint balance) {
        balance = address(this).balance;
    }

    function withdraw_all() external {
        require(msg.sender == owner, "must be owner to wihdraw_all");
        msg.sender.transfer(address(this).balance);
    }

    function () external payable {}

}
