# Config SSH Keys

You may need to connect multiple times to remote server such as github, gitlab or ibex let's say. We generally connect with them through SSH. To skip manually entering password each time we connect, we can setup ssh keys so that the remote server recognise your devise as a trusted client and directly allows the connection without the need of password. How to do it?

## Method 1:

### On Client Side
Public Private ssh keys are stored in `${HOME}/.ssh`. You can generate ssh key pair by
```bash
mkdir -p ${HOME}/.ssh
cd ${HOME}/.ssh
ssh-keygen
# When press enter-enter-enter when promted
```

This will create by default two files `id_rsa` and `id_rsa.pub`. `.pub` extension stands for that this is a public key and the file without extension is a private key. We need to add this public key to the remote server and then we can direcly access the remote system without using password. Just copy the content of this public key file `id_rsa.pub`

### On Server Side

We then connect with the server. If it is github, or gitlab we can directly login to the website, if it is IBEX we can do this as 

```bash
ssh -X userName@ilogin.ibex.kaust.edu.sa
```
We then just paste the copied content **remote server's** `authorized_keys` file. This `authorized_keys` file will be found in `${HOME}/.ssh/`. If the file does not exist you can manually create it.

*Keep in mind that the keys are pasted into `authorized_keys` file that is stored on the remote server and not on the client side.*

For platform like github and gitlab you can paste the public key by simply going to account `preferences` settings.

## Method 2: 

The drawback of previous method is that we only have single ssh key and we may need to share it with different platforms and it can lead to some security conserns. The alternative approach is to have different public private shh key pairs for different servers. We can generate different public private ssh-key pairs by specifying name of key when promted 

```bash
cd ${HOME}/.ssh
ssh-keygen 
# type name of the key when prompted e.g. id_rsa_github or id_rsa_ibex
```

This will generate public private key pair such as `id_rsa_github.pub` and `id_rsa_github`. Then you just need to copy the correspoing public key to appropriate server as we did previously but here the public key will be `id_rsa_github.pub` for example.

Other than that we also need to setup a configuration file so that our local system know which key to use for authentication while connecting to a perticualar server. This config file is stored as `${HOME}/.ssh/config` on our local system and the format is as follows 

```bash
# git@github.com:hello-arun
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa_github

# GitLab
Host gitlab.kaust.edu.sa
  HostName gitlab.kaust.edu.sa
  User git
  IdentityFile ~/.ssh/id_rsa_gitlab

# IBEX-khandev
Host ilogin.ibex.kaust.edu  .sa
  HostName ilogin.ibex.kaust.edu.sa
  User khandev
  IdentityFile ~/.ssh/id_rsa_ibex_khandev
```

## Happy SSH