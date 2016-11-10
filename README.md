# EtherealCereal

A private key, public key and address generator for the Ethereum cryptocurrency.

<small>[source](https://www.youtube.com/embed/nLF1Erk1_rQ)</small>

## Usage

You can create a new instance of `EtherealCereal`, this will let you generate a new private key, public key and address from scratch.

```swift
let etherealCereal = EtherealCereal()
print(etherealCereal.privateKey)
print(etherealCereal.publicKey)
print(etherealCereal.address)
```

You can easily sign messages:

```swift
etherealCereal.sign(message: "I'm signing this message now.")
```

🎉 And that’s it! 🎉

## Dependencies

### Integration

EtherealCereal doesn’t depend on anything to be integrated on your app. Just use Carthage or build the framework yourself and integrate manually. Should be simple enough.

You can instantiate a new `EtherealCereal` object, and create a new private key from scratch, it will also allow you to derive the public key and Ethereum address from it. You can also instantiate it with a private key string directly, if a user already exists. It will derive the address and public key from that private key.

### Development

Development is a bit more complicated. It currently depends on [secp256k1](https://github.com/bitcoin-core/secp256k1) for the key and address generation, and signing messages. Check how to build them for iOS below.

For the Keccak-256, we embed [this version here](https://github.com/coruus/saarinen-keccak).

#### How to update libsecp256k1 for iOS/Simulator

If it ever comes that we need to update this repo, here are the steps to do that:

You'll need [iOS-autotools](https://github.com/Elland/ios-autotools), this will simplify configuring and compiling for each of the target architectures and then combining it all into a single fat binary framework.

Inside the `secp256k1` folder, run the following:

```zsh
ARCHS="armv7 armv7s arm64 x86_64 i386" autoframework Ether libsecp256k1.a --enable-module-recovery
```

Breaking it down:

```zsh
ARCHS="armv7 armv7s arm64 x86_64"
```

This specifies the target architectures. If you’re not planning on supporting all of them, you can remove it. If Apple adds new CPU architectures, you can add it.

```zsh
autoframework Ether libsecp256k1.a
```

`autoframework` is called with two arguments. The target Framework name (here I picked `Ether`, but it’s up to you, really), and it needs to be pointed to the generated library (this will be always `libsecp256k1.a` for this case).

Every subsequent argument is passed through to the `./configure` call.

```zsh
--enable-module-recovery
```

Since `Ethereum` requires the recoverable signature form, we need to include the recovery module for `secp256k1`.

After a while, you’ll have the `Ether.framework` bundle inside a a `Frameworks` folder. Just move that to a project to use it. If you’re updating it for `EtherealCereal`, just replace it.
