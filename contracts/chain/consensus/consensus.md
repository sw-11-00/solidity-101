### Blockchain Consensus

- Determine two major functionalities
  - Who can write by creating a block?
    - Concurrent write: Multiple writers may write at the same time -> forks
  - If there is a fork because of multiple concurrent writes, who is the winner?
    - Fork-choice rule
- Security model
  - Token economy plays an important role!
  - A validator that does not follow the consensus will be penalized



## Proof Of Work

- Proof of Work

  - Who can write? Only the miner who solves a computational intensive puzzle
    - One liner: **H(block_template + nonce) < (2 \** 256 - 1) / diff**

  - Fork-choice rule: The longest chain (or greatest total difficulty chain) wins

- Well-proven security model

  - Block rewards are allocated to the miners **proportional to their hashpowers**
    - The miner does not following the greatest total difficulty rule will be **penalized**
  - Double-spending attack requires 51% hashpower of the network



## Proof Of Stake 1.0

### Motivation of Proof of Stake

- Block rewards are allocated to the stakers proportional to their stakes
- Energy efficiency
  - https://medium.com/@VitalikButerin/a-proof-of-stake-design-philosophy-506585978d51
- More decentralized? More secure?
  - https://vitalik.ca/general/2020/11/06/pos2020.html
- History of Proof of Stake
  - PoS 1.0: Chain-based Proof of Stake
    - PeerCoin, NextCoin, BlackCoin
    - Early Ethereum Serenity
    - Security model needs to be proved
      - Nothing at stake, staking grind, long-range attack, and fake stake
  - PoS 2.0: Byzantine-fault-tolerant-based Proof of Stake
    - Well-established security model
    - **BFT is the key part!**

### Chain-Based Proof of Stake

- Setup: A list of validators with stakes
  - [s_1, s_2, … , s_n] with S_j = sum_{i = 1}^{j} s_i，E.g., s_i = [100, 200, 50, 60] => [100, 300, 350, 410]
- For each block, calculate a pure random number to select a validator as the proposer
  - E.g., calculate r with 0 <= r <= \sum{s_i}, and find S_i < r < S_j
  - where j is the proposer with S_0 = 0
- Key problem: How to find r that is purely random
  - Hard to manipulate
- Chain-based => E.g., r = hash(prevblock, address, timestamp)
  - Easy to manipulate

### Attacks on Chain-Based PoS

- Staking grinding

  - Manipulate the random value to gain extra proposal rights (and thus more block rewards)

- Nothing at stake

  - Join every forks with almost zero costs
    - But more expected returns
  - Encourage more [forks](https://vitalik.ca/general/2017/12/31/pos_faq.html)

- Long range attack

  - Securely mine a fork with almost zero cost
  - Show the fork to perform double-spending attack

  

## PoS 2.0: BFT-Based PoS

Used by Ethereum 2.0, Tendermint/Cosmos

### What is BFT (Byzantine-Fault Tolerance)

- Setup of BFT algorithm
  - *n* parties
  - *f* parties are Byzantine
    - Crash at a random time
    - Error messages (Incorrect upgrade)
    - Collusion (Worst case)
    - *f* may not even know they are 
    - Byzantine
  - *n - f* parties are honest
  - Communication
    - P2P message passing
    - Sender of the message cannot be forged
  - Goal: *n - f* parties agree on a decision (e.g., a new block)
    - Non-goal: Find *f*
- Some achievable numbers
  - *n* = 4, *f* = 1
  - *n* = 25, *f* = 8
  - *n* = 100, *f* = 33

### Algorithms of BFT

- Famous algorithms
  - Practical BFT, M. Castro, OSDI99
  - **Tendermint - most mature and battle-tested BFT algorithm**
- Tendermint setup:
  - n = 3 f + 1 validators with *known public keys (or address)*
    - 1 proposer/leader (fixed at a specific height, may be Byzantine)
    - n - 1 replicas/followers
  - f validators are Byzantine and 2f + 1 are honest
- Goals:
  - **Safety: the system behaves as a centralized system**
    - A committed block cannot be reverted and the processed result is consistent among all honest nodes
  - **Liveness: a block will be eventually proposed and committed**

### Simple (But Wrong) Algorithm (Early EOS)

