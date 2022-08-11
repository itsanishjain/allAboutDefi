// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SimpleStaking {
    uint256 public rewardRatePerSecond = 1 * 10**18;
    uint256[] public totalStakedAmountAtTimeI;
    uint256 public rewardPerToken;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public userStakedAmount;
    mapping(address => uint256) public userStakingRewards;

    /* Rewards earn from k to n seconds by user u */
    function getReward(
        address user,
        uint256 k,
        uint256 n
    ) public {
        uint256 s;
        for (uint256 i; i < n; ) {
            s += rewardRatePerSecond / totalStakedAmountAtTimeI[i];
            unchecked {
                i++;
            }
        }
        rewardPerToken -= s;
        for (uint256 i; i < k - 1; ) {
            userRewardPerTokenPaid[user] +=
                rewardRatePerSecond /
                totalStakedAmountAtTimeI[i];
            unchecked {
                i++;
            }
        }
        uint256 totalRewardForUserU = userStakedAmount[user] *
            (rewardPerToken - userRewardPerTokenPaid[user]);
        userStakingRewards[user] = totalRewardForUserU;
    }
}
