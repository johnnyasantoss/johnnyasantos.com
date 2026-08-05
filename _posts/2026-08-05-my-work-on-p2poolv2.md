---
layout: post
title: What I've been up to
date: '2026-08-05 00:00:00'
category: blog
lang: en
---

A quick update on what I'm working on

<!--end-excerpt-->

# What I've been up to

On [March 17th][grant-post] [(archive)][grant-post-a], I joined
[Vinteum][vinteum] with the mission to
help build the open-source mining software stack.
More specifically, to work on the [p2poolv2][p2pv2] project
that was being maintained almost solely by [Jungly][pool2win].

I'm thankful to [Vinteum][vinteum] for being supportive of my work
and this cause that's so dear to me and that I
believe is the main driving force of Bitcoin, mining. Without it,
there would never be such a decentralized and
permissionless money that I and many more believe in.

My first few contributions to the p2poolv2 project were mostly
focused on tooling and small bugs I found
while attempting to implement a Proof of Concept (PoC) for
[Bitcoin Dev Launchpad (BDL)][bdl] [(archive)][bdl-a].
My PoC, in turn, was something that I thought would be a
somewhat simple task to do: implement high-bandwidth
compact relay on p2poolv2. [BIP 152][bip152] describes most
of how the messages and data flows are expected,
but adapting it to p2poolv2's network turned out to be the opposite
of simple.
The PoC was going to stay around for much longer than I wanted,
but mostly because we had a lot of divergences
in work priority over the months. As it stands, it's very close
to getting merged, but more importantly, getting it right.

During these past four months, my contributions ranged from better
grasping the whole codebase and the technical motivations behind
protocol decisions in p2poolv2 to helping out Vinteum Fellows,
participating in and guiding Casa21 Deep Dives.
I believe my efforts were well received and
made a good general impact.

I'll dive into more detail for each area of contribution below.

---

# P2PoolV2

## Ensuring p2poolv2 works everywhere

To be able to better run, test, and poke around with the p2poolv2
node implementation, I started with a first batch of issues/PRs
focusing on containerization, configuration, and other minor
correctness fixes.

I kept participating in our weekly calls (which, btw, are great
for debating and unlocking protocol design) and giving feedback
where possible.

## Making IBD and Sync better

My efforts in compact block relay started bubbling doubts and
concerns about how other parts of our syncing code were actually
running under real network environments. We set out to test
hypotheses and check whether the nodes would sync, get headers,
talk, work under stress, and react to uncle blocks and other edge cases.
As we decided on a way to better test and gather real logs/data
on the node, we started running nodes for [testnet4][t4].
This worked out great as we found tens of bugs and validated a
lot of hypotheses there.

Right now, syncing a new node takes around `~8 min` to `20k height`
at `<80 MiB RAM and 8% of 2 vCPU`. There's probably a lot of room
for improvement, but this is not bad at all, considering we
were just focusing on sanding down the rough edges.

There were even some optimizations for [`getblocktemplate`][getblocktemplate]
we found while trying out a new upstream [Bitcoin Core][bitcoin-core]
node (testing out testnet4 resiliency with a custom `bitcoind`-subject
for yet another post).

## P2Poolv2 running on Vinteum's lab

Vinteum has its own infra for testing, fuzzing, and hosting
Bitcoin-development-related systems. They generously allowed me to run one of
those instances on their infrastructure.

So far, we found bugs with this node: header sync, RocksDB config, block
confirmation, buffers, confirmation parallelization, disconnected headers,
libp2p quirks, and more.

This was also a source for a lot of deployment, configuration, and CI-related
debates, issues, and fixes.

## Pre-Telehash4 improvements and more testing

[256Foundation][256f] holds the [Telehash][telehash], a hashrate donation
marathon, with the goal of raising funds to keep developing the
open-source mining software stack.

For this, they use [Hydrapool][hydrapool], essentially a
networkless p2poolv2 node, which led us to the opportunity to focus on
improving the Stratum server for thousands of simultaneous connections. Most
fixes were delivered by [Jungly][pool2win].

