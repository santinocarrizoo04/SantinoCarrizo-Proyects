## Useful Documentation

📜 [Project Specification](https://docs.google.com/document/d/1-AqFTroovEMcA1BfC2rriB5jsLE6SUa4mbcAox1rPec/edit)  
🧪 [Test Suite](https://docs.google.com/document/d/1XsBsJynoN5A9PTsTEaZsj0q3zsEtcnLgdAHOQ4f_4-g/edit)

## Deployment Instructions

### Prerequisites

Clone the deployment repository:

```bash
git clone https://github.com/sisoputnfrba/so-deploy.git
cd so-deploy
```

### Build and Configuration

Execute the deployment script with the required modules:

```bash
./deploy.sh -r=release -p=utils -p=kernel -p=cpu -p=memoria -p=entradasalida "tp-2024-1c-ChatGPT-CarreanOS"
```

Then configure the module network addresses and file system paths:

```bash
./configure.sh IP_XXX 192.168.x.xxx
./configure.sh PATH_XXXX /xxx/xxx
```

### Execution Order

Start the modules in the following sequence, providing the path to their configuration files:

1. **Memory**
2. **CPU**
3. **Kernel**
4. **I/O Interface**

---

[so-commons-library]: https://github.com/sisoputnfrba/so-commons-library
[so-deploy]: https://github.com/sisoputnfrba/so-deploy
