## Staking

#### what is staking:

- it is act of storing your crypto currencties in exchange of rewards.
- this acutally helps the system to be secure
- recent ETH is moving from POW to POS and this uses 99.95% less energy
- in simple terms send tokens to `some wallet/contract` and earn rewards

#### how staking generate revenue

When you stake your crypto assets, you become a transaction validator, or node, for the network. This is very important to the network’s functionality and security, which is why stakers receive financial incentives to keep doing it.

> src: https://www.coinbase.com/learn/crypto-basics/what-is-staking

The reason your crypto earns rewards while staked is because the blockchain puts it to work. Cryptocurrencies that allow staking use a “consensus mechanism” called Proof of Stake, which is the way they ensure that all transactions are verified and secured without a bank or payment processor in the middle. Your crypto, if you choose to stake it, becomes part of that process.

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

## Staking rewards calculation `based on synthetix protocol`

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

- ### How this works

  - user come and stake [Matic] on a content creator

    - Learning Blockchain
    - Learing defi
    - creators for xyz

  - these staks generates rewards token and protocol distributed these rewards token in %
    - 70% goes to content creator
      - #### Benifits
        - getting rewards as this will get better as more and more use join his content
        - more staking on a contet more rewards from everyone
    - 30% goes to user who stakes
      - #### Benifits
        - user consume the content and enjoy and learn form it
        - also generate passive income by supporting the creator at same time getting value

# what is synthetix assets?

> Src: https://www.youtube.com/watch?v=vl4WRFo3hjg

for exampele:
cost of 1 kg gold is 50USD to to create synthetix gold [S]GOLD you need to put 100 USD to it is 100% collateralised so

- if `price increase` of GOLD by 200 USD we need to 100USD to create [S]GOLD
- similarly if `price decrease` by 50 USD we need to put 100 USD to creat S[GOLD]

This is called over-collatralised `colat`

This acutally solve 2 big problems in crypto space

- no need to trust any one to "holds" for collatral because those are not acutal gold they are real time price of it
- or not to need it which is expensive

- ## what is synthetix protocol

  - A protocol that generates synthextix assets on ETH, it can be any things GOLD,SILVE,BTC,ETH.
  - So here we have SYX token and it higley colat so generally to create
    - 1$ worth of syn assest we need to 7$ worth of SYX

- ## Exmaple

  - Alice put 700 SYX to get 10$ worth of GOLD where is 10$ = [1] GOLD
  - Bob put 700 SYX to get 10$ worth of SILVER where is 5$ = [1] SILVER

  so total money in the system is 20$ which is called the `the global debt pool`

  ^ here both Alice and Bob contributed 50-50% each

  so some how price of silver exploed to 10$ =

  so as you can see gold is same 10$ and silver is 20$ so now bob hold 2 S[SILVER] his value is money is 20$

  so total `the global debt pool` worth around 30$

  but now ^ share of Bob > Alice

  but still alice owns the 50% of `the global debt pool` 15$ but she put 10$ so now she owe `loss` 5$ to system

  while Bob owns the 50% and he puts 10$ and now `the global debt pool` so he makes 5$ profits

  so this is the heart of synthetix where 1 person profit is others loss and this is called `trading competition`
