---
title: Minesploit - Bitcoin White Hat Security Framework
event: Bitcoin++ Exploits Edition
location: Florianópolis, SC, BR
date: 2026-02-28
description: Security research framework for Bitcoin mining infrastructure. Won first place at the hackathon.
slides_url: /assets/presentations/minesploit.pdf
license: CC-BY-SA 4.0
---

Security research framework for Bitcoin mining infrastructure with a
hypothesis-first design. Spin up a Stratum server, connect a real CPU miner,
test your attack.

See it in action:

```python
pool = StratumServer().start()
miner = CPUMiner(pool=pool).start()
```

Now you're mining with real hashrate, ready to test your hypothesis.

While stress-testing Stratum V2 we discovered a vulnerability in share
accounting. Responsible disclosure is in progress.

We won first place at the Bitcoin++ Exploits Edition hackathon in Florianópolis
alongside [Lucas Balieiro][lucasb] and [Jayr Motta][jayrmotta].

I'll be writing more about the event and my participation in BDL (Bitcoin
Developer Launchpad from [VinteUm][vinteum]) soon.

For those who believe in Bitcoin's mission, securing the infrastructure is
paramount. The freethinkers and forgotten who rely on uncensorable money
deserve a robust, secure network.

## Links

- [Hackathon][hackathon]
- [Our Submission][application]
- [Stacker.news Discussion][stackernews]
- [VinteUm][vinteum]
- [Lucas Balieiro][lucasb]
- [Jayr Motta][jayrmotta]

[vinteum]: https://vinteum.org/
[stackernews]: https://stacker.news/items/1444653?commentId=1444725
[lucasb]: https://github.com/lucasbalieiro
[jayrmotta]: https://github.com/jayrmotta
[hackathon]: https://loot.fund/hackathons/bitcoin-exploits-edition
[application]: https://loot.fund/hackathons/bitcoin-exploits-edition/applications/3