I contributed a few PRs and debugging/testing issues on this subject.

## Deployment and CI/CD

I had been using [Docker][docker]/[Podman][podman] for deploying Vinteum's node
so far but had not really
made all of that prebuilt and published via CI.
So I bundled what I had, rewrote Dockerfiles,
and tested across multiple architectures to get the
CI launching a prebuilt image. Now, you can just
run p2poolv2 easily. I'll make another post _soon 🔜_ on
how to run p2poolv2 _mostly_ everywhere.

## IPC and Cap'n Proto

In one of our weekly calls, we
started talking about testing the [new experimental API][bitcoin-core-ipc] on Bitcoin
Core, the [Cap'n Proto RPC][capnproto-rpc], named IPC (even
though it's not really **inter-process**). This experimental subsystem
on Bitcoin's codebase is trying to allow for faster and more efficient
communication with the Bitcoin node for integrators.

To be able to test that in p2poolv2, I had to first create a client that would
be compatible with the actor model that's used around the codebase.
The [`capnp-rpc` crate][capnp-rpc-crate] that's used elsewhere has a strict
requirement that you
must use a [`local-rt`][tokio-local-runtime] (local async runtime from
[Tokio][tokio]), and that's
incompatible with p2poolv2.
That client came to be the [`bitcoin-capnp`][bitcoin-capnp] crate, a fork of
[`sv2-bitcoin-core`][sv2-bitcoin-core] (created by [Plebhash][plebhash]). Still
very early days,
but I'm experimenting with creating an actor-based client to remove
that requirement and integrate both as a side quest.

## Blocks, blocks, blocks

In the midst of all the testing and fixing, we've hit
multiple blocks already, in
[Testnet4][testnet4-blocks] and [Testnet3][testnet3-blocks] with
the test nodes (they only have 2-3 [BitAxes][bitaxe]).

For testnet3, I've added a custom genesis block and created a
custom network,
but I believe there's not much value in upstreaming those
changes, as testnet3 is **deprecated** and a ghost town nowadays.

All of this just proves how p2poolv2 works in the wild and how
the payout distribution works great with the decentralized PPLNS.

---

# Working with the Vinteum Fellows

One great thing about being a **Vinteum Grantee** is that I get to share and
learn from the other grantees and fellows.
This has shown to be an immense opportunity for personal and professional
growth, as well as for numerous other learnings.

From a quick Discord session talking about an unknown _(to me)_
concept to Edil's deep dives with the fellows, cracking open
the most complex concepts, projects, libraries, and other things
in the Bitcoin space, I've been blessed with great colleagues and
friends from this experience.

## Reviews

One of the most **underrated** things in enterprise software development is
reviews. Nowadays, it has been mostly taken over by a `trust, don't verify`
ethos of the AI FOMO, but it really shines in _BOSS_[^boss].

I reviewed a lot of code during these first few months, and more often than not,
out of my normal reach. This forced me to learn, ask questions, read, chat
about it, pair review. \
We-grantees, fellows, and I-hopped over to Vinteum's Discord and started
sessions reviewing code, ideas, and concepts. This was great to be able to share
and help others develop a keen eye for specific details.

One that stuck with me was testing Jayr's [Mujina][mujina] PR.
That day, we were able to dive deeply into PID internals and comprehend
how to play with the parameters to find suitable values for running
[BitAxe Raw][bitaxe-raw] on [Mujina][mujina] without frying the board.
This type of collaboration helps immensely as we:

1. build and share knowledge
1. ensure a more robust implementation across projects
1. share good resources across projects (something that's hard without
companies behind projects)

## Deep Dives

In June, we had a few deep-dive sessions at [Casa21][casa21]
with Vinteum's directors, grantees, and fellows.
It was a great opportunity to shift our focus from direct
implementation and research to related areas of interest.
We studied BIPs, libraries, and other systems in the space,
then reviewed code, debated ideas, and wrote about what we found.

A few subjects we covered:

- **[SwiftSync][swiftsync]**: useful for understanding the
trade-offs of faster block synchronization.
- **[OP_CTV][bip119] / [TemplateHash][bip446]**: Transaction
templating is just what we need for scaling payouts.
- **[Bitcoin Core compact block prefill][compact-prefill]**:
connected upstream relay design with ours and the
testing work in p2poolv2.
- **[Bitcoin Core's `libbitcoinkernel`][rust-bitcoinkernel]**:
sparked ideas for integrating block validation
and chain events.

These sessions were useful because they were not just
presentations. We opened
the code, challenged assumptions, and tried to understand
what would happen
under hostile or unusual network conditions. That work
influenced how I
approached p2poolv2's sync logic, Bitcoin Core IPC, and the
edge cases we tested on testnet4.

## Next?

My work began with compact block relay, but along the way, I
found myself pulled into several other side quests and bug hunts.
I'm focusing on getting that over the finish line.
Nodes now can sync properly on testnet4,
deployment pipelines should reduce the barrier for entry, and the
IPC work has just started.

Now I understand much better how the whole system interacts with
synchronization, block templates,
network edge cases and the rest of the mining
stack. The next step is to bring
those pieces together, finish the relay
implementation and keep making
p2poolv2 easier to run, test and contribute to.

Let's see what the future holds…

[^boss]: Bitcoin Open Source Software

[bdl-a]: https://web.archive.org/web/20250522123752/https://vinteum.org/bdl/
[bdl]: https://www.vinteum.org/programs/bitcoin-dev-launchpad
[bip119]: https://github.com/bitcoin/bips/blob/master/bip-0119.mediawiki
[bip152]: https://bips.dev/152/
[bip446]: https://github.com/bitcoin/bips/blob/master/bip-0446/README.md
[bitaxe]: https://github.com/skot/bitaxe
[bitaxe-raw]: https://github.com/bitaxeorg/bitaxe-raw
[bitcoin-capnp]: https://github.com/johnnyasantoss/bitcoin-capnp
[bitcoin-core]: https://github.com/bitcoin/bitcoin
[bitcoin-core-ipc]: https://github.com/bitcoin/bitcoin/blob/master/doc/multiprocess.md
[capnp-rpc-crate]: https://crates.io/crates/capnp-rpc
[capnproto-rpc]: https://capnproto.org/rpc.html
[casa21]: https://casa21.vinteum.org/
[compact-prefill]: https://github.com/bitcoin/bitcoin/pull/35558
[docker]: https://www.docker.com/
[getblocktemplate]: https://developer.bitcoin.org/reference/rpc/getblocktemplate.html
[grant-post-a]: https://archive.is/Fzgin
[grant-post]: https://x.com/Vinteum_org/status/2033948543283556626
[hydrapool]: https://github.com/256foundation/hydrapool
[mujina]: https://www.256foundation.org/projects/mujina
[p2pv2]: https://github.com/p2poolv2/p2poolv2
[plebhash]: https://github.com/plebhash
[podman]: https://podman.io/
[pool2win]: https://github.com/pool2win
[rust-bitcoinkernel]: https://github.com/sedited/rust-bitcoinkernel/pull/192
[256f]: https://www.256foundation.org
[sv2-bitcoin-core]: https://github.com/plebhash/sv2-bitcoin-core
[swiftsync]: https://github.com/bitcoin/bips/pull/2152
[t4]: https://web.archive.org/web/20260528205757/https://www.testnet4.dev/
[telehash]: https://www.256foundation.org/telehash
[testnet3-blocks]: https://mempool.space/testnet/address/2NFqJaeYFTVXTZLWvfLb7cwbkmV1tDcYBdM
[testnet4-blocks]: https://mempool.space/testnet4/address/tb1qwv4k2jzjztypn54qafzw6ka8eav26lyuuj6e0n
[tokio-local-runtime]: https://docs.rs/tokio/latest/tokio/runtime/struct.LocalRuntime.html
[tokio]: https://tokio.rs/
[vinteum]: https://vinteum.org
