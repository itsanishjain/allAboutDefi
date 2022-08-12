## Staking101

- YT: https://www.youtube.com/watch?v=b7F9q9Jsfvw

  - # Maths

    - (u,k,n) = `reward` earned by user `u` from `k to n seconds`

    Si - amount staked by user u at time = i
    Ti - total staked at time = i (assume Ti>0)
    R - reward rate per second (total rewards/duration)

    n-1
    E Si/Ti \* R
    i=k

    ^^ Uses lot of `gas`

    > let's make some more case

    - When `Si` is `constant` = S for time k to n-1
      n-1
      r(u,k,n) = S \* E R/Ti
      i=k

                      n-1         k-1
               = S *[ E   R/Ti -  E  R/Ti ]
                      i=0         i=0

  > 1st term in this ^ equation called `reward per token`

  > 2nd term is `user reward per token paid`

## Staking Example 1

> https://www.youtube.com/watch?v=oJOsdDJRNVw

`forumula used`
n-1
E Si/Ti \* R
i=k

anon stake 100 token at 3 seconds and withdraw it's at 6 seconds

at R = 1000/sec

so using ^ folmula

i = 3 => 100/100 _ 1000 = 1000
i = 4 => 100/100 _ 1000 = 1000
i = 5 = 100/100 \* 1000 = 1000
= 3000 Rewards token

## EX2

Alice stakes 100 for 4 sec, Bob stakss 200 for 5 sec. At Reaward rate/sec R

> Calculate r eward earned by Alice

## Complex maths

Ro = 0
Rj = `reward/token` term

define `reward/token` at time j

          j-1
    Rj =  E   R/Ti = 0 `if Ti is 0`
          i=0

when Ti = T for J0 <= i < j
Rj = R@j0 + R/T(j-j0)

`r@jo is prev value of [reward/token]` = ris `prev reward/token`

- Just write the example of ^ mention video

### `user reward/token paid`

Alice = r3,r9
Bob = r5,r11
Carol = r6,r10,r13

### `reward/token`

r3 = 0

r5 = r3 + R/100 (5-3) cause @ time t=5 total stake = 100 => r3 + 2R/100

r6 = r5 + R/300 (6-5) = 2R/100 + R/300

r9 = r6 + R/400 \* (9-6) = 2R/100 + R/300 + 3R/400

r10 = r9 + R/300 \* (10-9) = 2R/100 + 2R/300 + 3R/400

r11 = r10 + R/400 \* (11-10) = 2R/100 + 2R/300 + 4R/400

r13 = r11 + R/200 \* (13-11) = r11 + R/100

### `Reward Earned`

for Alice

- 100 \* (r9-r3) => 100(2R/100 + R/300 + 3R/400)

for Carol

- 100 \* (r10-r6) => R/300 + 3R/400
- 200 \* (r13-r10) =>

for Bob

- 200 \* (r11-r5)

# Staking Algorithm

> https://www.youtube.com/watch?v=NsKZZ3OrlSA

###### On Stake and withdraw

> Calculate reward per token

- r += R/ totalSupply \*(currentTime - last update time)

> Calculate reward earned by user

- rewards[user] += balanceOf[user] \* (r-userRewardPerTokenPaid[user])

> update user reward per token paid

- userRewardPerTokenPaid[user] = r

> update last update time reward/token was calculated

- last update time = current time

> update staked amount

- balanceOf[user] +/-= amount [+ for staking, - for withdrawing]

- totalSupply +/-= amount

## Idea

build a decentralised pateron where any one can support there favorite creator and earn rewards token for supporting them `seems cool na`
