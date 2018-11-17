## Schema的安装和运行：

see https://jacksonisaac.wordpress.com/2014/03/25/installing-scheme-on-mac-os-x/

### 1. After drag the MIT/GNU *Scheme.app* into the Applications folder:

- For 32-bit package:
```bash
sudo ln -s /Applications/MIT\:GNU\ Scheme.app/Contents/Resources /usr/local/lib/mit-scheme-i386
```

- For 64-bit package:
```bash
sudo ln -s /Applications/MIT\:GNU\ Scheme.app/Contents/Resources /usr/local/lib/mit
```

### 2. Link mit-scheme.app to ‘scheme’ command in terminal:

- For 32-bit package:
```bash
sudo ln -s /usr/local/lib/mit-scheme-i386/mit-scheme /usr/bin/scheme
```

- For 64-bit package:
```bash
sudo ln -s /usr/local/lib/mit-scheme-x86-64/mit-scheme /usr/local/bin/scheme
```

Then simply type `scheme` in terminal to use

### Quit scheme with either of those 2:
Two Scheme procedures that you can call.
- The first is to evaluate `(exit)`, which will **halt** the Scheme system, after first requesting confirmation. Any information that was in the environment is lost, so this should not be done lightly.
- The second procedure **suspends** Scheme; when this is done you may later restart where you left off. Unfortunately this is not possible in all operating systems; currently it works under unix versions that support job control (i.e. all of the unix versions for which we distribute Scheme). To suspend Scheme, evaluate `(quit)`

退出：或者直接`control + d`

退出errors: `control + g`