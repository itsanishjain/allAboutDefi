// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract StakeLabs {
    IERC20 public immutable rewardsToken;

    address public owner;

    // Fee
    uint256 public hundred = 100 * 10**18;
    uint256 public creatorFee = 80 * 10**18;
    uint256 public protocolFee = 5 * 10**18;

    // remaing goes to staker = 100 - (80+5)

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
    // User address => rewardPerTokenStored
    mapping(address => uint256) public userRewardPerTokenPaid;
    // User address => rewards to be claimed
    mapping(address => uint256) public rewards;

    // Total staked
    uint256 public totalSupply;

    // creatorAddress=>(userAddress=>amountStaked)
    mapping(address => mapping(address => uint256)) balanceOf;

    constructor(address _rewardToken) {
        owner = msg.sender;
        rewardsToken = IERC20(_rewardToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    modifier updateReward(address creatorAddress, address _account) {
        rewardPerTokenStored = rewardPerToken();
        updatedAt = lastTimeRewardApplicable();

        if (_account != address(0)) {
            rewards[_account] = earned(creatorAddress, _account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
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

    function withdraw(address creatorAddress, uint256 _amount)
        external
        updateReward(creatorAddress, msg.sender)
    {
        require(_amount > 0, "amount = 0");
        balanceOf[creatorAddress][msg.sender] -= _amount;

        uint256 protocolShare = (protocolFee * _amount) / hundred;
        _amount -= protocolShare;

        uint256 creatorShare = (_amount * creatorFee) / hundred;
        _amount -= creatorShare;

        // at this point _amount = userShare
        totalSupply -= _amount - creatorShare;

        // transfer native tokens

        (bool sent1, ) = payable(creatorAddress).call{value: creatorShare}("");
        (bool sent2, ) = payable(msg.sender).call{value: _amount}("");

        require(sent1, "WithdrawError");
        require(sent2, "WithdrawError");

        // if stakingToken is ERC20 Tokens
        // stakingToken.transfer(msg.sender, _amount);
    }

    function earned(address creatorAddress, address _account)
        public
        view
        returns (uint256)
    {
        return
            ((balanceOf[creatorAddress][_account] *
                (rewardPerToken() - userRewardPerTokenPaid[_account])) / 1e18) +
            rewards[_account];
    }

    function getReward(address creatorAddress)
        external
        updateReward(creatorAddress, msg.sender)
    {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
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
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
