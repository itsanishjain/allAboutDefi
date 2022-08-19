// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakeLabs is Ownable {
    IERC20 public immutable rewardsToken;

    // Fee
    uint256 public hundred = 100 * 10**18;
    uint256 public creatorFee = 80 * 10**18;
    uint256 public protocolFee = 5 * 10**18;

    // Duration of rewards to be paid out (in seconds)
    uint256 public duration;
    // Timestamp of when the rewards finish
    uint256 public finishAt;
    // Minimum of last updated time and reward finish time
    uint256 public updatedAt;
    // Reward to be paid out per second
    uint256 public rewardRate;
    // Sum of (reward rate * dt * 1e18 / total supply)
    uint256 public rewardPerTokenStored;
    // Creator address => (user address=>reward paid)
    mapping(address => mapping(address => uint256))
        public userRewardPerTokenPaid;
    // User address => rewards to be claimed
    // creator address=>(user address=>reward claimed)
    mapping(address => mapping(address => uint256)) public rewards;

    // Total staked
    uint256 public totalSupply;

    // creatorAddress=>(userAddress=>amountStaked)
    mapping(address => mapping(address => uint256)) public balanceOf;

    event getAmount(string name, uint256 amt);

    constructor(address _rewardToken) {
        rewardsToken = IERC20(_rewardToken);
    }

    modifier updateReward(address creatorAddress, address _account) {
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();

        if (_account != address(0)) {
            rewards[creatorAddress][_account] = earned(
                creatorAddress,
                _account
            );
            userRewardPerTokenPaid[creatorAddress][
                _account
            ] = rewardPerTokenStored;
        }

        _;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return _min(finishAt, block.timestamp);
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }

        return
            rewardPerTokenStored +
            (rewardRate * (lastTimeRewardApplicable() - updatedAt) * 1e18) /
            totalSupply;
    }

    function stake(address creatorAddress)
        external
        payable
        updateReward(creatorAddress, msg.sender)
    {
        require(msg.value > 0, "amount = 0");
        balanceOf[creatorAddress][msg.sender] += msg.value;
        totalSupply += msg.value;
    }

    // unStake
    function withdraw(address creatorAddress, uint256 _amount)
        external
        updateReward(creatorAddress, msg.sender)
    {
        require(_amount > 0, "amount = 0");
        balanceOf[creatorAddress][msg.sender] -= _amount;
        totalSupply -= _amount;
        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        require(sent, "withdrawError");
    }

    function earned(address creatorAddress, address _account)
        public
        view
        returns (uint256)
    {
        return
            ((balanceOf[creatorAddress][_account] *
                (rewardPerToken() -
                    userRewardPerTokenPaid[creatorAddress][_account])) / 1e18) +
            rewards[creatorAddress][_account];
    }

    function getReward(address creatorAddress)
        external
        updateReward(creatorAddress, msg.sender)
    {
        uint256 reward = rewards[creatorAddress][msg.sender];
        if (reward > 0) {
            rewards[creatorAddress][msg.sender] = 0;

            uint256 protocolShare = (protocolFee * reward) / hundred;
            emit getAmount("protocolShare", protocolShare);
            reward -= protocolShare;

            uint256 creatorShare = (reward * creatorFee) / hundred;
            emit getAmount("creatorShare", creatorShare);
            reward -= creatorShare;

            emit getAmount("userShare", reward);

            rewardsToken.transfer(creatorAddress, creatorShare);
            rewardsToken.transfer(msg.sender, reward);
        }
    }

    function withdrawStakedNativeToken() public onlyOwner {
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, "withdrawError");
    }

    function setRewardsDuration(uint256 _duration) external onlyOwner {
        require(finishAt < block.timestamp, "reward duration not finished");
        duration = _duration;
    }

    function notifyRewardAmount(uint256 _amount)
        external
        onlyOwner
        updateReward(address(0), address(0))
    {
        if (block.timestamp >= finishAt) {
            rewardRate = _amount / duration;
        } else {
            uint256 remainingRewards = (finishAt - block.timestamp) *
                rewardRate;
            rewardRate = (_amount + remainingRewards) / duration;
        }

        require(rewardRate > 0, "reward rate = 0");
        require(
            rewardRate * duration <= rewardsToken.balanceOf(address(this)),
            "reward amount > balance"
        );

        finishAt = block.timestamp + duration;
        updatedAt = block.timestamp;
    }

    function _min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }

    function contractETHBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// owner: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// user: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
// creator: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
