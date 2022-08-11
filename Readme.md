## Staking101

- YT: https://www.youtube.com/watch?v=b7F9q9Jsfvw
    - # Maths
        - (u,k,n) = `reward` earned by user `u` from `k to n seconds`

        Si - amount staked by user u at time = i
        Ti - total staked at time = i (assume Ti>0)
        R  - reward rate per second (total rewards/duration)

        n-1 
        E    Si/Ti * R
        i=k

        ^^ Uses lot of `gas`
 
        > let's make some more case
        - When `Si` is `constant` = S for time k to n-1
                      n-1 
        r(u,k,n) = S * E  R/Ti
                      i=k

                        n-1         k-1 
                 = S *[ E   R/Ti -  E  R/Ti ]
                        i=0         i=0 
                          
    > 1st term in this ^ equation called      `reward per token`

    > 2nd term is `user reward per token paid`  



                    